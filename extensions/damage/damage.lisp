(uiop:define-package :xclhb-damage (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-damage)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "DAMAGE")

(export 'damage)

(deftype damage () 'xclhb:xid)

(export '+report-level--raw-rectangles+)

(defconstant +report-level--raw-rectangles+ 0)

(export '+report-level--delta-rectangles+)

(defconstant +report-level--delta-rectangles+ 1)

(export '+report-level--bounding-box+)

(defconstant +report-level--bounding-box+ 2)

(export '+report-level--non-empty+)

(defconstant +report-level--non-empty+ 3)

(xclhb::define-extension-error bad-damage +extension-name+ 0)

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card32 client-major-version) (xclhb:card32 client-minor-version))
 ((pad bytes 1) (xclhb:card32 major-version) (xclhb:card32 minor-version)
  (pad bytes 16)))

(xclhb::define-extension-request create +extension-name+ 1
 ((damage damage) (xclhb:drawable drawable) (xclhb:card8 level) (pad bytes 3))
 ())

(xclhb::define-extension-request destroy +extension-name+ 2 ((damage damage))
 ())

(xclhb::define-extension-request subtract +extension-name+ 3
 ((damage damage) (xclhb-xfixes:region repair) (xclhb-xfixes:region parts)) ())

(xclhb::define-extension-request add +extension-name+ 4
 ((xclhb:drawable drawable) (xclhb-xfixes:region region)) ())

(xclhb::define-extension-event notify +extension-name+ 0
 ((xclhb:card8 level) (xclhb:drawable drawable) (damage damage)
  (xclhb:timestamp timestamp) (xclhb:rectangle area)
  (xclhb:rectangle geometry)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+
  (list (list 0 #'read-notify-event)))
 (xclhb::set-extension-error-names client +extension-name+
  (list (list 0 "bad-damage")))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 0 #'read-query-version-reply))))

