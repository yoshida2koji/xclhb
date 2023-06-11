(uiop:define-package :xclhb-shape (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-shape)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "SHAPE")

(export 'op)

(deftype op () 'xclhb:card8)

(export 'kind)

(deftype kind () 'xclhb:card8)

(export '+so--set+)

(defconstant +so--set+ 0)

(export '+so--union+)

(defconstant +so--union+ 1)

(export '+so--intersect+)

(defconstant +so--intersect+ 2)

(export '+so--subtract+)

(defconstant +so--subtract+ 3)

(export '+so--invert+)

(defconstant +so--invert+ 4)

(export '+sk--bounding+)

(defconstant +sk--bounding+ 0)

(export '+sk--clip+)

(defconstant +sk--clip+ 1)

(export '+sk--input+)

(defconstant +sk--input+ 2)

(xclhb::define-extension-event notify +extension-name+ 0
 ((kind shape-kind) (xclhb:window affected-window) (xclhb:int16 extents-x)
  (xclhb:int16 extents-y) (xclhb:card16 extents-width)
  (xclhb:card16 extents-height) (xclhb:timestamp server-time)
  (xclhb:bool shaped) (pad bytes 11)))

(xclhb::define-extension-request query-version +extension-name+ 0 ()
 ((pad bytes 1) (xclhb:card16 major-version) (xclhb:card16 minor-version)))

(xclhb::define-extension-request rectangles +extension-name+ 1
 ((op operation) (kind destination-kind) (xclhb:byte ordering) (pad bytes 1)
  (xclhb:window destination-window) (xclhb:int16 x-offset)
  (xclhb:int16 y-offset) (list xclhb:rectangle (length rectangles) rectangles))
 ())

(xclhb::define-extension-request mask +extension-name+ 2
 ((op operation) (kind destination-kind) (pad bytes 2)
  (xclhb:window destination-window) (xclhb:int16 x-offset)
  (xclhb:int16 y-offset) (xclhb:pixmap source-bitmap))
 ())

(xclhb::define-extension-request combine +extension-name+ 3
 ((op operation) (kind destination-kind) (kind source-kind) (pad bytes 1)
  (xclhb:window destination-window) (xclhb:int16 x-offset)
  (xclhb:int16 y-offset) (xclhb:window source-window))
 ())

(xclhb::define-extension-request offset +extension-name+ 4
 ((kind destination-kind) (pad bytes 3) (xclhb:window destination-window)
  (xclhb:int16 x-offset) (xclhb:int16 y-offset))
 ())

(xclhb::define-extension-request query-extents +extension-name+ 5
 ((xclhb:window destination-window))
 ((pad bytes 1) (xclhb:bool bounding-shaped) (xclhb:bool clip-shaped)
  (pad bytes 2) (xclhb:int16 bounding-shape-extents-x)
  (xclhb:int16 bounding-shape-extents-y)
  (xclhb:card16 bounding-shape-extents-width)
  (xclhb:card16 bounding-shape-extents-height)
  (xclhb:int16 clip-shape-extents-x) (xclhb:int16 clip-shape-extents-y)
  (xclhb:card16 clip-shape-extents-width)
  (xclhb:card16 clip-shape-extents-height)))

(xclhb::define-extension-request select-input +extension-name+ 6
 ((xclhb:window destination-window) (xclhb:bool enable) (pad bytes 3)) ())

(xclhb::define-extension-request input-selected +extension-name+ 7
 ((xclhb:window destination-window)) ((xclhb:bool enabled)))

(xclhb::define-extension-request get-rectangles +extension-name+ 8
 ((xclhb:window window) (kind source-kind) (pad bytes 3))
 ((xclhb:byte ordering) (xclhb:card32 rectangles-len) (pad bytes 20)
  (list xclhb:rectangle rectangles-len rectangles)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+
  (list (list 0 #'read-notify-event)))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 8 #'read-get-rectangles-reply)
   (list 7 #'read-input-selected-reply) (list 5 #'read-query-extents-reply)
   (list 0 #'read-query-version-reply))))

