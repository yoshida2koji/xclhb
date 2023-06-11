(uiop:define-package :xclhb-bigreq (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-bigreq)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "BIG-REQUESTS")

(xclhb::define-extension-request enable +extension-name+ 0 ()
 ((pad bytes 1) (xclhb:card32 maximum-request-length)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 0 #'read-enable-reply))))

