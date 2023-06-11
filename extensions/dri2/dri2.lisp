(uiop:define-package :xclhb-dri2 (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-dri2)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "DRI2")

(export '+attachment--buffer-front-left+)

(defconstant +attachment--buffer-front-left+ 0)

(export '+attachment--buffer-back-left+)

(defconstant +attachment--buffer-back-left+ 1)

(export '+attachment--buffer-front-right+)

(defconstant +attachment--buffer-front-right+ 2)

(export '+attachment--buffer-back-right+)

(defconstant +attachment--buffer-back-right+ 3)

(export '+attachment--buffer-depth+)

(defconstant +attachment--buffer-depth+ 4)

(export '+attachment--buffer-stencil+)

(defconstant +attachment--buffer-stencil+ 5)

(export '+attachment--buffer-accum+)

(defconstant +attachment--buffer-accum+ 6)

(export '+attachment--buffer-fake-front-left+)

(defconstant +attachment--buffer-fake-front-left+ 7)

(export '+attachment--buffer-fake-front-right+)

(defconstant +attachment--buffer-fake-front-right+ 8)

(export '+attachment--buffer-depth-stencil+)

(defconstant +attachment--buffer-depth-stencil+ 9)

(export '+attachment--buffer-hiz+)

(defconstant +attachment--buffer-hiz+ 10)

(export '+driver-type--dri+)

(defconstant +driver-type--dri+ 0)

(export '+driver-type--vdpau+)

(defconstant +driver-type--vdpau+ 1)

(export '+event-type--exchange-complete+)

(defconstant +event-type--exchange-complete+ 1)

(export '+event-type--blit-complete+)

(defconstant +event-type--blit-complete+ 2)

(export '+event-type--flip-complete+)

(defconstant +event-type--flip-complete+ 3)

(xclhb::define-struct dri2buffer
 ((xclhb:card32 attachment) (xclhb:card32 name) (xclhb:card32 pitch)
  (xclhb:card32 cpp) (xclhb:card32 flags)))

(xclhb::define-struct attach-format
 ((xclhb:card32 attachment) (xclhb:card32 format)))

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card32 major-version) (xclhb:card32 minor-version))
 ((pad bytes 1) (xclhb:card32 major-version) (xclhb:card32 minor-version)))

(xclhb::define-extension-request connect +extension-name+ 1
 ((xclhb:window window) (xclhb:card32 driver-type))
 ((pad bytes 1) (xclhb:card32 driver-name-length)
  (xclhb:card32 device-name-length) (pad bytes 16)
  (list xclhb:char driver-name-length driver-name)
  (list xclhb:void
   (- (logand (+ driver-name-length 3) (lognot 3)) driver-name-length)
   alignment-pad)
  (list xclhb:char device-name-length device-name)))

(xclhb::define-extension-request authenticate +extension-name+ 2
 ((xclhb:window window) (xclhb:card32 magic))
 ((pad bytes 1) (xclhb:card32 authenticated)))

(xclhb::define-extension-request create-drawable +extension-name+ 3
 ((xclhb:drawable drawable)) ())

(xclhb::define-extension-request destroy-drawable +extension-name+ 4
 ((xclhb:drawable drawable)) ())

(xclhb::define-extension-request get-buffers +extension-name+ 5
 ((xclhb:drawable drawable) (xclhb:card32 count)
  (list xclhb:card32 (length attachments) attachments))
 ((pad bytes 1) (xclhb:card32 width) (xclhb:card32 height) (xclhb:card32 count)
  (pad bytes 12) (list dri2buffer count buffers)))

(xclhb::define-extension-request copy-region +extension-name+ 6
 ((xclhb:drawable drawable) (xclhb:card32 region) (xclhb:card32 dest)
  (xclhb:card32 src))
 ((pad bytes 1)))

(xclhb::define-extension-request get-buffers-with-format +extension-name+ 7
 ((xclhb:drawable drawable) (xclhb:card32 count)
  (list attach-format (length attachments) attachments))
 ((pad bytes 1) (xclhb:card32 width) (xclhb:card32 height) (xclhb:card32 count)
  (pad bytes 12) (list dri2buffer count buffers)))

(xclhb::define-extension-request swap-buffers +extension-name+ 8
 ((xclhb:drawable drawable) (xclhb:card32 target-msc-hi)
  (xclhb:card32 target-msc-lo) (xclhb:card32 divisor-hi)
  (xclhb:card32 divisor-lo) (xclhb:card32 remainder-hi)
  (xclhb:card32 remainder-lo))
 ((pad bytes 1) (xclhb:card32 swap-hi) (xclhb:card32 swap-lo)))

(xclhb::define-extension-request get-msc +extension-name+ 9
 ((xclhb:drawable drawable))
 ((pad bytes 1) (xclhb:card32 ust-hi) (xclhb:card32 ust-lo)
  (xclhb:card32 msc-hi) (xclhb:card32 msc-lo) (xclhb:card32 sbc-hi)
  (xclhb:card32 sbc-lo)))

(xclhb::define-extension-request wait-msc +extension-name+ 10
 ((xclhb:drawable drawable) (xclhb:card32 target-msc-hi)
  (xclhb:card32 target-msc-lo) (xclhb:card32 divisor-hi)
  (xclhb:card32 divisor-lo) (xclhb:card32 remainder-hi)
  (xclhb:card32 remainder-lo))
 ((pad bytes 1) (xclhb:card32 ust-hi) (xclhb:card32 ust-lo)
  (xclhb:card32 msc-hi) (xclhb:card32 msc-lo) (xclhb:card32 sbc-hi)
  (xclhb:card32 sbc-lo)))

(xclhb::define-extension-request wait-sbc +extension-name+ 11
 ((xclhb:drawable drawable) (xclhb:card32 target-sbc-hi)
  (xclhb:card32 target-sbc-lo))
 ((pad bytes 1) (xclhb:card32 ust-hi) (xclhb:card32 ust-lo)
  (xclhb:card32 msc-hi) (xclhb:card32 msc-lo) (xclhb:card32 sbc-hi)
  (xclhb:card32 sbc-lo)))

(xclhb::define-extension-request swap-interval +extension-name+ 12
 ((xclhb:drawable drawable) (xclhb:card32 interval)) ())

(xclhb::define-extension-request get-param +extension-name+ 13
 ((xclhb:drawable drawable) (xclhb:card32 param))
 ((xclhb:bool is-param-recognized) (xclhb:card32 value-hi)
  (xclhb:card32 value-lo)))

(xclhb::define-extension-event buffer-swap-complete +extension-name+ 0
 ((pad bytes 1) (xclhb:card16 event-type) (pad bytes 2)
  (xclhb:drawable drawable) (xclhb:card32 ust-hi) (xclhb:card32 ust-lo)
  (xclhb:card32 msc-hi) (xclhb:card32 msc-lo) (xclhb:card32 sbc)))

(xclhb::define-extension-event invalidate-buffers +extension-name+ 1
 ((pad bytes 1) (xclhb:drawable drawable)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+
  (list (list 1 #'read-invalidate-buffers-event)
   (list 0 #'read-buffer-swap-complete-event)))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 13 #'read-get-param-reply) (list 11 #'read-wait-sbc-reply)
   (list 10 #'read-wait-msc-reply) (list 9 #'read-get-msc-reply)
   (list 8 #'read-swap-buffers-reply)
   (list 7 #'read-get-buffers-with-format-reply)
   (list 6 #'read-copy-region-reply) (list 5 #'read-get-buffers-reply)
   (list 2 #'read-authenticate-reply) (list 1 #'read-connect-reply)
   (list 0 #'read-query-version-reply))))

