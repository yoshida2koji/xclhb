(uiop:define-package :xclhb-dpms (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-dpms)

(xclhb:defglobal +extension-name+ "DPMS")

(xclhb::define-extension-request get-version +extension-name+ 0
 ((xclhb:card16 client-major-version) (xclhb:card16 client-minor-version))
 ((pad bytes 1) (xclhb:card16 server-major-version)
  (xclhb:card16 server-minor-version)))

(xclhb::define-extension-request capable +extension-name+ 1 ()
 ((pad bytes 1) (xclhb:bool capable) (pad bytes 23)))

(xclhb::define-extension-request get-timeouts +extension-name+ 2 ()
 ((pad bytes 1) (xclhb:card16 standby-timeout) (xclhb:card16 suspend-timeout)
  (xclhb:card16 off-timeout) (pad bytes 18)))

(xclhb::define-extension-request set-timeouts +extension-name+ 3
 ((xclhb:card16 standby-timeout) (xclhb:card16 suspend-timeout)
  (xclhb:card16 off-timeout))
 ())

(xclhb::define-extension-request enable +extension-name+ 4 () ())

(xclhb::define-extension-request disable +extension-name+ 5 () ())

(export '+dpmsmode--on+)

(defconstant +dpmsmode--on+ 0)

(export '+dpmsmode--standby+)

(defconstant +dpmsmode--standby+ 1)

(export '+dpmsmode--suspend+)

(defconstant +dpmsmode--suspend+ 2)

(export '+dpmsmode--off+)

(defconstant +dpmsmode--off+ 3)

(xclhb::define-extension-request force-level +extension-name+ 6
 ((xclhb:card16 power-level)) ())

(xclhb::define-extension-request info +extension-name+ 7 ()
 ((pad bytes 1) (xclhb:card16 power-level) (xclhb:bool state) (pad bytes 21)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 7 #'read-info-reply) (list 2 #'read-get-timeouts-reply)
   (list 1 #'read-capable-reply) (list 0 #'read-get-version-reply))))

