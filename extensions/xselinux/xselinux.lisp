(uiop:define-package :xclhb-xselinux (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-xselinux)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "SELinux")

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card8 client-major) (xclhb:card8 client-minor))
 ((pad bytes 1) (xclhb:card16 server-major) (xclhb:card16 server-minor)))

(xclhb::define-extension-request set-device-create-context +extension-name+ 1
 ((xclhb:card32 context-len) (list xclhb:char context-len context)) ())

(xclhb::define-extension-request get-device-create-context +extension-name+ 2
 ()
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-extension-request set-device-context +extension-name+ 3
 ((xclhb:card32 device) (xclhb:card32 context-len)
  (list xclhb:char context-len context))
 ())

(xclhb::define-extension-request get-device-context +extension-name+ 4
 ((xclhb:card32 device))
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-extension-request set-window-create-context +extension-name+ 5
 ((xclhb:card32 context-len) (list xclhb:char context-len context)) ())

(xclhb::define-extension-request get-window-create-context +extension-name+ 6
 ()
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-extension-request get-window-context +extension-name+ 7
 ((xclhb:window window))
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-struct list-item
 ((xclhb:atom name) (xclhb:card32 object-context-len)
  (xclhb:card32 data-context-len)
  (list xclhb:char object-context-len object-context) (pad align 4)
  (list xclhb:char data-context-len data-context) (pad align 4)))

(xclhb::define-extension-request set-property-create-context +extension-name+ 8
 ((xclhb:card32 context-len) (list xclhb:char context-len context)) ())

(xclhb::define-extension-request get-property-create-context +extension-name+ 9
 ()
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-extension-request set-property-use-context +extension-name+ 10
 ((xclhb:card32 context-len) (list xclhb:char context-len context)) ())

(xclhb::define-extension-request get-property-use-context +extension-name+ 11
 ()
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-extension-request get-property-context +extension-name+ 12
 ((xclhb:window window) (xclhb:atom property))
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-extension-request get-property-data-context +extension-name+ 13
 ((xclhb:window window) (xclhb:atom property))
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-extension-request list-properties +extension-name+ 14
 ((xclhb:window window))
 ((pad bytes 1) (xclhb:card32 properties-len) (pad bytes 20)
  (list list-item properties-len properties)))

(xclhb::define-extension-request set-selection-create-context +extension-name+
 15 ((xclhb:card32 context-len) (list xclhb:char context-len context)) ())

(xclhb::define-extension-request get-selection-create-context +extension-name+
 16 ()
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-extension-request set-selection-use-context +extension-name+ 17
 ((xclhb:card32 context-len) (list xclhb:char context-len context)) ())

(xclhb::define-extension-request get-selection-use-context +extension-name+ 18
 ()
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-extension-request get-selection-context +extension-name+ 19
 ((xclhb:atom selection))
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-extension-request get-selection-data-context +extension-name+ 20
 ((xclhb:atom selection))
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(xclhb::define-extension-request list-selections +extension-name+ 21 ()
 ((pad bytes 1) (xclhb:card32 selections-len) (pad bytes 20)
  (list list-item selections-len selections)))

(xclhb::define-extension-request get-client-context +extension-name+ 22
 ((xclhb:card32 resource))
 ((pad bytes 1) (xclhb:card32 context-len) (pad bytes 20)
  (list xclhb:char context-len context)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 22 #'read-get-client-context-reply)
   (list 21 #'read-list-selections-reply)
   (list 20 #'read-get-selection-data-context-reply)
   (list 19 #'read-get-selection-context-reply)
   (list 18 #'read-get-selection-use-context-reply)
   (list 16 #'read-get-selection-create-context-reply)
   (list 14 #'read-list-properties-reply)
   (list 13 #'read-get-property-data-context-reply)
   (list 12 #'read-get-property-context-reply)
   (list 11 #'read-get-property-use-context-reply)
   (list 9 #'read-get-property-create-context-reply)
   (list 7 #'read-get-window-context-reply)
   (list 6 #'read-get-window-create-context-reply)
   (list 4 #'read-get-device-context-reply)
   (list 2 #'read-get-device-create-context-reply)
   (list 0 #'read-query-version-reply))))

