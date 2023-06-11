(uiop:define-package :xclhb-xevie (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-xevie)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "XEVIE")

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card16 client-major-version) (xclhb:card16 client-minor-version))
 ((pad bytes 1) (xclhb:card16 server-major-version)
  (xclhb:card16 server-minor-version) (pad bytes 20)))

(xclhb::define-extension-request start +extension-name+ 1
 ((xclhb:card32 screen)) ((pad bytes 1) (pad bytes 24)))

(xclhb::define-extension-request end +extension-name+ 2 ((xclhb:card32 cmap))
 ((pad bytes 1) (pad bytes 24)))

(export '+datatype--unmodified+)

(defconstant +datatype--unmodified+ 0)

(export '+datatype--modified+)

(defconstant +datatype--modified+ 1)

(xclhb::define-struct event ((pad bytes 32)))

(xclhb::define-extension-request send +extension-name+ 3
 ((event event) (xclhb:card32 data-type) (pad bytes 64))
 ((pad bytes 1) (pad bytes 24)))

(xclhb::define-extension-request select-input +extension-name+ 4
 ((xclhb:card32 event-mask)) ((pad bytes 1) (pad bytes 24)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 4 #'read-select-input-reply) (list 3 #'read-send-reply)
   (list 2 #'read-end-reply) (list 1 #'read-start-reply)
   (list 0 #'read-query-version-reply))))

