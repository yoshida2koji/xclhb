(in-package :xclhb)

(export '(with-connected-client  wait-event
          card32->card8-vector card8-vector->card32-vector
          card8-vector->card16-vector
          intern-atom-sync get-property-sync
          keycode->keysym
          init-extension extension-info extension-event-base
          extension-error-base extension-major-opcode
          set-keycode-keysym-table
          set-extension-event-handler
          set-extension-error-handler))

(defmacro with-connected-client ((client &optional host) &body body)
  `(multiple-value-bind (,client err) (x-connect ,host)
     (when err
       (error "connection error ~a" err))
     (unwind-protect
          (progn
            ,@body)
       (x-close ,client))))

(defun wait-event (client events-codes &key timeout-seconds)
  (flush client)
  (when events-codes
    (let* ((event-handlers (client-event-handlers client))
           (pre-event-handlers (loop for code in events-codes
                                     collect (aref event-handlers code)))
           (event))
      (loop for code in events-codes
            do (setf (aref event-handlers code) (lambda (e) (setf event e))))
      (if (realp timeout-seconds)
          (loop :with start-time = (/ (get-internal-real-time) internal-time-units-per-second)
                :while (and (null event)
                            (< (-  (/ (get-internal-real-time) internal-time-units-per-second)
                                   start-time)
                               timeout-seconds))
                :do (loop :while (process-input-one client))
                    (sleep 0.01))
          (loop :until event
                :do (process-input-one client :wait-p t)))
      (loop for code in events-codes
            for pre-handler in pre-event-handlers
            do (setf (aref event-handlers code) pre-handler))
      event)))

(defun card32->card8-vector (atom)
  (let ((buf (make-buffer 4)))
    (setf (aref buf 0) (ldb (cl:byte 8 0) atom))
    (setf (aref buf 1) (ldb (cl:byte 8 8) atom))
    (setf (aref buf 2) (ldb (cl:byte 8 16) atom))
    (setf (aref buf 3) (ldb (cl:byte 8 24) atom))
    buf))

(defun card8-vector->card32-vector (vec)
  (let ((ret (make-array (floor (length vec) 4) :element-type 'card32)))
    (loop for i from 0 by 4
          for j from 0 below (length ret)
          do (setf (aref ret j) (read-card32 vec i)))
    ret))

(defun card8-vector->card16-vector (vec)
  (let ((ret (make-array (floor (length vec) 2) :element-type 'card16)))
    (loop for i from 0 by 2
          for j from 0 below (length ret)
          do (setf (aref ret j) (read-card16 vec i)))
    ret))


;; (defun intern-atom-sync (client atom-name)
;;   (let ((name (string->card8-vector atom-name)))
;;     (intern-atom-reply-atom (wait-reply client (lambda (cb) (intern-atom client cb 0 (length name) name))))))

;; (defun get-property-sync (client window property
;;                           &key (delete 0) (type 0) (long-offset 0) (long-length (1- (expt 2 32))))
;;   (wait-reply client (lambda (cb)
;;                        (get-property client cb delete window property type long-offset long-length))))

(defun set-keycode-keysym-table (client)
  (with-client (server-information keycode-keysym-table) client
    (with-setup (min-keycode max-keycode) server-information
      (multiple-value-bind (reply err)
          (wait-reply client (lambda (cb)
                               (get-keyboard-mapping client cb min-keycode (+ (- max-keycode min-keycode) 1))))
        (when err
          (error "Failed get-keyboard-mapping ~a" err))
        (setf keycode-keysym-table
              (let-get-keyboard-mapping-reply (keysyms-per-keycode keysyms) reply
                (loop :for i :from 0 :below (length keysyms) :by keysyms-per-keycode
                      :collect (cons (+ min-keycode (/ i keysyms-per-keycode))
                                     (loop :for j :from 0 :below keysyms-per-keycode
                                           :collect (aref keysyms (+ i j)))))))))))

(defun keycode->keysym (client keycode mod-state)
  (if-let (syms (cdr (assoc keycode (client-keycode-keysym-table client))))
    (let* ((n (if (logbitp +mod-mask--shift+ mod-state) 1 0))
           (sym (nth n syms)))
      (when (= sym 0)
        (setf sym (nth 0 syms)))
      (cond ((= sym 0) nil)
            ((>= sym #xff00)
             (cdr (assoc sym +keycode-keysym-table-non-character+)))
            (t
             (code-char sym))))))

(defun init-extension (client name)
  (multiple-value-bind (reply err)
      (wait-reply client (lambda (cb)
                           (query-extension client cb (length name) (string->card8-vector name))))
    (when err
      (error "Failed query-extension ~a" err))
    (unless (= 1 (query-extension-reply-present reply))
      (error "No such extension ~a" name))
    (if-let (old (assoc name (client-extension-table client) :test #'equal))
      (setf (cdr old) reply)
      (push (cons name reply) (client-extension-table client)))))

(defun extension-info (client name)
  (cdr (assoc name (client-extension-table client) :test #'equal)))

(defun extension-event-base (client name)
  (query-extension-reply-first-event (extension-info client name)))

(defun extension-error-base (client name)
  (query-extension-reply-first-error (extension-info client name)))

(defun extension-major-opcode (client name)
  (query-extension-reply-major-opcode (extension-info client name)))

(defun set-extension-event-handler (client extension-name code handler)
  (set-event-handler client (+ (extension-event-base client extension-name) code) handler))

(defun set-extension-error-handler (client extension-name code handler)
  (set-error-handler client (+ (extension-error-base client extension-name) code) handler))
