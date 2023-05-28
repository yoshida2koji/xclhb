(uiop:define-package :xclhb-xvmc (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-xvmc)

(xclhb:defglobal +extension-name+ "XVideo-MotionCompensation")

(export 'context)

(deftype context () 'xclhb:xid)

(export 'surface)

(deftype surface () 'xclhb:xid)

(export 'subpicture)

(deftype subpicture () 'xclhb:xid)

(xclhb::define-struct surface-info
 ((surface id) (xclhb:card16 chroma-format) (xclhb:card16 pad0)
  (xclhb:card16 max-width) (xclhb:card16 max-height)
  (xclhb:card16 subpicture-max-width) (xclhb:card16 subpicture-max-height)
  (xclhb:card32 mc-type) (xclhb:card32 flags)))

(xclhb::define-extension-request query-version +extension-name+ 0 ()
 ((pad bytes 1) (xclhb:card32 major) (xclhb:card32 minor)))

(xclhb::define-extension-request list-surface-types +extension-name+ 1
 ((xclhb-xv:port port-id))
 ((pad bytes 1) (xclhb:card32 num) (pad bytes 20)
  (list surface-info num surfaces)))

(xclhb::define-extension-request create-context +extension-name+ 2
 ((context context-id) (xclhb-xv:port port-id) (surface surface-id)
  (xclhb:card16 width) (xclhb:card16 height) (xclhb:card32 flags))
 ((pad bytes 1) (xclhb:card16 width-actual) (xclhb:card16 height-actual)
  (xclhb:card32 flags-return) (pad bytes 20)
  (list xclhb:card32 length priv-data)))

(xclhb::define-extension-request destroy-context +extension-name+ 3
 ((context context-id)) ())

(xclhb::define-extension-request create-surface +extension-name+ 4
 ((surface surface-id) (context context-id))
 ((pad bytes 1) (pad bytes 24) (list xclhb:card32 length priv-data)))

(xclhb::define-extension-request destroy-surface +extension-name+ 5
 ((surface surface-id)) ())

(xclhb::define-extension-request create-subpicture +extension-name+ 6
 ((subpicture subpicture-id) (context context) (xclhb:card32 xvimage-id)
  (xclhb:card16 width) (xclhb:card16 height))
 ((pad bytes 1) (xclhb:card16 width-actual) (xclhb:card16 height-actual)
  (xclhb:card16 num-palette-entries) (xclhb:card16 entry-bytes)
  (list xclhb:card8 4 component-order) (pad bytes 12)
  (list xclhb:card32 length priv-data)))

(xclhb::define-extension-request destroy-subpicture +extension-name+ 7
 ((subpicture subpicture-id)) ())

(xclhb::define-extension-request list-subpicture-types +extension-name+ 8
 ((xclhb-xv:port port-id) (surface surface-id))
 ((pad bytes 1) (xclhb:card32 num) (pad bytes 20)
  (list xclhb-xv:image-format-info num types)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 8 #'read-list-subpicture-types-reply)
   (list 6 #'read-create-subpicture-reply) (list 4 #'read-create-surface-reply)
   (list 2 #'read-create-context-reply)
   (list 1 #'read-list-surface-types-reply)
   (list 0 #'read-query-version-reply))))

