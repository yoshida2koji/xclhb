(uiop:define-package :xclhb-xc_misc (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-xc_misc)

(xclhb:defglobal +extension-name+ "XC-MISC")

(xclhb::define-extension-request get-version +extension-name+ 0
 ((xclhb:card16 client-major-version) (xclhb:card16 client-minor-version))
 ((pad bytes 1) (xclhb:card16 server-major-version)
  (xclhb:card16 server-minor-version)))

(xclhb::define-extension-request get-xidrange +extension-name+ 1 ()
 ((pad bytes 1) (xclhb:card32 start-id) (xclhb:card32 count)))

(xclhb::define-extension-request get-xidlist +extension-name+ 2
 ((xclhb:card32 count))
 ((pad bytes 1) (xclhb:card32 ids-len) (pad bytes 20)
  (list xclhb:card32 ids-len ids)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 2 #'read-get-xidlist-reply) (list 1 #'read-get-xidrange-reply)
   (list 0 #'read-get-version-reply))))

