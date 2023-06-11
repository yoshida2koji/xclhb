;; (uiop:define-package :xclhb-res (:use :cl)
;;  (:import-from :xclhb :pad :bytes :align :bitcase))

(uiop:define-package :xclhb-res (:use :cl)
                     (:import-from :xclhb :pad :bytes :align :bitcase)
                     (:shadow :type))

(in-package :xclhb-res)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "X-Resource")

(xclhb::define-struct client
 ((xclhb:card32 resource-base) (xclhb:card32 resource-mask)))

(xclhb::define-struct type ((xclhb:atom resource-type) (xclhb:card32 count)))

(export '+client-id-mask--client-xid+)

(defconstant +client-id-mask--client-xid+ 0)

(export '+client-id-mask--local-client-pid+)

(defconstant +client-id-mask--local-client-pid+ 1)

(xclhb::define-struct client-id-spec
 ((xclhb:card32 client) (xclhb:card32 mask)))

(xclhb::define-struct client-id-value
 ((client-id-spec spec) (xclhb:card32 length)
  (list xclhb:card32 (/ length 4) value)))

(xclhb::define-struct resource-id-spec
 ((xclhb:card32 resource) (xclhb:card32 type)))

(xclhb::define-struct resource-size-spec
 ((resource-id-spec spec) (xclhb:card32 bytes) (xclhb:card32 ref-count)
  (xclhb:card32 use-count)))

(xclhb::define-struct resource-size-value
 ((resource-size-spec size) (xclhb:card32 num-cross-references)
  (list resource-size-spec num-cross-references cross-references)))

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card8 client-major) (xclhb:card8 client-minor))
 ((pad bytes 1) (xclhb:card16 server-major) (xclhb:card16 server-minor)))

(xclhb::define-extension-request query-clients +extension-name+ 1 ()
 ((pad bytes 1) (xclhb:card32 num-clients) (pad bytes 20)
  (list client num-clients clients)))

(xclhb::define-extension-request query-client-resources +extension-name+ 2
 ((xclhb:card32 xid))
 ((pad bytes 1) (xclhb:card32 num-types) (pad bytes 20)
  (list type num-types types)))

(xclhb::define-extension-request query-client-pixmap-bytes +extension-name+ 3
 ((xclhb:card32 xid))
 ((pad bytes 1) (xclhb:card32 bytes) (xclhb:card32 bytes-overflow)))

(xclhb::define-extension-request query-client-ids +extension-name+ 4
 ((xclhb:card32 num-specs) (list client-id-spec num-specs specs))
 ((pad bytes 1) (xclhb:card32 num-ids) (pad bytes 20)
  (list client-id-value num-ids ids)))

(xclhb::define-extension-request query-resource-bytes +extension-name+ 5
 ((xclhb:card32 client) (xclhb:card32 num-specs)
  (list resource-id-spec num-specs specs))
 ((pad bytes 1) (xclhb:card32 num-sizes) (pad bytes 20)
  (list resource-size-value num-sizes sizes)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 5 #'read-query-resource-bytes-reply)
   (list 4 #'read-query-client-ids-reply)
   (list 3 #'read-query-client-pixmap-bytes-reply)
   (list 2 #'read-query-client-resources-reply)
   (list 1 #'read-query-clients-reply) (list 0 #'read-query-version-reply))))

