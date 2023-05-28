(uiop:define-package :xclhb-xtest (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-xtest)

(xclhb:defglobal +extension-name+ "XTEST")

(xclhb::define-extension-request get-version +extension-name+ 0
 ((xclhb:card8 major-version) (pad bytes 1) (xclhb:card16 minor-version))
 ((xclhb:card8 major-version) (xclhb:card16 minor-version)))

(export '+cursor--none+)

(defconstant +cursor--none+ 0)

(export '+cursor--current+)

(defconstant +cursor--current+ 1)

(xclhb::define-extension-request compare-cursor +extension-name+ 1
 ((xclhb:window window) (xclhb:cursor cursor)) ((xclhb:bool same)))

(xclhb::define-extension-request fake-input +extension-name+ 2
 ((xclhb:byte type) (xclhb:byte detail) (pad bytes 2) (xclhb:card32 time)
  (xclhb:window root) (pad bytes 8) (xclhb:int16 root-x) (xclhb:int16 root-y)
  (pad bytes 7) (xclhb:card8 deviceid))
 ())

(xclhb::define-extension-request grab-control +extension-name+ 3
 ((xclhb:bool impervious) (pad bytes 3)) ())

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 1 #'read-compare-cursor-reply)
   (list 0 #'read-get-version-reply))))

