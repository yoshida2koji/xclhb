(uiop:define-package :xclhb-big-requests
  (:use :cl :struct+ :xclhb)
  (:shadowing-import-from
   :xclhb
   :atom :byte :char :format))


(in-package :xclhb-big-requests)

(defglobal +extension-name+ "BIG-REQUESTS")

(define-extension-request enable-big-requests +extension-name+ 0
  ()
  ((pad bytes 1)
   (card32 maximum-request-length)
   (pad bytes 2)))

(export 'init)
(defun init (client)
  (init-extension client +extension-name+)
  (let ((major-opcode (extension-major-opcode client +extension-name+))
        (readers (make-array 1 :initial-element nil)))
    (setf (aref readers 0) #'read-enable-big-requests-reply)
    (setf (aref xclhb::*read-reply-functions* major-opcode) readers)))


