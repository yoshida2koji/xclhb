(in-package :xclhb)

(export '(with-connected-client wait-reply set-
          keycode-keysym-table keycode->keysym
          init-extension extension-info extension-event-base
          extension-error-base extension-major-opcode
          set-keycode-keysym-table))

(defmacro with-connected-client ((client) &body body)
  `(multiple-value-bind (,client err) (x-connect)
     (when err
       (error "connection error ~a" err))
     (unwind-protect
          (progn
            ,@body)
       (x-close ,client))))

(defmacro wait-reply (request-form)
  (let ((reply-sym (gensym "REPLY"))
        (error-sym (gensym "ERROR"))
        (client-sym (gensym "CLIENT"))
        (pre-error-handler-sym (gensym "PRE-ERROR-HANDLER"))
        (seq-no-sym (gensym "SEQ-NO")))
    `(let* ((,reply-sym)
            (,error-sym)
            (,client-sym ,(second request-form))
            (,pre-error-handler-sym (client-default-error-handler ,client-sym))
            (,seq-no-sym ,(append (list (first request-form)
                                    client-sym
                                    `(lambda (reply)
                                       (setf ,reply-sym reply)))
                              (nthcdr 3 request-form))))
       (setf (client-default-error-handler ,client-sym)
             (lambda (e)
               (when (= ,seq-no-sym (x-error-sequence-number e))
                 (setf ,error-sym e))))
       (flush ,client-sym)
       (sleep 0.001)
       (process-input ,client-sym)
       (loop :until (or ,reply-sym ,error-sym)
             :do (sleep 0.016)
                 (process-input ,client-sym))
       (setf (client-default-error-handler ,client-sym) ,pre-error-handler-sym)
       (values ,reply-sym ,error-sym))))

(defun set-keycode-keysym-table (client)
  (with-client (server-information keycode-keysym-table) client
    (with-setup (min-keycode max-keycode) server-information
      (multiple-value-bind (reply err)
          (wait-reply (get-keyboard-mapping client nil min-keycode (+ (- max-keycode min-keycode) 1)))
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
      (cond ((= sym 0) nil)
            ((>= sym #xff00)
             (cdr (assoc sym +keycode-keysym-table-non-character+)))
            (t
             (code-char sym))))))

(defun init-extension (client name)
  (multiple-value-bind (reply err)
      (wait-reply (query-extension client nil (length name) (string->card8-vector name)))
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

