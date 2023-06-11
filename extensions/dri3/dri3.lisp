;; (uiop:define-package :xclhb-dri3 (:use :cl)
;;  (:import-from :xclhb :pad :bytes :align :bitcase))

(uiop:define-package :xclhb-dri3 (:use :cl)
                     (:import-from :xclhb :pad :bytes :align :bitcase)
                     (:shadow :open))

(in-package :xclhb-dri3)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "DRI3")

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card32 major-version) (xclhb:card32 minor-version))
 ((pad bytes 1) (xclhb:card32 major-version) (xclhb:card32 minor-version)))

(xclhb::define-extension-request open +extension-name+ 1
 ((xclhb:drawable drawable) (xclhb:card32 provider))
 ((xclhb:card8 nfd) (xclhb:card32 device-fd) (pad bytes 24)))

(xclhb::define-extension-request pixmap-from-buffer +extension-name+ 2
 ((xclhb:pixmap pixmap) (xclhb:drawable drawable) (xclhb:card32 size)
  (xclhb:card16 width) (xclhb:card16 height) (xclhb:card16 stride)
  (xclhb:card8 depth) (xclhb:card8 bpp) (xclhb:card32 pixmap-fd))
 ())

(xclhb::define-extension-request buffer-from-pixmap +extension-name+ 3
 ((xclhb:pixmap pixmap))
 ((xclhb:card8 nfd) (xclhb:card32 size) (xclhb:card16 width)
  (xclhb:card16 height) (xclhb:card16 stride) (xclhb:card8 depth)
  (xclhb:card8 bpp) (xclhb:card32 pixmap-fd) (pad bytes 12)))

(xclhb::define-extension-request fence-from-fd +extension-name+ 4
 ((xclhb:drawable drawable) (xclhb:card32 fence)
  (xclhb:bool initially-triggered) (pad bytes 3) (xclhb:card32 fence-fd))
 ())

(xclhb::define-extension-request fdfrom-fence +extension-name+ 5
 ((xclhb:drawable drawable) (xclhb:card32 fence))
 ((xclhb:card8 nfd) (xclhb:card32 fence-fd) (pad bytes 24)))

(xclhb::define-extension-request get-supported-modifiers +extension-name+ 6
 ((xclhb:card32 window) (xclhb:card8 depth) (xclhb:card8 bpp) (pad bytes 2))
 ((pad bytes 1) (xclhb:card32 num-window-modifiers)
  (xclhb:card32 num-screen-modifiers) (pad bytes 16)
  (list xclhb:card64 num-window-modifiers window-modifiers)
  (list xclhb:card64 num-screen-modifiers screen-modifiers)))

(xclhb::define-extension-request pixmap-from-buffers +extension-name+ 7
 ((xclhb:pixmap pixmap) (xclhb:window window) (xclhb:card8 num-buffers)
  (pad bytes 3) (xclhb:card16 width) (xclhb:card16 height)
  (xclhb:card32 stride0) (xclhb:card32 offset0) (xclhb:card32 stride1)
  (xclhb:card32 offset1) (xclhb:card32 stride2) (xclhb:card32 offset2)
  (xclhb:card32 stride3) (xclhb:card32 offset3) (xclhb:card8 depth)
  (xclhb:card8 bpp) (pad bytes 2) (xclhb:card64 modifier)
  (list xclhb:fd num-buffers buffers))
 ())

(xclhb::define-extension-request buffers-from-pixmap +extension-name+ 8
 ((xclhb:pixmap pixmap))
 ((xclhb:card8 nfd) (xclhb:card16 width) (xclhb:card16 height) (pad bytes 4)
  (xclhb:card64 modifier) (xclhb:card8 depth) (xclhb:card8 bpp) (pad bytes 6)
  (list xclhb:card32 nfd strides) (list xclhb:card32 nfd offsets)
  (list xclhb:fd nfd buffers)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 8 #'read-buffers-from-pixmap-reply)
   (list 6 #'read-get-supported-modifiers-reply)
   (list 5 #'read-fdfrom-fence-reply) (list 3 #'read-buffer-from-pixmap-reply)
   (list 1 #'read-open-reply) (list 0 #'read-query-version-reply))))

