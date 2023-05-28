(uiop:define-package :xclhb-xinerama (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-xinerama)

(xclhb:defglobal +extension-name+ "XINERAMA")

(xclhb::define-struct screen-info
 ((xclhb:int16 x-org) (xclhb:int16 y-org) (xclhb:card16 width)
  (xclhb:card16 height)))

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card8 major) (xclhb:card8 minor))
 ((pad bytes 1) (xclhb:card16 major) (xclhb:card16 minor)))

(xclhb::define-extension-request get-state +extension-name+ 1
 ((xclhb:window window)) ((xclhb:byte state) (xclhb:window window)))

(xclhb::define-extension-request get-screen-count +extension-name+ 2
 ((xclhb:window window)) ((xclhb:byte screen-count) (xclhb:window window)))

(xclhb::define-extension-request get-screen-size +extension-name+ 3
 ((xclhb:window window) (xclhb:card32 screen))
 ((pad bytes 1) (xclhb:card32 width) (xclhb:card32 height)
  (xclhb:window window) (xclhb:card32 screen)))

(xclhb::define-extension-request is-active +extension-name+ 4 ()
 ((pad bytes 1) (xclhb:card32 state)))

(xclhb::define-extension-request query-screens +extension-name+ 5 ()
 ((pad bytes 1) (xclhb:card32 number) (pad bytes 20)
  (list screen-info number screen-info)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+ (list))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 5 #'read-query-screens-reply) (list 4 #'read-is-active-reply)
   (list 3 #'read-get-screen-size-reply) (list 2 #'read-get-screen-count-reply)
   (list 1 #'read-get-state-reply) (list 0 #'read-query-version-reply))))

