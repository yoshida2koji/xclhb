(uiop:define-package :xclhb-xprint (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-xprint)

(xclhb:defglobal +extension-name+ "XpExtension")

(export 'string8)

(deftype string8 () 'xclhb:char)

(xclhb::define-struct printer
 ((xclhb:card32 name-len) (list string8 name-len name) (pad align 4)
  (xclhb:card32 desc-len) (list string8 desc-len description) (pad align 4)))

(export 'pcontext)

(deftype pcontext () 'xclhb:xid)

(export '+get-doc--finished+)

(defconstant +get-doc--finished+ 0)

(export '+get-doc--second-consumer+)

(defconstant +get-doc--second-consumer+ 1)

(export '+ev-mask--no-event-mask+)

(defconstant +ev-mask--no-event-mask+ 0)

(export '+ev-mask--print-mask+)

(defconstant +ev-mask--print-mask+ 0)

(export '+ev-mask--attribute-mask+)

(defconstant +ev-mask--attribute-mask+ 1)

(export '+detail--start-job-notify+)

(defconstant +detail--start-job-notify+ 1)

(export '+detail--end-job-notify+)

(defconstant +detail--end-job-notify+ 2)

(export '+detail--start-doc-notify+)

(defconstant +detail--start-doc-notify+ 3)

(export '+detail--end-doc-notify+)

(defconstant +detail--end-doc-notify+ 4)

(export '+detail--start-page-notify+)

(defconstant +detail--start-page-notify+ 5)

(export '+detail--end-page-notify+)

(defconstant +detail--end-page-notify+ 6)

(export '+attr--job-attr+)

(defconstant +attr--job-attr+ 1)

(export '+attr--doc-attr+)

(defconstant +attr--doc-attr+ 2)

(export '+attr--page-attr+)

(defconstant +attr--page-attr+ 3)

(export '+attr--printer-attr+)

(defconstant +attr--printer-attr+ 4)

(export '+attr--server-attr+)

(defconstant +attr--server-attr+ 5)

(export '+attr--medium-attr+)

(defconstant +attr--medium-attr+ 6)

(export '+attr--spooler-attr+)

(defconstant +attr--spooler-attr+ 7)

(xclhb::define-extension-request print-query-version +extension-name+ 0 ()
 ((pad bytes 1) (xclhb:card16 major-version) (xclhb:card16 minor-version)))

(xclhb::define-extension-request print-get-printer-list +extension-name+ 1
 ((xclhb:card32 printer-name-len) (xclhb:card32 locale-len)
  (list string8 printer-name-len printer-name)
  (list string8 locale-len locale))
 ((pad bytes 1) (xclhb:card32 list-count) (pad bytes 20)
  (list printer list-count printers)))

(xclhb::define-extension-request print-rehash-printer-list +extension-name+ 20
 () ())

(xclhb::define-extension-request create-context +extension-name+ 2
 ((xclhb:card32 context-id) (xclhb:card32 printer-name-len)
  (xclhb:card32 locale-len) (list string8 printer-name-len printer-name)
  (list string8 locale-len locale))
 ())

(xclhb::define-extension-request print-set-context +extension-name+ 3
 ((xclhb:card32 context)) ())

(xclhb::define-extension-request print-get-context +extension-name+ 4 ()
 ((pad bytes 1) (xclhb:card32 context)))

(xclhb::define-extension-request print-destroy-context +extension-name+ 5
 ((xclhb:card32 context)) ())

(xclhb::define-extension-request print-get-screen-of-context +extension-name+ 6
 () ((pad bytes 1) (xclhb:window root)))

(xclhb::define-extension-request print-start-job +extension-name+ 7
 ((xclhb:card8 output-mode)) ())

(xclhb::define-extension-request print-end-job +extension-name+ 8
 ((xclhb:bool cancel)) ())

(xclhb::define-extension-request print-start-doc +extension-name+ 9
 ((xclhb:card8 driver-mode)) ())

(xclhb::define-extension-request print-end-doc +extension-name+ 10
 ((xclhb:bool cancel)) ())

(xclhb::define-extension-request print-put-document-data +extension-name+ 11
 ((xclhb:drawable drawable) (xclhb:card32 len-data) (xclhb:card16 len-fmt)
  (xclhb:card16 len-options) (list xclhb:byte len-data data)
  (list string8 len-fmt doc-format) (list string8 len-options options))
 ())

(xclhb::define-extension-request print-get-document-data +extension-name+ 12
 ((pcontext context) (xclhb:card32 max-bytes))
 ((pad bytes 1) (xclhb:card32 status-code) (xclhb:card32 finished-flag)
  (xclhb:card32 data-len) (pad bytes 12) (list xclhb:byte data-len data)))

(xclhb::define-extension-request print-start-page +extension-name+ 13
 ((xclhb:window window)) ())

(xclhb::define-extension-request print-end-page +extension-name+ 14
 ((xclhb:bool cancel) (pad bytes 3)) ())

(xclhb::define-extension-request print-select-input +extension-name+ 15
 ((pcontext context) (xclhb:card32 event-mask)) ())

(xclhb::define-extension-request print-input-selected +extension-name+ 16
 ((pcontext context))
 ((pad bytes 1) (xclhb:card32 event-mask) (xclhb:card32 all-events-mask)))

(xclhb::define-extension-request print-get-attributes +extension-name+ 17
 ((pcontext context) (xclhb:card8 pool) (pad bytes 3))
 ((pad bytes 1) (xclhb:card32 string-len) (pad bytes 20)
  (list string8 string-len attributes)))

(xclhb::define-extension-request print-get-one-attributes +extension-name+ 19
 ((pcontext context) (xclhb:card32 name-len) (xclhb:card8 pool) (pad bytes 3)
  (list string8 name-len name))
 ((pad bytes 1) (xclhb:card32 value-len) (pad bytes 20)
  (list string8 value-len value)))

(xclhb::define-extension-request print-set-attributes +extension-name+ 18
 ((pcontext context) (xclhb:card32 string-len) (xclhb:card8 pool)
  (xclhb:card8 rule) (pad bytes 2)
  (list string8 (length attributes) attributes))
 ())

(xclhb::define-extension-request print-get-page-dimensions +extension-name+ 21
 ((pcontext context))
 ((pad bytes 1) (xclhb:card16 width) (xclhb:card16 height)
  (xclhb:card16 offset-x) (xclhb:card16 offset-y)
  (xclhb:card16 reproducible-width) (xclhb:card16 reproducible-height)))

(xclhb::define-extension-request print-query-screens +extension-name+ 22 ()
 ((pad bytes 1) (xclhb:card32 list-count) (pad bytes 20)
  (list xclhb:window list-count roots)))

(xclhb::define-extension-request print-set-image-resolution +extension-name+ 23
 ((pcontext context) (xclhb:card16 image-resolution))
 ((xclhb:bool status) (xclhb:card16 previous-resolutions)))

(xclhb::define-extension-request print-get-image-resolution +extension-name+ 24
 ((pcontext context)) ((pad bytes 1) (xclhb:card16 image-resolution)))

(xclhb::define-extension-event notify +extension-name+ 0
 ((xclhb:card8 detail) (pcontext context) (xclhb:bool cancel)))

(xclhb::define-extension-event attribut-notify +extension-name+ 1
 ((xclhb:card8 detail) (pcontext context)))

(xclhb::define-extension-error bad-context +extension-name+ 0)

(xclhb::define-extension-error bad-sequence +extension-name+ 1)

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+
  (list (list 1 #'read-attribut-notify-event) (list 0 #'read-notify-event)))
 (xclhb::set-extension-error-names client +extension-name+
  (list (list 1 "bad-sequence") (list 0 "bad-context")))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 24 #'read-print-get-image-resolution-reply)
   (list 23 #'read-print-set-image-resolution-reply)
   (list 22 #'read-print-query-screens-reply)
   (list 21 #'read-print-get-page-dimensions-reply)
   (list 19 #'read-print-get-one-attributes-reply)
   (list 17 #'read-print-get-attributes-reply)
   (list 16 #'read-print-input-selected-reply)
   (list 12 #'read-print-get-document-data-reply)
   (list 6 #'read-print-get-screen-of-context-reply)
   (list 4 #'read-print-get-context-reply)
   (list 1 #'read-print-get-printer-list-reply)
   (list 0 #'read-print-query-version-reply))))

