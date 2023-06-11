(uiop:define-package :xclhb-xf86dri (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-xf86dri)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "XFree86-DRI")

(xclhb::define-struct drm-clip-rect
 ((xclhb:int16 x1) (xclhb:int16 y1) (xclhb:int16 x2) (xclhb:int16 x3)))

(xclhb::define-extension-request query-version +extension-name+ 0 ()
 ((pad bytes 1) (xclhb:card16 dri-major-version)
  (xclhb:card16 dri-minor-version) (xclhb:card32 dri-minor-patch)))

(xclhb::define-extension-request query-direct-rendering-capable
 +extension-name+ 1 ((xclhb:card32 screen))
 ((pad bytes 1) (xclhb:bool is-capable)))

(xclhb::define-extension-request open-connection +extension-name+ 2
 ((xclhb:card32 screen))
 ((pad bytes 1) (xclhb:card32 sarea-handle-low)
  (xclhb:card32 sarea-handle-high) (xclhb:card32 bus-id-len) (pad bytes 12)
  (list xclhb:char bus-id-len bus-id)))

(xclhb::define-extension-request close-connection +extension-name+ 3
 ((xclhb:card32 screen)) ())

(xclhb::define-extension-request get-client-driver-name +extension-name+ 4
 ((xclhb:card32 screen))
 ((pad bytes 1) (xclhb:card32 client-driver-major-version)
  (xclhb:card32 client-driver-minor-version)
  (xclhb:card32 client-driver-patch-version)
  (xclhb:card32 client-driver-name-len) (pad bytes 8)
  (list xclhb:char client-driver-name-len client-driver-name)))

(xclhb::define-extension-request create-context +extension-name+ 5
 ((xclhb:card32 screen) (xclhb:card32 visual) (xclhb:card32 context))
 ((pad bytes 1) (xclhb:card32 hw-context)))

(xclhb::define-extension-request destroy-context +extension-name+ 6
 ((xclhb:card32 screen) (xclhb:card32 context)) ())

(xclhb::define-extension-request create-drawable +extension-name+ 7
 ((xclhb:card32 screen) (xclhb:card32 drawable))
 ((pad bytes 1) (xclhb:card32 hw-drawable-handle)))

(xclhb::define-extension-request destroy-drawable +extension-name+ 8
 ((xclhb:card32 screen) (xclhb:card32 drawable)) ())

(xclhb::define-extension-request get-drawable-info +extension-name+ 9
 ((xclhb:card32 screen) (xclhb:card32 drawable))
 ((pad bytes 1) (xclhb:card32 drawable-table-index)
  (xclhb:card32 drawable-table-stamp) (xclhb:int16 drawable-origin-x)
  (xclhb:int16 drawable-origin-y) (xclhb:int16 drawable-size-w)
  (xclhb:int16 drawable-size-h) (xclhb:card32 num-clip-rects)
  (xclhb:int16 back-x) (xclhb:int16 back-y) (xclhb:card32 num-back-clip-rects)
  (list drm-clip-rect num-clip-rects clip-rects)
  (list drm-clip-rect num-back-clip-rects back-clip-rects)))

(xclhb::define-extension-request get-device-info +extension-name+ 10
 ((xclhb:card32 screen))
 ((pad bytes 1) (xclhb:card32 framebuffer-handle-low)
  (xclhb:card32 framebuffer-handle-high)
  (xclhb:card32 framebuffer-origin-offset) (xclhb:card32 framebuffer-size)
  (xclhb:card32 framebuffer-stride) (xclhb:card32 device-private-size)
  (list xclhb:card32 device-private-size device-private)))

(xclhb::define-extension-request auth-connection +extension-name+ 11
 ((xclhb:card32 screen) (xclhb:card32 magic))
 ((pad bytes 1) (xclhb:card32 authenticated)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 11 #'read-auth-connection-reply)
   (list 10 #'read-get-device-info-reply)
   (list 9 #'read-get-drawable-info-reply)
   (list 7 #'read-create-drawable-reply) (list 5 #'read-create-context-reply)
   (list 4 #'read-get-client-driver-name-reply)
   (list 2 #'read-open-connection-reply)
   (list 1 #'read-query-direct-rendering-capable-reply)
   (list 0 #'read-query-version-reply))))

