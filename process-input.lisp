(in-package :xclhb)

(export '(set-default-error-handler set-error-handler
          set-event-handler process-input))

;;; error
(defun set-default-error-handler (client handler)
  (setf (client-default-error-handler client) handler))

(defun set-error-handler (client code handler)
  (setf (aref (client-error-handlers client) code) handler))

(defun process-error (client buf)
  (let ((error-str (read-x-error buf)))
    (if-let (handler (or (aref (client-error-handlers client) (x-error-code error-str))
                         (client-default-error-handler client)))
      (funcall handler error-str))))

;;; reply
(defun process-reply (client buffer)
  (with-client (stream request-reply-callback-table) client
    (let* ((seq-no (read-card16 buffer 2))
           (length (read-card32 buffer 4))
           (additional-buffer-length (* 4 length))
           (total-buffer-length (+ 32 additional-buffer-length)))
      (let-reply-collback (major-opcode minor-opcode fn) (cdr (assoc seq-no request-reply-callback-table))
        (let* ((reader (aref *read-reply-functions* major-opcode))
               (offset (make-offset 1)))
          (declare (dynamic-extent offset))
          (when (arrayp reader)
            (setf reader (aref reader minor-opcode)))
          (when (> total-buffer-length (length buffer))
            (let ((new-buffer (make-buffer total-buffer-length)))
              (dotimes (i 32)
                (setf (aref new-buffer i) (aref buffer i)))
              (setf buffer new-buffer)))
          (when (> additional-buffer-length 0)
            (read-sequence buffer stream :start 32 :end total-buffer-length))
          (funcall fn (funcall reader buffer offset length))
          ;; remove callback
          (setf request-reply-callback-table (delete seq-no request-reply-callback-table :key #'car)))))))

;;; event
(defun set-event-handler (client code handler)
  (setf (aref (client-event-handlers client) code) handler))

(defun process-event (client code buf)
  (let ((%code (ldb (cl:byte 7 0) code )))
    (if-let ((reader (aref *read-event-functions* %code))
             (handler (aref (client-event-handlers client) %code)))
      (let ((offset (make-offset 1)))
        (declare (dynamic-extent offset))
        (funcall handler (funcall reader buf offset))))))


(defun process-input (client)
  (let-client (stream input-buffer) client
    (when (listen stream)
      (read-sequence input-buffer stream :end 32)
      (let ((type (read-card8 input-buffer 0)))
        (case type
          (0 (process-error client input-buffer))
          (1 (process-reply client input-buffer))
          (otherwise (process-event client type input-buffer))))
      (process-input client))))
