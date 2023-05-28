(uiop:define-package :xclhb-present (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-present)

(xclhb:defglobal +extension-name+ "Present")

(export '+event--configure-notify+)

(defconstant +event--configure-notify+ 0)

(export '+event--complete-notify+)

(defconstant +event--complete-notify+ 1)

(export '+event--idle-notify+)

(defconstant +event--idle-notify+ 2)

(export '+event--redirect-notify+)

(defconstant +event--redirect-notify+ 3)

(export '+event-mask--no-event+)

(defconstant +event-mask--no-event+ 0)

(export '+event-mask--configure-notify+)

(defconstant +event-mask--configure-notify+ 0)

(export '+event-mask--complete-notify+)

(defconstant +event-mask--complete-notify+ 1)

(export '+event-mask--idle-notify+)

(defconstant +event-mask--idle-notify+ 2)

(export '+event-mask--redirect-notify+)

(defconstant +event-mask--redirect-notify+ 3)

(export '+option--none+)

(defconstant +option--none+ 0)

(export '+option--async+)

(defconstant +option--async+ 0)

(export '+option--copy+)

(defconstant +option--copy+ 1)

(export '+option--ust+)

(defconstant +option--ust+ 2)

(export '+option--suboptimal+)

(defconstant +option--suboptimal+ 3)

(export '+capability--none+)

(defconstant +capability--none+ 0)

(export '+capability--async+)

(defconstant +capability--async+ 0)

(export '+capability--fence+)

(defconstant +capability--fence+ 1)

(export '+capability--ust+)

(defconstant +capability--ust+ 2)

(export '+complete-kind--pixmap+)

(defconstant +complete-kind--pixmap+ 0)

(export '+complete-kind--notify-msc+)

(defconstant +complete-kind--notify-msc+ 1)

(export '+complete-mode--copy+)

(defconstant +complete-mode--copy+ 0)

(export '+complete-mode--flip+)

(defconstant +complete-mode--flip+ 1)

(export '+complete-mode--skip+)

(defconstant +complete-mode--skip+ 2)

(export '+complete-mode--suboptimal-copy+)

(defconstant +complete-mode--suboptimal-copy+ 3)

(xclhb::define-struct notify ((xclhb:window window) (xclhb:card32 serial)))

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card32 major-version) (xclhb:card32 minor-version))
 ((pad bytes 1) (xclhb:card32 major-version) (xclhb:card32 minor-version)))

(xclhb::define-extension-request pixmap +extension-name+ 1
 ((xclhb:window window) (xclhb:pixmap pixmap) (xclhb:card32 serial)
  (xclhb-xfixes:region valid) (xclhb-xfixes:region update) (xclhb:int16 x-off)
  (xclhb:int16 y-off) (xclhb-randr:crtc target-crtc)
  (xclhb-sync:fence wait-fence) (xclhb-sync:fence idle-fence)
  (xclhb:card32 options) (pad bytes 4) (xclhb:card64 target-msc)
  (xclhb:card64 divisor) (xclhb:card64 remainder)
  (list notify (length notifies) notifies))
 ())

(xclhb::define-extension-request notify-msc +extension-name+ 2
 ((xclhb:window window) (xclhb:card32 serial) (pad bytes 4)
  (xclhb:card64 target-msc) (xclhb:card64 divisor) (xclhb:card64 remainder))
 ())

(export 'event)

(deftype event () 'xclhb:xid)

(xclhb::define-extension-request select-input +extension-name+ 3
 ((event eid) (xclhb:window window) (xclhb:card32 event-mask)) ())

(xclhb::define-extension-request query-capabilities +extension-name+ 4
 ((xclhb:card32 target)) ((pad bytes 1) (xclhb:card32 capabilities)))

(xclhb::define-extension-event generic +extension-name+ 0
 ((xclhb:card8 extension) (xclhb:card32 length) (xclhb:card16 evtype)
  (pad bytes 2) (event event)))

(xclhb::define-extension-event configure-notify +extension-name+ 0
 ((pad bytes 2) (event event) (xclhb:window window) (xclhb:int16 x)
  (xclhb:int16 y) (xclhb:card16 width) (xclhb:card16 height)
  (xclhb:int16 off-x) (xclhb:int16 off-y) (xclhb:card16 pixmap-width)
  (xclhb:card16 pixmap-height) (xclhb:card32 pixmap-flags)))

(xclhb::define-extension-event complete-notify +extension-name+ 1
 ((xclhb:card8 kind) (xclhb:card8 mode) (event event) (xclhb:window window)
  (xclhb:card32 serial) (xclhb:card64 ust) (xclhb:card64 msc)))

(xclhb::define-extension-event idle-notify +extension-name+ 2
 ((pad bytes 2) (event event) (xclhb:window window) (xclhb:card32 serial)
  (xclhb:pixmap pixmap) (xclhb-sync:fence idle-fence)))

(xclhb::define-extension-event redirect-notify +extension-name+ 3
 ((xclhb:bool update-window) (pad bytes 1) (event event)
  (xclhb:window event-window) (xclhb:window window) (xclhb:pixmap pixmap)
  (xclhb:card32 serial) (xclhb-xfixes:region valid-region)
  (xclhb-xfixes:region update-region) (xclhb:rectangle valid-rect)
  (xclhb:rectangle update-rect) (xclhb:int16 x-off) (xclhb:int16 y-off)
  (xclhb-randr:crtc target-crtc) (xclhb-sync:fence wait-fence)
  (xclhb-sync:fence idle-fence) (xclhb:card32 options) (pad bytes 4)
  (xclhb:card64 target-msc) (xclhb:card64 divisor) (xclhb:card64 remainder)
  (list notify (length notifies) notifies)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+
  (list (list 3 #'read-redirect-notify-event) (list 2 #'read-idle-notify-event)
   (list 1 #'read-complete-notify-event) (list 0 #'read-configure-notify-event)
   (list 0 #'read-generic-event)))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 4 #'read-query-capabilities-reply)
   (list 0 #'read-query-version-reply))))

