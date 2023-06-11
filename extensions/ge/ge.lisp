(uiop:define-package :xclhb-ge (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-ge)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "Generic Event Extension")

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card16 client-major-version) (xclhb:card16 client-minor-version))
 ((pad bytes 1) (xclhb:card16 major-version) (xclhb:card16 minor-version)
  (pad bytes 20)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 0 #'read-query-version-reply))))

