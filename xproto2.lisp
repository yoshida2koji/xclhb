(in-package :xclhb)

(DEFINE-EVENT %CLIENT-MESSAGE 33
  ((CARD8 FORMAT) (WINDOW WINDOW) (ATOM TYPE) ))

(progn
  (export '+client-message-event+)
  (defconstant +client-message-event+ 33)
  (defstruct+ client-message-event (:export-all-p t :include x-event)
    (format 0 :type card8)
    (window 0 :type window)
    (type 0 :type atom)
    (data nil :type (or null
                        (simple-array card8 (20))
                        (simple-array card16 (10))
                        (simple-array card32 (5)))))
  (defun read-client-message-event (buffer offset)
    (let ((str (make-client-message-event)))
      (with-client-message-event (format window type) str
        (setf format (read-card8 buffer (offset-get offset)))
        (offset-inc offset 1) (offset-inc offset 2)
        (setf window (read-card32 buffer (offset-get offset)))
        (offset-inc offset 4)
        (setf type (read-card32 buffer (offset-get offset)))
        (offset-inc offset 4)
        (let* ((bytes (/ format 8))
               (data-len (/ 20 bytes))
               (type `(unsigned-byte ,format))
               (data (make-array data-len :element-type type))
               (reader (reader-of type)))
          (loop :for offset :from 12 :below 32 :by bytes
                :for i :from 0
                :do (setf (aref data i) (funcall reader buffer offset)))
          (setf (client-message-event-data str) data)))
      str))
  (setf (aref *read-event-functions* 33) #'read-client-message-event))

