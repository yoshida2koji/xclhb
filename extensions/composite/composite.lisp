(uiop:define-package :xclhb-composite (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-composite)

(xclhb:defglobal +extension-name+ "Composite")

(export '+redirect--automatic+)

(defconstant +redirect--automatic+ 0)

(export '+redirect--manual+)

(defconstant +redirect--manual+ 1)

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card32 client-major-version) (xclhb:card32 client-minor-version))
 ((pad bytes 1) (xclhb:card32 major-version) (xclhb:card32 minor-version)
  (pad bytes 16)))

(xclhb::define-extension-request redirect-window +extension-name+ 1
 ((xclhb:window window) (xclhb:card8 update) (pad bytes 3)) ())

(xclhb::define-extension-request redirect-subwindows +extension-name+ 2
 ((xclhb:window window) (xclhb:card8 update) (pad bytes 3)) ())

(xclhb::define-extension-request unredirect-window +extension-name+ 3
 ((xclhb:window window) (xclhb:card8 update) (pad bytes 3)) ())

(xclhb::define-extension-request unredirect-subwindows +extension-name+ 4
 ((xclhb:window window) (xclhb:card8 update) (pad bytes 3)) ())

(xclhb::define-extension-request create-region-from-border-clip
 +extension-name+ 5 ((xclhb-xfixes:region region) (xclhb:window window)) ())

(xclhb::define-extension-request name-window-pixmap +extension-name+ 6
 ((xclhb:window window) (xclhb:pixmap pixmap)) ())

(xclhb::define-extension-request get-overlay-window +extension-name+ 7
 ((xclhb:window window))
 ((pad bytes 1) (xclhb:window overlay-win) (pad bytes 20)))

(xclhb::define-extension-request release-overlay-window +extension-name+ 8
 ((xclhb:window window)) ())

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 7 #'read-get-overlay-window-reply)
   (list 0 #'read-query-version-reply))))

