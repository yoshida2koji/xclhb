(in-package :xclhb)

(export '(client-open-p x-close flush))

(defstruct+ client ()
  (stream nil :type stream :read-only t)
  (server-information)
  (resource-id-base 0 :type (integer 0))
  (resource-id-count 0 :type (integer 0))
  (resource-id-list nil :type list)
  (resource-id-byte-spec)
  (request-sequence-number 1 :type (integer 0))
  (request-reply-callback-table)
  (output-buffer (make-buffer 1024) :type (simple-array card8 (*)) :read-only t)
  (input-buffer (make-buffer 1024) :type (simple-array card8 (*)) :read-only t)
  (event-handlers (make-array 256 :initial-element nil) :read-only t)
  (error-handlers (make-array 256 :initial-element nil) :read-only t)
  (default-error-handler)
  (keycode-keysym-table)
  (extension-table))


(defun client-open-p (client)
  (open-stream-p (client-stream client)))

(defun x-close (client)
  (close (client-stream client)))

(defun flush (client)
  (finish-output (client-stream client)))
