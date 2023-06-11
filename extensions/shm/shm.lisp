(uiop:define-package :xclhb-shm (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-shm)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "MIT-SHM")

(export 'seg)

(deftype seg () 'xclhb:xid)

(xclhb::define-extension-event completion +extension-name+ 0
 ((pad bytes 1) (xclhb:drawable drawable) (xclhb:card16 minor-event)
  (xclhb:byte major-event) (pad bytes 1) (seg shmseg) (xclhb:card32 offset)))

(xclhb::define-extension-error bad-seg +extension-name+ 0)

(xclhb::define-extension-request query-version +extension-name+ 0 ()
 ((xclhb:bool shared-pixmaps) (xclhb:card16 major-version)
  (xclhb:card16 minor-version) (xclhb:card16 uid) (xclhb:card16 gid)
  (xclhb:card8 pixmap-format) (pad bytes 15)))

(xclhb::define-extension-request attach +extension-name+ 1
 ((seg shmseg) (xclhb:card32 shmid) (xclhb:bool read-only) (pad bytes 3)) ())

(xclhb::define-extension-request detach +extension-name+ 2 ((seg shmseg)) ())

(xclhb::define-extension-request put-image +extension-name+ 3
 ((xclhb:drawable drawable) (xclhb:gcontext gc) (xclhb:card16 total-width)
  (xclhb:card16 total-height) (xclhb:card16 src-x) (xclhb:card16 src-y)
  (xclhb:card16 src-width) (xclhb:card16 src-height) (xclhb:int16 dst-x)
  (xclhb:int16 dst-y) (xclhb:card8 depth) (xclhb:card8 format)
  (xclhb:bool send-event) (pad bytes 1) (seg shmseg) (xclhb:card32 offset))
 ())

(xclhb::define-extension-request get-image +extension-name+ 4
 ((xclhb:drawable drawable) (xclhb:int16 x) (xclhb:int16 y)
  (xclhb:card16 width) (xclhb:card16 height) (xclhb:card32 plane-mask)
  (xclhb:card8 format) (pad bytes 3) (seg shmseg) (xclhb:card32 offset))
 ((xclhb:card8 depth) (xclhb:visualid visual) (xclhb:card32 size)))

(xclhb::define-extension-request create-pixmap +extension-name+ 5
 ((xclhb:pixmap pid) (xclhb:drawable drawable) (xclhb:card16 width)
  (xclhb:card16 height) (xclhb:card8 depth) (pad bytes 3) (seg shmseg)
  (xclhb:card32 offset))
 ())

(xclhb::define-extension-request attach-fd +extension-name+ 6
 ((seg shmseg) (xclhb:card32 shm-fd) (xclhb:bool read-only) (pad bytes 3)) ())

(xclhb::define-extension-request create-segment +extension-name+ 7
 ((seg shmseg) (xclhb:card32 size) (xclhb:bool read-only) (pad bytes 3))
 ((xclhb:card8 nfd) (xclhb:card32 shm-fd) (pad bytes 24)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+
  (list (list 0 #'read-completion-event)))
 (xclhb::set-extension-error-names client +extension-name+
  (list (list 0 "bad-seg")))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 7 #'read-create-segment-reply) (list 4 #'read-get-image-reply)
   (list 0 #'read-query-version-reply))))

