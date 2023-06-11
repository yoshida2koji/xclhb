(uiop:define-package :xclhb-xf86vidmode (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-xf86vidmode)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "XFree86-VidModeExtension")

(export 'syncrange)

(deftype syncrange () 'xclhb:card32)

(export 'dotclock)

(deftype dotclock () 'xclhb:card32)

(export '+mode-flag--positive-hsync+)

(defconstant +mode-flag--positive-hsync+ 0)

(export '+mode-flag--negative-hsync+)

(defconstant +mode-flag--negative-hsync+ 1)

(export '+mode-flag--positive-vsync+)

(defconstant +mode-flag--positive-vsync+ 2)

(export '+mode-flag--negative-vsync+)

(defconstant +mode-flag--negative-vsync+ 3)

(export '+mode-flag--interlace+)

(defconstant +mode-flag--interlace+ 4)

(export '+mode-flag--composite-sync+)

(defconstant +mode-flag--composite-sync+ 5)

(export '+mode-flag--positive-csync+)

(defconstant +mode-flag--positive-csync+ 6)

(export '+mode-flag--negative-csync+)

(defconstant +mode-flag--negative-csync+ 7)

(export '+mode-flag--hskew+)

(defconstant +mode-flag--hskew+ 8)

(export '+mode-flag--broadcast+)

(defconstant +mode-flag--broadcast+ 9)

(export '+mode-flag--pixmux+)

(defconstant +mode-flag--pixmux+ 10)

(export '+mode-flag--double-clock+)

(defconstant +mode-flag--double-clock+ 11)

(export '+mode-flag--half-clock+)

(defconstant +mode-flag--half-clock+ 12)

(export '+clock-flag--programable+)

(defconstant +clock-flag--programable+ 0)

(export '+permission--read+)

(defconstant +permission--read+ 0)

(export '+permission--write+)

(defconstant +permission--write+ 1)

(xclhb::define-struct mode-info
 ((dotclock dotclock) (xclhb:card16 hdisplay) (xclhb:card16 hsyncstart)
  (xclhb:card16 hsyncend) (xclhb:card16 htotal) (xclhb:card32 hskew)
  (xclhb:card16 vdisplay) (xclhb:card16 vsyncstart) (xclhb:card16 vsyncend)
  (xclhb:card16 vtotal) (pad bytes 4) (xclhb:card32 flags) (pad bytes 12)
  (xclhb:card32 privsize)))

(xclhb::define-extension-request query-version +extension-name+ 0 ()
 ((pad bytes 1) (xclhb:card16 major-version) (xclhb:card16 minor-version)))

(xclhb::define-extension-request get-mode-line +extension-name+ 1
 ((xclhb:card16 screen) (pad bytes 2))
 ((pad bytes 1) (dotclock dotclock) (xclhb:card16 hdisplay)
  (xclhb:card16 hsyncstart) (xclhb:card16 hsyncend) (xclhb:card16 htotal)
  (xclhb:card16 hskew) (xclhb:card16 vdisplay) (xclhb:card16 vsyncstart)
  (xclhb:card16 vsyncend) (xclhb:card16 vtotal) (pad bytes 2)
  (xclhb:card32 flags) (pad bytes 12) (xclhb:card32 privsize)
  (list xclhb:card8 privsize private)))

(xclhb::define-extension-request mod-mode-line +extension-name+ 2
 ((xclhb:card32 screen) (xclhb:card16 hdisplay) (xclhb:card16 hsyncstart)
  (xclhb:card16 hsyncend) (xclhb:card16 htotal) (xclhb:card16 hskew)
  (xclhb:card16 vdisplay) (xclhb:card16 vsyncstart) (xclhb:card16 vsyncend)
  (xclhb:card16 vtotal) (pad bytes 2) (xclhb:card32 flags) (pad bytes 12)
  (xclhb:card32 privsize) (list xclhb:card8 privsize private))
 ())

(xclhb::define-extension-request switch-mode +extension-name+ 3
 ((xclhb:card16 screen) (xclhb:card16 zoom)) ())

(xclhb::define-extension-request get-monitor +extension-name+ 4
 ((xclhb:card16 screen) (pad bytes 2))
 ((pad bytes 1) (xclhb:card8 vendor-length) (xclhb:card8 model-length)
  (xclhb:card8 num-hsync) (xclhb:card8 num-vsync) (pad bytes 20)
  (list syncrange num-hsync hsync) (list syncrange num-vsync vsync)
  (list xclhb:char vendor-length vendor)
  (list xclhb:void (- (logand (+ vendor-length 3) (lognot 3)) vendor-length)
   alignment-pad)
  (list xclhb:char model-length model)))

(xclhb::define-extension-request lock-mode-switch +extension-name+ 5
 ((xclhb:card16 screen) (xclhb:card16 lock)) ())

(xclhb::define-extension-request get-all-mode-lines +extension-name+ 6
 ((xclhb:card16 screen) (pad bytes 2))
 ((pad bytes 1) (xclhb:card32 modecount) (pad bytes 20)
  (list mode-info modecount modeinfo)))

(xclhb::define-extension-request add-mode-line +extension-name+ 7
 ((xclhb:card32 screen) (dotclock dotclock) (xclhb:card16 hdisplay)
  (xclhb:card16 hsyncstart) (xclhb:card16 hsyncend) (xclhb:card16 htotal)
  (xclhb:card16 hskew) (xclhb:card16 vdisplay) (xclhb:card16 vsyncstart)
  (xclhb:card16 vsyncend) (xclhb:card16 vtotal) (pad bytes 2)
  (xclhb:card32 flags) (pad bytes 12) (xclhb:card32 privsize)
  (dotclock after-dotclock) (xclhb:card16 after-hdisplay)
  (xclhb:card16 after-hsyncstart) (xclhb:card16 after-hsyncend)
  (xclhb:card16 after-htotal) (xclhb:card16 after-hskew)
  (xclhb:card16 after-vdisplay) (xclhb:card16 after-vsyncstart)
  (xclhb:card16 after-vsyncend) (xclhb:card16 after-vtotal) (pad bytes 2)
  (xclhb:card32 after-flags) (pad bytes 12)
  (list xclhb:card8 privsize private))
 ())

(xclhb::define-extension-request delete-mode-line +extension-name+ 8
 ((xclhb:card32 screen) (dotclock dotclock) (xclhb:card16 hdisplay)
  (xclhb:card16 hsyncstart) (xclhb:card16 hsyncend) (xclhb:card16 htotal)
  (xclhb:card16 hskew) (xclhb:card16 vdisplay) (xclhb:card16 vsyncstart)
  (xclhb:card16 vsyncend) (xclhb:card16 vtotal) (pad bytes 2)
  (xclhb:card32 flags) (pad bytes 12) (xclhb:card32 privsize)
  (list xclhb:card8 privsize private))
 ())

(xclhb::define-extension-request validate-mode-line +extension-name+ 9
 ((xclhb:card32 screen) (dotclock dotclock) (xclhb:card16 hdisplay)
  (xclhb:card16 hsyncstart) (xclhb:card16 hsyncend) (xclhb:card16 htotal)
  (xclhb:card16 hskew) (xclhb:card16 vdisplay) (xclhb:card16 vsyncstart)
  (xclhb:card16 vsyncend) (xclhb:card16 vtotal) (pad bytes 2)
  (xclhb:card32 flags) (pad bytes 12) (xclhb:card32 privsize)
  (list xclhb:card8 privsize private))
 ((pad bytes 1) (xclhb:card32 status) (pad bytes 20)))

(xclhb::define-extension-request switch-to-mode +extension-name+ 10
 ((xclhb:card32 screen) (dotclock dotclock) (xclhb:card16 hdisplay)
  (xclhb:card16 hsyncstart) (xclhb:card16 hsyncend) (xclhb:card16 htotal)
  (xclhb:card16 hskew) (xclhb:card16 vdisplay) (xclhb:card16 vsyncstart)
  (xclhb:card16 vsyncend) (xclhb:card16 vtotal) (pad bytes 2)
  (xclhb:card32 flags) (pad bytes 12) (xclhb:card32 privsize)
  (list xclhb:card8 privsize private))
 ())

(xclhb::define-extension-request get-view-port +extension-name+ 11
 ((xclhb:card16 screen) (pad bytes 2))
 ((pad bytes 1) (xclhb:card32 x) (xclhb:card32 y) (pad bytes 16)))

(xclhb::define-extension-request set-view-port +extension-name+ 12
 ((xclhb:card16 screen) (pad bytes 2) (xclhb:card32 x) (xclhb:card32 y)) ())

(xclhb::define-extension-request get-dot-clocks +extension-name+ 13
 ((xclhb:card16 screen) (pad bytes 2))
 ((pad bytes 1) (xclhb:card32 flags) (xclhb:card32 clocks)
  (xclhb:card32 maxclocks) (pad bytes 12)
  (list xclhb:card32 (* (- 1 (logand flags 1)) clocks) clock)))

(xclhb::define-extension-request set-client-version +extension-name+ 14
 ((xclhb:card16 major) (xclhb:card16 minor)) ())

(xclhb::define-extension-request set-gamma +extension-name+ 15
 ((xclhb:card16 screen) (pad bytes 2) (xclhb:card32 red) (xclhb:card32 green)
  (xclhb:card32 blue) (pad bytes 12))
 ())

(xclhb::define-extension-request get-gamma +extension-name+ 16
 ((xclhb:card16 screen) (pad bytes 26))
 ((pad bytes 1) (xclhb:card32 red) (xclhb:card32 green) (xclhb:card32 blue)
  (pad bytes 12)))

(xclhb::define-extension-request get-gamma-ramp +extension-name+ 17
 ((xclhb:card16 screen) (xclhb:card16 size))
 ((pad bytes 1) (xclhb:card16 size) (pad bytes 22)
  (list xclhb:card16 (logand (+ size 1) (lognot 1)) red)
  (list xclhb:card16 (logand (+ size 1) (lognot 1)) green)
  (list xclhb:card16 (logand (+ size 1) (lognot 1)) blue)))

(xclhb::define-extension-request set-gamma-ramp +extension-name+ 18
 ((xclhb:card16 screen) (xclhb:card16 size)
  (list xclhb:card16 (logand (+ size 1) (lognot 1)) red)
  (list xclhb:card16 (logand (+ size 1) (lognot 1)) green)
  (list xclhb:card16 (logand (+ size 1) (lognot 1)) blue))
 ())

(xclhb::define-extension-request get-gamma-ramp-size +extension-name+ 19
 ((xclhb:card16 screen) (pad bytes 2))
 ((pad bytes 1) (xclhb:card16 size) (pad bytes 22)))

(xclhb::define-extension-request get-permissions +extension-name+ 20
 ((xclhb:card16 screen) (pad bytes 2))
 ((pad bytes 1) (xclhb:card32 permissions) (pad bytes 20)))

(xclhb::define-extension-error bad-clock +extension-name+ 0)

(xclhb::define-extension-error bad-htimings +extension-name+ 1)

(xclhb::define-extension-error bad-vtimings +extension-name+ 2)

(xclhb::define-extension-error mode-unsuitable +extension-name+ 3)

(xclhb::define-extension-error extension-disabled +extension-name+ 4)

(xclhb::define-extension-error client-not-local +extension-name+ 5)

(xclhb::define-extension-error zoom-locked +extension-name+ 6)

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+
  (list (list 6 "zoom-locked") (list 5 "client-not-local")
   (list 4 "extension-disabled") (list 3 "mode-unsuitable")
   (list 2 "bad-vtimings") (list 1 "bad-htimings") (list 0 "bad-clock")))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 20 #'read-get-permissions-reply)
   (list 19 #'read-get-gamma-ramp-size-reply)
   (list 17 #'read-get-gamma-ramp-reply) (list 16 #'read-get-gamma-reply)
   (list 13 #'read-get-dot-clocks-reply) (list 11 #'read-get-view-port-reply)
   (list 9 #'read-validate-mode-line-reply)
   (list 6 #'read-get-all-mode-lines-reply) (list 4 #'read-get-monitor-reply)
   (list 1 #'read-get-mode-line-reply) (list 0 #'read-query-version-reply))))

