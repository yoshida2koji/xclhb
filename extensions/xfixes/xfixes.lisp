(uiop:define-package :xclhb-xfixes (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-xfixes)

(xclhb:defglobal +extension-name+ "XFIXES")

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card32 client-major-version) (xclhb:card32 client-minor-version))
 ((pad bytes 1) (xclhb:card32 major-version) (xclhb:card32 minor-version)
  (pad bytes 16)))

(export '+save-set-mode--insert+)

(defconstant +save-set-mode--insert+ 0)

(export '+save-set-mode--delete+)

(defconstant +save-set-mode--delete+ 1)

(export '+save-set-target--nearest+)

(defconstant +save-set-target--nearest+ 0)

(export '+save-set-target--root+)

(defconstant +save-set-target--root+ 1)

(export '+save-set-mapping--map+)

(defconstant +save-set-mapping--map+ 0)

(export '+save-set-mapping--unmap+)

(defconstant +save-set-mapping--unmap+ 1)

(xclhb::define-extension-request change-save-set +extension-name+ 1
 ((xclhb:byte mode) (xclhb:byte target) (xclhb:byte map) (pad bytes 1)
  (xclhb:window window))
 ())

(export '+selection-event--set-selection-owner+)

(defconstant +selection-event--set-selection-owner+ 0)

(export '+selection-event--selection-window-destroy+)

(defconstant +selection-event--selection-window-destroy+ 1)

(export '+selection-event--selection-client-close+)

(defconstant +selection-event--selection-client-close+ 2)

(export '+selection-event-mask--set-selection-owner+)

(defconstant +selection-event-mask--set-selection-owner+ 0)

(export '+selection-event-mask--selection-window-destroy+)

(defconstant +selection-event-mask--selection-window-destroy+ 1)

(export '+selection-event-mask--selection-client-close+)

(defconstant +selection-event-mask--selection-client-close+ 2)

(xclhb::define-extension-event selection-notify +extension-name+ 0
 ((xclhb:card8 subtype) (xclhb:window window) (xclhb:window owner)
  (xclhb:atom selection) (xclhb:timestamp timestamp)
  (xclhb:timestamp selection-timestamp) (pad bytes 8)))

(xclhb::define-extension-request select-selection-input +extension-name+ 2
 ((xclhb:window window) (xclhb:atom selection) (xclhb:card32 event-mask)) ())

(export '+cursor-notify--display-cursor+)

(defconstant +cursor-notify--display-cursor+ 0)

(export '+cursor-notify-mask--display-cursor+)

(defconstant +cursor-notify-mask--display-cursor+ 0)

(xclhb::define-extension-event cursor-notify +extension-name+ 1
 ((xclhb:card8 subtype) (xclhb:window window) (xclhb:card32 cursor-serial)
  (xclhb:timestamp timestamp) (xclhb:atom name) (pad bytes 12)))

(xclhb::define-extension-request select-cursor-input +extension-name+ 3
 ((xclhb:window window) (xclhb:card32 event-mask)) ())

(xclhb::define-extension-request get-cursor-image +extension-name+ 4 ()
 ((pad bytes 1) (xclhb:int16 x) (xclhb:int16 y) (xclhb:card16 width)
  (xclhb:card16 height) (xclhb:card16 xhot) (xclhb:card16 yhot)
  (xclhb:card32 cursor-serial) (pad bytes 8)
  (list xclhb:card32 (* width height) cursor-image)))

(export 'region)

(deftype region () 'xclhb:xid)

(xclhb::define-extension-error bad-region +extension-name+ 0)

(export '+region--none+)

(defconstant +region--none+ 0)

(xclhb::define-extension-request create-region +extension-name+ 5
 ((region region) (list xclhb:rectangle (length rectangles) rectangles)) ())

(xclhb::define-extension-request create-region-from-bitmap +extension-name+ 6
 ((region region) (xclhb:pixmap bitmap)) ())

(xclhb::define-extension-request create-region-from-window +extension-name+ 7
 ((region region) (xclhb:window window) (xclhb-shape:kind kind) (pad bytes 3))
 ())

(xclhb::define-extension-request create-region-from-gc +extension-name+ 8
 ((region region) (xclhb:gcontext gc)) ())

(xclhb::define-extension-request create-region-from-picture +extension-name+ 9
 ((region region) (xclhb-render:picture picture)) ())

(xclhb::define-extension-request destroy-region +extension-name+ 10
 ((region region)) ())

(xclhb::define-extension-request set-region +extension-name+ 11
 ((region region) (list xclhb:rectangle (length rectangles) rectangles)) ())

(xclhb::define-extension-request copy-region +extension-name+ 12
 ((region source) (region destination)) ())

(xclhb::define-extension-request union-region +extension-name+ 13
 ((region source1) (region source2) (region destination)) ())

(xclhb::define-extension-request intersect-region +extension-name+ 14
 ((region source1) (region source2) (region destination)) ())

(xclhb::define-extension-request subtract-region +extension-name+ 15
 ((region source1) (region source2) (region destination)) ())

(xclhb::define-extension-request invert-region +extension-name+ 16
 ((region source) (xclhb:rectangle bounds) (region destination)) ())

(xclhb::define-extension-request translate-region +extension-name+ 17
 ((region region) (xclhb:int16 dx) (xclhb:int16 dy)) ())

(xclhb::define-extension-request region-extents +extension-name+ 18
 ((region source) (region destination)) ())

(xclhb::define-extension-request fetch-region +extension-name+ 19
 ((region region))
 ((pad bytes 1) (xclhb:rectangle extents) (pad bytes 16)
  (list xclhb:rectangle (/ length 2) rectangles)))

(xclhb::define-extension-request set-gcclip-region +extension-name+ 20
 ((xclhb:gcontext gc) (region region) (xclhb:int16 x-origin)
  (xclhb:int16 y-origin))
 ())

(xclhb::define-extension-request set-window-shape-region +extension-name+ 21
 ((xclhb:window dest) (xclhb-shape:kind dest-kind) (pad bytes 3)
  (xclhb:int16 x-offset) (xclhb:int16 y-offset) (region region))
 ())

(xclhb::define-extension-request set-picture-clip-region +extension-name+ 22
 ((xclhb-render:picture picture) (region region) (xclhb:int16 x-origin)
  (xclhb:int16 y-origin))
 ())

(xclhb::define-extension-request set-cursor-name +extension-name+ 23
 ((xclhb:cursor cursor) (xclhb:card16 nbytes) (pad bytes 2)
  (list xclhb:char nbytes name))
 ())

(xclhb::define-extension-request get-cursor-name +extension-name+ 24
 ((xclhb:cursor cursor))
 ((pad bytes 1) (xclhb:atom atom) (xclhb:card16 nbytes) (pad bytes 18)
  (list xclhb:char nbytes name)))

(xclhb::define-extension-request get-cursor-image-and-name +extension-name+ 25
 ()
 ((pad bytes 1) (xclhb:int16 x) (xclhb:int16 y) (xclhb:card16 width)
  (xclhb:card16 height) (xclhb:card16 xhot) (xclhb:card16 yhot)
  (xclhb:card32 cursor-serial) (xclhb:atom cursor-atom) (xclhb:card16 nbytes)
  (pad bytes 2) (list xclhb:card32 (* width height) cursor-image)
  (list xclhb:char nbytes name)))

(xclhb::define-extension-request change-cursor +extension-name+ 26
 ((xclhb:cursor source) (xclhb:cursor destination)) ())

(xclhb::define-extension-request change-cursor-by-name +extension-name+ 27
 ((xclhb:cursor src) (xclhb:card16 nbytes) (pad bytes 2)
  (list xclhb:char nbytes name))
 ())

(xclhb::define-extension-request expand-region +extension-name+ 28
 ((region source) (region destination) (xclhb:card16 left) (xclhb:card16 right)
  (xclhb:card16 top) (xclhb:card16 bottom))
 ())

(xclhb::define-extension-request hide-cursor +extension-name+ 29
 ((xclhb:window window)) ())

(xclhb::define-extension-request show-cursor +extension-name+ 30
 ((xclhb:window window)) ())

(export 'barrier)

(deftype barrier () 'xclhb:xid)

(export '+barrier-directions--positive-x+)

(defconstant +barrier-directions--positive-x+ 0)

(export '+barrier-directions--positive-y+)

(defconstant +barrier-directions--positive-y+ 1)

(export '+barrier-directions--negative-x+)

(defconstant +barrier-directions--negative-x+ 2)

(export '+barrier-directions--negative-y+)

(defconstant +barrier-directions--negative-y+ 3)

(xclhb::define-extension-request create-pointer-barrier +extension-name+ 31
 ((barrier barrier) (xclhb:window window) (xclhb:card16 x1) (xclhb:card16 y1)
  (xclhb:card16 x2) (xclhb:card16 y2) (xclhb:card32 directions) (pad bytes 2)
  (xclhb:card16 num-devices) (list xclhb:card16 num-devices devices))
 ())

(xclhb::define-extension-request delete-pointer-barrier +extension-name+ 32
 ((barrier barrier)) ())

(export '+client-disconnect-flags--default+)

(defconstant +client-disconnect-flags--default+ 0)

(export '+client-disconnect-flags--terminate+)

(defconstant +client-disconnect-flags--terminate+ 0)

(xclhb::define-extension-request set-client-disconnect-mode +extension-name+ 33
 ((xclhb:card32 disconnect-mode)) ())

(xclhb::define-extension-request get-client-disconnect-mode +extension-name+ 34
 () ((pad bytes 1) (xclhb:card32 disconnect-mode) (pad bytes 20)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+
  (list (list 1 #'read-cursor-notify-event)
   (list 0 #'read-selection-notify-event)))
 (xclhb::set-extension-error-names client +extension-name+
  (list (list 0 "bad-region")))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 34 #'read-get-client-disconnect-mode-reply)
   (list 25 #'read-get-cursor-image-and-name-reply)
   (list 24 #'read-get-cursor-name-reply) (list 19 #'read-fetch-region-reply)
   (list 4 #'read-get-cursor-image-reply) (list 0 #'read-query-version-reply))))

