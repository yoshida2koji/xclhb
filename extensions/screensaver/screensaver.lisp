(uiop:define-package :xclhb-screensaver (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-screensaver)

(xclhb:defglobal +extension-name+ "MIT-SCREEN-SAVER")

(export '+kind--blanked+)

(defconstant +kind--blanked+ 0)

(export '+kind--internal+)

(defconstant +kind--internal+ 1)

(export '+kind--external+)

(defconstant +kind--external+ 2)

(export '+event--notify-mask+)

(defconstant +event--notify-mask+ 0)

(export '+event--cycle-mask+)

(defconstant +event--cycle-mask+ 1)

(export '+state--off+)

(defconstant +state--off+ 0)

(export '+state--on+)

(defconstant +state--on+ 1)

(export '+state--cycle+)

(defconstant +state--cycle+ 2)

(export '+state--disabled+)

(defconstant +state--disabled+ 3)

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card8 client-major-version) (xclhb:card8 client-minor-version)
  (pad bytes 2))
 ((pad bytes 1) (xclhb:card16 server-major-version)
  (xclhb:card16 server-minor-version) (pad bytes 20)))

(xclhb::define-extension-request query-info +extension-name+ 1
 ((xclhb:drawable drawable))
 ((xclhb:card8 state) (xclhb:window saver-window)
  (xclhb:card32 ms-until-server) (xclhb:card32 ms-since-user-input)
  (xclhb:card32 event-mask) (xclhb:byte kind) (pad bytes 7)))

(xclhb::define-extension-request select-input +extension-name+ 2
 ((xclhb:drawable drawable) (xclhb:card32 event-mask)) ())

(xclhb::define-extension-request set-attributes +extension-name+ 3
 ((xclhb:drawable drawable) (xclhb:int16 x) (xclhb:int16 y)
  (xclhb:card16 width) (xclhb:card16 height) (xclhb:card16 border-width)
  (xclhb:byte class) (xclhb:card8 depth) (xclhb:visualid visual)
  (xclhb:card32 value-mask)
  (bitcase value-mask ()
   ((xclhb:+cw--back-pixmap+) ((xclhb:pixmap background-pixmap)))
   ((xclhb:+cw--back-pixel+) ((xclhb:card32 background-pixel)))
   ((xclhb:+cw--border-pixmap+) ((xclhb:pixmap border-pixmap)))
   ((xclhb:+cw--border-pixel+) ((xclhb:card32 border-pixel)))
   ((xclhb:+cw--bit-gravity+) ((xclhb:card32 bit-gravity)))
   ((xclhb:+cw--win-gravity+) ((xclhb:card32 win-gravity)))
   ((xclhb:+cw--backing-store+) ((xclhb:card32 backing-store)))
   ((xclhb:+cw--backing-planes+) ((xclhb:card32 backing-planes)))
   ((xclhb:+cw--backing-pixel+) ((xclhb:card32 backing-pixel)))
   ((xclhb:+cw--override-redirect+) ((xclhb:bool32 override-redirect)))
   ((xclhb:+cw--save-under+) ((xclhb:bool32 save-under)))
   ((xclhb:+cw--event-mask+) ((xclhb:card32 event-mask)))
   ((xclhb:+cw--dont-propagate+) ((xclhb:card32 do-not-propogate-mask)))
   ((xclhb:+cw--colormap+) ((xclhb:colormap colormap)))
   ((xclhb:+cw--cursor+) ((xclhb:cursor cursor)))))
 ())

(xclhb::define-extension-request unset-attributes +extension-name+ 4
 ((xclhb:drawable drawable)) ())

(xclhb::define-extension-request suspend +extension-name+ 5
 ((xclhb:card32 suspend)) ())

(xclhb::define-extension-event notify +extension-name+ 0
 ((xclhb:byte state) (xclhb:timestamp time) (xclhb:window root)
  (xclhb:window window) (xclhb:byte kind) (xclhb:bool forced) (pad bytes 14)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+
  (list (list 0 #'read-notify-event)))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 1 #'read-query-info-reply) (list 0 #'read-query-version-reply))))

