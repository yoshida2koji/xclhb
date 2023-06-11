(uiop:define-package :xclhb-record (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-record)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "RECORD")

(export 'context)

(deftype context () 'xclhb:xid)

(xclhb::define-struct range8 ((xclhb:card8 first) (xclhb:card8 last)))

(xclhb::define-struct range16 ((xclhb:card16 first) (xclhb:card16 last)))

(xclhb::define-struct ext-range ((range8 major) (range16 minor)))

(xclhb::define-struct range
 ((range8 core-requests) (range8 core-replies) (ext-range ext-requests)
  (ext-range ext-replies) (range8 delivered-events) (range8 device-events)
  (range8 errors) (xclhb:bool client-started) (xclhb:bool client-died)))

(export 'element-header)

(deftype element-header () 'xclhb:card8)

(export '+htype--from-server-time+)

(defconstant +htype--from-server-time+ 0)

(export '+htype--from-client-time+)

(defconstant +htype--from-client-time+ 1)

(export '+htype--from-client-sequence+)

(defconstant +htype--from-client-sequence+ 2)

(export 'client-spec)

(deftype client-spec () 'xclhb:card32)

(export '+cs--current-clients+)

(defconstant +cs--current-clients+ 1)

(export '+cs--future-clients+)

(defconstant +cs--future-clients+ 2)

(export '+cs--all-clients+)

(defconstant +cs--all-clients+ 3)

(xclhb::define-struct client-info
 ((client-spec client-resource) (xclhb:card32 num-ranges)
  (list range num-ranges ranges)))

(xclhb::define-extension-error bad-context +extension-name+ 0)

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card16 major-version) (xclhb:card16 minor-version))
 ((pad bytes 1) (xclhb:card16 major-version) (xclhb:card16 minor-version)))

(xclhb::define-extension-request create-context +extension-name+ 1
 ((context context) (element-header element-header) (pad bytes 3)
  (xclhb:card32 num-client-specs) (xclhb:card32 num-ranges)
  (list client-spec num-client-specs client-specs)
  (list range num-ranges ranges))
 ())

(xclhb::define-extension-request register-clients +extension-name+ 2
 ((context context) (element-header element-header) (pad bytes 3)
  (xclhb:card32 num-client-specs) (xclhb:card32 num-ranges)
  (list client-spec num-client-specs client-specs)
  (list range num-ranges ranges))
 ())

(xclhb::define-extension-request unregister-clients +extension-name+ 3
 ((context context) (xclhb:card32 num-client-specs)
  (list client-spec num-client-specs client-specs))
 ())

(xclhb::define-extension-request get-context +extension-name+ 4
 ((context context))
 ((xclhb:bool enabled) (element-header element-header) (pad bytes 3)
  (xclhb:card32 num-intercepted-clients) (pad bytes 16)
  (list client-info num-intercepted-clients intercepted-clients)))

(xclhb::define-extension-request enable-context +extension-name+ 5
 ((context context))
 ((xclhb:card8 category) (element-header element-header)
  (xclhb:bool client-swapped) (pad bytes 2) (xclhb:card32 xid-base)
  (xclhb:card32 server-time) (xclhb:card32 rec-sequence-num) (pad bytes 8)
  (list xclhb:byte (* length 4) data)))

(xclhb::define-extension-request disable-context +extension-name+ 6
 ((context context)) ())

(xclhb::define-extension-request free-context +extension-name+ 7
 ((context context)) ())

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+
  (list (list 0 "bad-context")))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 5 #'read-enable-context-reply) (list 4 #'read-get-context-reply)
   (list 0 #'read-query-version-reply))))

