(in-package :xclhb)

(define-struct char2b ((card8 byte1) (card8 byte2)))

(export 'window)

(deftype window () 'xid)

(export 'pixmap)

(deftype pixmap () 'xid)

(export 'cursor)

(deftype cursor () 'xid)

(export 'font)

(deftype font () 'xid)

(export 'gcontext)

(deftype gcontext () 'xid)

(export 'colormap)

(deftype colormap () 'xid)

(export 'atom)

(deftype atom () 'xid)

(export 'drawable)

(deftype drawable () '(or window pixmap))

(export 'fontable)

(deftype fontable () '(or font gcontext))

(export 'bool32)

(deftype bool32 () 'card32)

(export 'visualid)

(deftype visualid () 'card32)

(export 'timestamp)

(deftype timestamp () 'card32)

(export 'keysym)

(deftype keysym () 'card32)

(export 'keycode)

(deftype keycode () 'card8)

(export 'keycode32)

(deftype keycode32 () 'card32)

(export 'button)

(deftype button () 'card8)

(define-struct point ((int16 x) (int16 y)))

(define-struct rectangle ((int16 x) (int16 y) (card16 width) (card16 height)))

(define-struct arc
 ((int16 x) (int16 y) (card16 width) (card16 height) (int16 angle1)
  (int16 angle2)))

(define-struct format
 ((card8 depth) (card8 bits-per-pixel) (card8 scanline-pad) (pad bytes 5)))

(export '+visual-class--static-gray+)

(defconstant +visual-class--static-gray+ 0)

(export '+visual-class--gray-scale+)

(defconstant +visual-class--gray-scale+ 1)

(export '+visual-class--static-color+)

(defconstant +visual-class--static-color+ 2)

(export '+visual-class--pseudo-color+)

(defconstant +visual-class--pseudo-color+ 3)

(export '+visual-class--true-color+)

(defconstant +visual-class--true-color+ 4)

(export '+visual-class--direct-color+)

(defconstant +visual-class--direct-color+ 5)

(define-struct visualtype
 ((visualid visual-id) (card8 class) (card8 bits-per-rgb-value)
  (card16 colormap-entries) (card32 red-mask) (card32 green-mask)
  (card32 blue-mask) (pad bytes 4)))

(define-struct depth
 ((card8 depth) (pad bytes 1) (card16 visuals-len) (pad bytes 4)
  (list visualtype visuals-len visuals)))

(export '+event-mask--no-event+)

(defconstant +event-mask--no-event+ 0)

(export '+event-mask--key-press+)

(defconstant +event-mask--key-press+ 0)

(export '+event-mask--key-release+)

(defconstant +event-mask--key-release+ 1)

(export '+event-mask--button-press+)

(defconstant +event-mask--button-press+ 2)

(export '+event-mask--button-release+)

(defconstant +event-mask--button-release+ 3)

(export '+event-mask--enter-window+)

(defconstant +event-mask--enter-window+ 4)

(export '+event-mask--leave-window+)

(defconstant +event-mask--leave-window+ 5)

(export '+event-mask--pointer-motion+)

(defconstant +event-mask--pointer-motion+ 6)

(export '+event-mask--pointer-motion-hint+)

(defconstant +event-mask--pointer-motion-hint+ 7)

(export '+event-mask--button1motion+)

(defconstant +event-mask--button1motion+ 8)

(export '+event-mask--button2motion+)

(defconstant +event-mask--button2motion+ 9)

(export '+event-mask--button3motion+)

(defconstant +event-mask--button3motion+ 10)

(export '+event-mask--button4motion+)

(defconstant +event-mask--button4motion+ 11)

(export '+event-mask--button5motion+)

(defconstant +event-mask--button5motion+ 12)

(export '+event-mask--button-motion+)

(defconstant +event-mask--button-motion+ 13)

(export '+event-mask--keymap-state+)

(defconstant +event-mask--keymap-state+ 14)

(export '+event-mask--exposure+)

(defconstant +event-mask--exposure+ 15)

(export '+event-mask--visibility-change+)

(defconstant +event-mask--visibility-change+ 16)

(export '+event-mask--structure-notify+)

(defconstant +event-mask--structure-notify+ 17)

(export '+event-mask--resize-redirect+)

(defconstant +event-mask--resize-redirect+ 18)

(export '+event-mask--substructure-notify+)

(defconstant +event-mask--substructure-notify+ 19)

(export '+event-mask--substructure-redirect+)

(defconstant +event-mask--substructure-redirect+ 20)

(export '+event-mask--focus-change+)

(defconstant +event-mask--focus-change+ 21)

(export '+event-mask--property-change+)

(defconstant +event-mask--property-change+ 22)

(export '+event-mask--color-map-change+)

(defconstant +event-mask--color-map-change+ 23)

(export '+event-mask--owner-grab-button+)

(defconstant +event-mask--owner-grab-button+ 24)

(export '+backing-store--not-useful+)

(defconstant +backing-store--not-useful+ 0)

(export '+backing-store--when-mapped+)

(defconstant +backing-store--when-mapped+ 1)

(export '+backing-store--always+)

(defconstant +backing-store--always+ 2)

(define-struct screen
 ((window root) (colormap default-colormap) (card32 white-pixel)
  (card32 black-pixel) (card32 current-input-masks) (card16 width-in-pixels)
  (card16 height-in-pixels) (card16 width-in-millimeters)
  (card16 height-in-millimeters) (card16 min-installed-maps)
  (card16 max-installed-maps) (visualid root-visual) (byte backing-stores)
  (bool save-unders) (card8 root-depth) (card8 allowed-depths-len)
  (list depth allowed-depths-len allowed-depths)))

(define-struct setup-request
 ((card8 byte-order) (pad bytes 1) (card16 protocol-major-version)
  (card16 protocol-minor-version) (card16 authorization-protocol-name-len)
  (card16 authorization-protocol-data-len) (pad bytes 2)
  (list char authorization-protocol-name-len authorization-protocol-name)
  (pad align 4)
  (list char authorization-protocol-data-len authorization-protocol-data)
  (pad align 4)))

(define-struct setup-failed
 ((card8 status) (card8 reason-len) (card16 protocol-major-version)
  (card16 protocol-minor-version) (card16 length)
  (list char reason-len reason)))

(define-struct setup-authenticate
 ((card8 status) (pad bytes 5) (card16 length) (list char (* length 4) reason)))

(export '+image-order--lsbfirst+)

(defconstant +image-order--lsbfirst+ 0)

(export '+image-order--msbfirst+)

(defconstant +image-order--msbfirst+ 1)

(define-struct setup
 ((card8 status) (pad bytes 1) (card16 protocol-major-version)
  (card16 protocol-minor-version) (card16 length) (card32 release-number)
  (card32 resource-id-base) (card32 resource-id-mask)
  (card32 motion-buffer-size) (card16 vendor-len)
  (card16 maximum-request-length) (card8 roots-len) (card8 pixmap-formats-len)
  (card8 image-byte-order) (card8 bitmap-format-bit-order)
  (card8 bitmap-format-scanline-unit) (card8 bitmap-format-scanline-pad)
  (keycode min-keycode) (keycode max-keycode) (pad bytes 4)
  (list char vendor-len vendor) (pad align 4)
  (list format pixmap-formats-len pixmap-formats)
  (list screen roots-len roots)))

(export '+mod-mask--shift+)

(defconstant +mod-mask--shift+ 0)

(export '+mod-mask--lock+)

(defconstant +mod-mask--lock+ 1)

(export '+mod-mask--control+)

(defconstant +mod-mask--control+ 2)

(export '+mod-mask--1+)

(defconstant +mod-mask--1+ 3)

(export '+mod-mask--2+)

(defconstant +mod-mask--2+ 4)

(export '+mod-mask--3+)

(defconstant +mod-mask--3+ 5)

(export '+mod-mask--4+)

(defconstant +mod-mask--4+ 6)

(export '+mod-mask--5+)

(defconstant +mod-mask--5+ 7)

(export '+mod-mask--any+)

(defconstant +mod-mask--any+ 15)

(export '+key-but-mask--shift+)

(defconstant +key-but-mask--shift+ 0)

(export '+key-but-mask--lock+)

(defconstant +key-but-mask--lock+ 1)

(export '+key-but-mask--control+)

(defconstant +key-but-mask--control+ 2)

(export '+key-but-mask--mod1+)

(defconstant +key-but-mask--mod1+ 3)

(export '+key-but-mask--mod2+)

(defconstant +key-but-mask--mod2+ 4)

(export '+key-but-mask--mod3+)

(defconstant +key-but-mask--mod3+ 5)

(export '+key-but-mask--mod4+)

(defconstant +key-but-mask--mod4+ 6)

(export '+key-but-mask--mod5+)

(defconstant +key-but-mask--mod5+ 7)

(export '+key-but-mask--button1+)

(defconstant +key-but-mask--button1+ 8)

(export '+key-but-mask--button2+)

(defconstant +key-but-mask--button2+ 9)

(export '+key-but-mask--button3+)

(defconstant +key-but-mask--button3+ 10)

(export '+key-but-mask--button4+)

(defconstant +key-but-mask--button4+ 11)

(export '+key-but-mask--button5+)

(defconstant +key-but-mask--button5+ 12)

(export '+window--none+)

(defconstant +window--none+ 0)

(define-event key-press 2
 ((keycode detail) (timestamp time) (window root) (window event) (window child)
  (int16 root-x) (int16 root-y) (int16 event-x) (int16 event-y) (card16 state)
  (bool same-screen) (pad bytes 1)))

(define-event key-release 3
 ((keycode detail) (timestamp time) (window root) (window event) (window child)
  (int16 root-x) (int16 root-y) (int16 event-x) (int16 event-y) (card16 state)
  (bool same-screen) (pad bytes 1)))

(export '+button-mask--1+)

(defconstant +button-mask--1+ 8)

(export '+button-mask--2+)

(defconstant +button-mask--2+ 9)

(export '+button-mask--3+)

(defconstant +button-mask--3+ 10)

(export '+button-mask--4+)

(defconstant +button-mask--4+ 11)

(export '+button-mask--5+)

(defconstant +button-mask--5+ 12)

(export '+button-mask--any+)

(defconstant +button-mask--any+ 15)

(define-event button-press 4
 ((button detail) (timestamp time) (window root) (window event) (window child)
  (int16 root-x) (int16 root-y) (int16 event-x) (int16 event-y) (card16 state)
  (bool same-screen) (pad bytes 1)))

(define-event button-release 5
 ((button detail) (timestamp time) (window root) (window event) (window child)
  (int16 root-x) (int16 root-y) (int16 event-x) (int16 event-y) (card16 state)
  (bool same-screen) (pad bytes 1)))

(export '+motion--normal+)

(defconstant +motion--normal+ 0)

(export '+motion--hint+)

(defconstant +motion--hint+ 1)

(define-event motion-notify 6
 ((byte detail) (timestamp time) (window root) (window event) (window child)
  (int16 root-x) (int16 root-y) (int16 event-x) (int16 event-y) (card16 state)
  (bool same-screen) (pad bytes 1)))

(export '+notify-detail--ancestor+)

(defconstant +notify-detail--ancestor+ 0)

(export '+notify-detail--virtual+)

(defconstant +notify-detail--virtual+ 1)

(export '+notify-detail--inferior+)

(defconstant +notify-detail--inferior+ 2)

(export '+notify-detail--nonlinear+)

(defconstant +notify-detail--nonlinear+ 3)

(export '+notify-detail--nonlinear-virtual+)

(defconstant +notify-detail--nonlinear-virtual+ 4)

(export '+notify-detail--pointer+)

(defconstant +notify-detail--pointer+ 5)

(export '+notify-detail--pointer-root+)

(defconstant +notify-detail--pointer-root+ 6)

(export '+notify-detail--none+)

(defconstant +notify-detail--none+ 7)

(export '+notify-mode--normal+)

(defconstant +notify-mode--normal+ 0)

(export '+notify-mode--grab+)

(defconstant +notify-mode--grab+ 1)

(export '+notify-mode--ungrab+)

(defconstant +notify-mode--ungrab+ 2)

(export '+notify-mode--while-grabbed+)

(defconstant +notify-mode--while-grabbed+ 3)

(define-event enter-notify 7
 ((byte detail) (timestamp time) (window root) (window event) (window child)
  (int16 root-x) (int16 root-y) (int16 event-x) (int16 event-y) (card16 state)
  (byte mode) (byte same-screen-focus)))

(define-event leave-notify 8
 ((byte detail) (timestamp time) (window root) (window event) (window child)
  (int16 root-x) (int16 root-y) (int16 event-x) (int16 event-y) (card16 state)
  (byte mode) (byte same-screen-focus)))

(define-event focus-in 9
 ((byte detail) (window event) (byte mode) (pad bytes 3)))

(define-event focus-out 10
 ((byte detail) (window event) (byte mode) (pad bytes 3)))

(define-event keymap-notify 11 ((list card8 31 keys)))

(define-event expose 12
 ((pad bytes 1) (window window) (card16 x) (card16 y) (card16 width)
  (card16 height) (card16 count) (pad bytes 2)))

(define-event graphics-exposure 13
 ((pad bytes 1) (drawable drawable) (card16 x) (card16 y) (card16 width)
  (card16 height) (card16 minor-opcode) (card16 count) (card8 major-opcode)
  (pad bytes 3)))

(define-event no-exposure 14
 ((pad bytes 1) (drawable drawable) (card16 minor-opcode) (card8 major-opcode)
  (pad bytes 1)))

(export '+visibility--unobscured+)

(defconstant +visibility--unobscured+ 0)

(export '+visibility--partially-obscured+)

(defconstant +visibility--partially-obscured+ 1)

(export '+visibility--fully-obscured+)

(defconstant +visibility--fully-obscured+ 2)

(define-event visibility-notify 15
 ((pad bytes 1) (window window) (byte state) (pad bytes 3)))

(define-event create-notify 16
 ((pad bytes 1) (window parent) (window window) (int16 x) (int16 y)
  (card16 width) (card16 height) (card16 border-width) (bool override-redirect)
  (pad bytes 1)))

(define-event destroy-notify 17 ((pad bytes 1) (window event) (window window)))

(define-event unmap-notify 18
 ((pad bytes 1) (window event) (window window) (bool from-configure)
  (pad bytes 3)))

(define-event map-notify 19
 ((pad bytes 1) (window event) (window window) (bool override-redirect)
  (pad bytes 3)))

(define-event map-request 20 ((pad bytes 1) (window parent) (window window)))

(define-event reparent-notify 21
 ((pad bytes 1) (window event) (window window) (window parent) (int16 x)
  (int16 y) (bool override-redirect) (pad bytes 3)))

(define-event configure-notify 22
 ((pad bytes 1) (window event) (window window) (window above-sibling) (int16 x)
  (int16 y) (card16 width) (card16 height) (card16 border-width)
  (bool override-redirect) (pad bytes 1)))

(define-event configure-request 23
 ((byte stack-mode) (window parent) (window window) (window sibling) (int16 x)
  (int16 y) (card16 width) (card16 height) (card16 border-width)
  (card16 value-mask)))

(define-event gravity-notify 24
 ((pad bytes 1) (window event) (window window) (int16 x) (int16 y)))

(define-event resize-request 25
 ((pad bytes 1) (window window) (card16 width) (card16 height)))

(export '+place--on-top+)

(defconstant +place--on-top+ 0)

(export '+place--on-bottom+)

(defconstant +place--on-bottom+ 1)

(define-event circulate-notify 26
 ((pad bytes 1) (window event) (window window) (pad bytes 4) (byte place)
  (pad bytes 3)))

(define-event circulate-request 27
 ((pad bytes 1) (window event) (window window) (pad bytes 4) (byte place)
  (pad bytes 3)))

(export '+property--new-value+)

(defconstant +property--new-value+ 0)

(export '+property--delete+)

(defconstant +property--delete+ 1)

(define-event property-notify 28
 ((pad bytes 1) (window window) (atom atom) (timestamp time) (byte state)
  (pad bytes 3)))

(define-event selection-clear 29
 ((pad bytes 1) (timestamp time) (window owner) (atom selection)))

(export '+time--current-time+)

(defconstant +time--current-time+ 0)

(export '+atom--none+)

(defconstant +atom--none+ 0)

(export '+atom--any+)

(defconstant +atom--any+ 0)

(export '+atom--primary+)

(defconstant +atom--primary+ 1)

(export '+atom--secondary+)

(defconstant +atom--secondary+ 2)

(export '+atom--arc+)

(defconstant +atom--arc+ 3)

(export '+atom--atom+)

(defconstant +atom--atom+ 4)

(export '+atom--bitmap+)

(defconstant +atom--bitmap+ 5)

(export '+atom--cardinal+)

(defconstant +atom--cardinal+ 6)

(export '+atom--colormap+)

(defconstant +atom--colormap+ 7)

(export '+atom--cursor+)

(defconstant +atom--cursor+ 8)

(export '+atom--cut-buffer0+)

(defconstant +atom--cut-buffer0+ 9)

(export '+atom--cut-buffer1+)

(defconstant +atom--cut-buffer1+ 10)

(export '+atom--cut-buffer2+)

(defconstant +atom--cut-buffer2+ 11)

(export '+atom--cut-buffer3+)

(defconstant +atom--cut-buffer3+ 12)

(export '+atom--cut-buffer4+)

(defconstant +atom--cut-buffer4+ 13)

(export '+atom--cut-buffer5+)

(defconstant +atom--cut-buffer5+ 14)

(export '+atom--cut-buffer6+)

(defconstant +atom--cut-buffer6+ 15)

(export '+atom--cut-buffer7+)

(defconstant +atom--cut-buffer7+ 16)

(export '+atom--drawable+)

(defconstant +atom--drawable+ 17)

(export '+atom--font+)

(defconstant +atom--font+ 18)

(export '+atom--integer+)

(defconstant +atom--integer+ 19)

(export '+atom--pixmap+)

(defconstant +atom--pixmap+ 20)

(export '+atom--point+)

(defconstant +atom--point+ 21)

(export '+atom--rectangle+)

(defconstant +atom--rectangle+ 22)

(export '+atom--resource-manager+)

(defconstant +atom--resource-manager+ 23)

(export '+atom--rgb-color-map+)

(defconstant +atom--rgb-color-map+ 24)

(export '+atom--rgb-best-map+)

(defconstant +atom--rgb-best-map+ 25)

(export '+atom--rgb-blue-map+)

(defconstant +atom--rgb-blue-map+ 26)

(export '+atom--rgb-default-map+)

(defconstant +atom--rgb-default-map+ 27)

(export '+atom--rgb-gray-map+)

(defconstant +atom--rgb-gray-map+ 28)

(export '+atom--rgb-green-map+)

(defconstant +atom--rgb-green-map+ 29)

(export '+atom--rgb-red-map+)

(defconstant +atom--rgb-red-map+ 30)

(export '+atom--string+)

(defconstant +atom--string+ 31)

(export '+atom--visualid+)

(defconstant +atom--visualid+ 32)

(export '+atom--window+)

(defconstant +atom--window+ 33)

(export '+atom--wm-command+)

(defconstant +atom--wm-command+ 34)

(export '+atom--wm-hints+)

(defconstant +atom--wm-hints+ 35)

(export '+atom--wm-client-machine+)

(defconstant +atom--wm-client-machine+ 36)

(export '+atom--wm-icon-name+)

(defconstant +atom--wm-icon-name+ 37)

(export '+atom--wm-icon-size+)

(defconstant +atom--wm-icon-size+ 38)

(export '+atom--wm-name+)

(defconstant +atom--wm-name+ 39)

(export '+atom--wm-normal-hints+)

(defconstant +atom--wm-normal-hints+ 40)

(export '+atom--wm-size-hints+)

(defconstant +atom--wm-size-hints+ 41)

(export '+atom--wm-zoom-hints+)

(defconstant +atom--wm-zoom-hints+ 42)

(export '+atom--min-space+)

(defconstant +atom--min-space+ 43)

(export '+atom--norm-space+)

(defconstant +atom--norm-space+ 44)

(export '+atom--max-space+)

(defconstant +atom--max-space+ 45)

(export '+atom--end-space+)

(defconstant +atom--end-space+ 46)

(export '+atom--superscript-x+)

(defconstant +atom--superscript-x+ 47)

(export '+atom--superscript-y+)

(defconstant +atom--superscript-y+ 48)

(export '+atom--subscript-x+)

(defconstant +atom--subscript-x+ 49)

(export '+atom--subscript-y+)

(defconstant +atom--subscript-y+ 50)

(export '+atom--underline-position+)

(defconstant +atom--underline-position+ 51)

(export '+atom--underline-thickness+)

(defconstant +atom--underline-thickness+ 52)

(export '+atom--strikeout-ascent+)

(defconstant +atom--strikeout-ascent+ 53)

(export '+atom--strikeout-descent+)

(defconstant +atom--strikeout-descent+ 54)

(export '+atom--italic-angle+)

(defconstant +atom--italic-angle+ 55)

(export '+atom--x-height+)

(defconstant +atom--x-height+ 56)

(export '+atom--quad-width+)

(defconstant +atom--quad-width+ 57)

(export '+atom--weight+)

(defconstant +atom--weight+ 58)

(export '+atom--point-size+)

(defconstant +atom--point-size+ 59)

(export '+atom--resolution+)

(defconstant +atom--resolution+ 60)

(export '+atom--copyright+)

(defconstant +atom--copyright+ 61)

(export '+atom--notice+)

(defconstant +atom--notice+ 62)

(export '+atom--font-name+)

(defconstant +atom--font-name+ 63)

(export '+atom--family-name+)

(defconstant +atom--family-name+ 64)

(export '+atom--full-name+)

(defconstant +atom--full-name+ 65)

(export '+atom--cap-height+)

(defconstant +atom--cap-height+ 66)

(export '+atom--wm-class+)

(defconstant +atom--wm-class+ 67)

(export '+atom--wm-transient-for+)

(defconstant +atom--wm-transient-for+ 68)

(define-event selection-request 30
 ((pad bytes 1) (timestamp time) (window owner) (window requestor)
  (atom selection) (atom target) (atom property)))

(define-event selection-notify 31
 ((pad bytes 1) (timestamp time) (window requestor) (atom selection)
  (atom target) (atom property)))

(export '+colormap-state--uninstalled+)

(defconstant +colormap-state--uninstalled+ 0)

(export '+colormap-state--installed+)

(defconstant +colormap-state--installed+ 1)

(export '+colormap--none+)

(defconstant +colormap--none+ 0)

(define-event colormap-notify 32
 ((pad bytes 1) (window window) (colormap colormap) (bool new) (byte state)
  (pad bytes 2)))

(define-event client-message 33
 ((card8 format) (window window) (atom type) (() data)))

(export '+mapping--modifier+)

(defconstant +mapping--modifier+ 0)

(export '+mapping--keyboard+)

(defconstant +mapping--keyboard+ 1)

(export '+mapping--pointer+)

(defconstant +mapping--pointer+ 2)

(define-event mapping-notify 34
 ((pad bytes 1) (byte request) (keycode first-keycode) (card8 count)
  (pad bytes 1)))

(define-event ge-generic 35 ((pad bytes 22)))

(define-error request 1)

(define-error value 2)

(define-error window 3)

(define-error pixmap 4)

(define-error atom 5)

(define-error cursor 6)

(define-error font 7)

(define-error match 8)

(define-error drawable 9)

(define-error access 10)

(define-error alloc 11)

(define-error colormap 12)

(define-error gcontext 13)

(define-error idchoice 14)

(define-error name 15)

(define-error length 16)

(define-error implementation 17)

(export '+window-class--copy-from-parent+)

(defconstant +window-class--copy-from-parent+ 0)

(export '+window-class--input-output+)

(defconstant +window-class--input-output+ 1)

(export '+window-class--input-only+)

(defconstant +window-class--input-only+ 2)

(export '+cw--back-pixmap+)

(defconstant +cw--back-pixmap+ 0)

(export '+cw--back-pixel+)

(defconstant +cw--back-pixel+ 1)

(export '+cw--border-pixmap+)

(defconstant +cw--border-pixmap+ 2)

(export '+cw--border-pixel+)

(defconstant +cw--border-pixel+ 3)

(export '+cw--bit-gravity+)

(defconstant +cw--bit-gravity+ 4)

(export '+cw--win-gravity+)

(defconstant +cw--win-gravity+ 5)

(export '+cw--backing-store+)

(defconstant +cw--backing-store+ 6)

(export '+cw--backing-planes+)

(defconstant +cw--backing-planes+ 7)

(export '+cw--backing-pixel+)

(defconstant +cw--backing-pixel+ 8)

(export '+cw--override-redirect+)

(defconstant +cw--override-redirect+ 9)

(export '+cw--save-under+)

(defconstant +cw--save-under+ 10)

(export '+cw--event-mask+)

(defconstant +cw--event-mask+ 11)

(export '+cw--dont-propagate+)

(defconstant +cw--dont-propagate+ 12)

(export '+cw--colormap+)

(defconstant +cw--colormap+ 13)

(export '+cw--cursor+)

(defconstant +cw--cursor+ 14)

(export '+back-pixmap--none+)

(defconstant +back-pixmap--none+ 0)

(export '+back-pixmap--parent-relative+)

(defconstant +back-pixmap--parent-relative+ 1)

(export '+gravity--bit-forget+)

(defconstant +gravity--bit-forget+ 0)

(export '+gravity--win-unmap+)

(defconstant +gravity--win-unmap+ 0)

(export '+gravity--north-west+)

(defconstant +gravity--north-west+ 1)

(export '+gravity--north+)

(defconstant +gravity--north+ 2)

(export '+gravity--north-east+)

(defconstant +gravity--north-east+ 3)

(export '+gravity--west+)

(defconstant +gravity--west+ 4)

(export '+gravity--center+)

(defconstant +gravity--center+ 5)

(export '+gravity--east+)

(defconstant +gravity--east+ 6)

(export '+gravity--south-west+)

(defconstant +gravity--south-west+ 7)

(export '+gravity--south+)

(defconstant +gravity--south+ 8)

(export '+gravity--south-east+)

(defconstant +gravity--south-east+ 9)

(export '+gravity--static+)

(defconstant +gravity--static+ 10)

(define-request create-window 1
 ((card8 depth) (window wid) (window parent) (int16 x) (int16 y) (card16 width)
  (card16 height) (card16 border-width) (card16 class) (visualid visual)
  (card32 value-mask)
  (bitcase value-mask () ((+cw--back-pixmap+) ((pixmap background-pixmap)))
   ((+cw--back-pixel+) ((card32 background-pixel)))
   ((+cw--border-pixmap+) ((pixmap border-pixmap)))
   ((+cw--border-pixel+) ((card32 border-pixel)))
   ((+cw--bit-gravity+) ((card32 bit-gravity)))
   ((+cw--win-gravity+) ((card32 win-gravity)))
   ((+cw--backing-store+) ((card32 backing-store)))
   ((+cw--backing-planes+) ((card32 backing-planes)))
   ((+cw--backing-pixel+) ((card32 backing-pixel)))
   ((+cw--override-redirect+) ((bool32 override-redirect)))
   ((+cw--save-under+) ((bool32 save-under)))
   ((+cw--event-mask+) ((card32 event-mask)))
   ((+cw--dont-propagate+) ((card32 do-not-propogate-mask)))
   ((+cw--colormap+) ((colormap colormap)))
   ((+cw--cursor+) ((cursor cursor)))))
 ())

(define-request change-window-attributes 2
 ((pad bytes 1) (window window) (card32 value-mask)
  (bitcase value-mask () ((+cw--back-pixmap+) ((pixmap background-pixmap)))
   ((+cw--back-pixel+) ((card32 background-pixel)))
   ((+cw--border-pixmap+) ((pixmap border-pixmap)))
   ((+cw--border-pixel+) ((card32 border-pixel)))
   ((+cw--bit-gravity+) ((card32 bit-gravity)))
   ((+cw--win-gravity+) ((card32 win-gravity)))
   ((+cw--backing-store+) ((card32 backing-store)))
   ((+cw--backing-planes+) ((card32 backing-planes)))
   ((+cw--backing-pixel+) ((card32 backing-pixel)))
   ((+cw--override-redirect+) ((bool32 override-redirect)))
   ((+cw--save-under+) ((bool32 save-under)))
   ((+cw--event-mask+) ((card32 event-mask)))
   ((+cw--dont-propagate+) ((card32 do-not-propogate-mask)))
   ((+cw--colormap+) ((colormap colormap)))
   ((+cw--cursor+) ((cursor cursor)))))
 ())

(export '+map-state--unmapped+)

(defconstant +map-state--unmapped+ 0)

(export '+map-state--unviewable+)

(defconstant +map-state--unviewable+ 1)

(export '+map-state--viewable+)

(defconstant +map-state--viewable+ 2)

(define-request get-window-attributes 3 ((pad bytes 1) (window window))
 ((card8 backing-store) (visualid visual) (card16 class) (card8 bit-gravity)
  (card8 win-gravity) (card32 backing-planes) (card32 backing-pixel)
  (bool save-under) (bool map-is-installed) (card8 map-state)
  (bool override-redirect) (colormap colormap) (card32 all-event-masks)
  (card32 your-event-mask) (card16 do-not-propagate-mask) (pad bytes 2)))

(define-request destroy-window 4 ((pad bytes 1) (window window)) ())

(define-request destroy-subwindows 5 ((pad bytes 1) (window window)) ())

(export '+set-mode--insert+)

(defconstant +set-mode--insert+ 0)

(export '+set-mode--delete+)

(defconstant +set-mode--delete+ 1)

(define-request change-save-set 6 ((byte mode) (window window)) ())

(define-request reparent-window 7
 ((pad bytes 1) (window window) (window parent) (int16 x) (int16 y)) ())

(define-request map-window 8 ((pad bytes 1) (window window)) ())

(define-request map-subwindows 9 ((pad bytes 1) (window window)) ())

(define-request unmap-window 10 ((pad bytes 1) (window window)) ())

(define-request unmap-subwindows 11 ((pad bytes 1) (window window)) ())

(export '+config-window--x+)

(defconstant +config-window--x+ 0)

(export '+config-window--y+)

(defconstant +config-window--y+ 1)

(export '+config-window--width+)

(defconstant +config-window--width+ 2)

(export '+config-window--height+)

(defconstant +config-window--height+ 3)

(export '+config-window--border-width+)

(defconstant +config-window--border-width+ 4)

(export '+config-window--sibling+)

(defconstant +config-window--sibling+ 5)

(export '+config-window--stack-mode+)

(defconstant +config-window--stack-mode+ 6)

(export '+stack-mode--above+)

(defconstant +stack-mode--above+ 0)

(export '+stack-mode--below+)

(defconstant +stack-mode--below+ 1)

(export '+stack-mode--top-if+)

(defconstant +stack-mode--top-if+ 2)

(export '+stack-mode--bottom-if+)

(defconstant +stack-mode--bottom-if+ 3)

(export '+stack-mode--opposite+)

(defconstant +stack-mode--opposite+ 4)

(define-request configure-window 12
 ((pad bytes 1) (window window) (card16 value-mask) (pad bytes 2)
  (bitcase value-mask () ((+config-window--x+) ((int32 x)))
   ((+config-window--y+) ((int32 y)))
   ((+config-window--width+) ((card32 width)))
   ((+config-window--height+) ((card32 height)))
   ((+config-window--border-width+) ((card32 border-width)))
   ((+config-window--sibling+) ((window sibling)))
   ((+config-window--stack-mode+) ((card32 stack-mode)))))
 ())

(export '+circulate--raise-lowest+)

(defconstant +circulate--raise-lowest+ 0)

(export '+circulate--lower-highest+)

(defconstant +circulate--lower-highest+ 1)

(define-request circulate-window 13 ((card8 direction) (window window)) ())

(define-request get-geometry 14 ((pad bytes 1) (drawable drawable))
 ((card8 depth) (window root) (int16 x) (int16 y) (card16 width)
  (card16 height) (card16 border-width) (pad bytes 2)))

(define-request query-tree 15 ((pad bytes 1) (window window))
 ((pad bytes 1) (window root) (window parent) (card16 children-len)
  (pad bytes 14) (list window children-len children)))

(define-request intern-atom 16
 ((bool only-if-exists) (card16 name-len) (pad bytes 2)
  (list char name-len name))
 ((pad bytes 1) (atom atom)))

(define-request get-atom-name 17 ((pad bytes 1) (atom atom))
 ((pad bytes 1) (card16 name-len) (pad bytes 22) (list char name-len name)))

(export '+prop-mode--replace+)

(defconstant +prop-mode--replace+ 0)

(export '+prop-mode--prepend+)

(defconstant +prop-mode--prepend+ 1)

(export '+prop-mode--append+)

(defconstant +prop-mode--append+ 2)

(define-request change-property 18
 ((card8 mode) (window window) (atom property) (atom type) (card8 format)
  (pad bytes 3) (card32 data-len) (list void (/ (* data-len format) 8) data))
 ())

(define-request delete-property 19
 ((pad bytes 1) (window window) (atom property)) ())

(export '+get-property-type--any+)

(defconstant +get-property-type--any+ 0)

(define-request get-property 20
 ((bool delete) (window window) (atom property) (atom type)
  (card32 long-offset) (card32 long-length))
 ((card8 format) (atom type) (card32 bytes-after) (card32 value-len)
  (pad bytes 12) (list void (* value-len (/ format 8)) value)))

(define-request list-properties 21 ((pad bytes 1) (window window))
 ((pad bytes 1) (card16 atoms-len) (pad bytes 22) (list atom atoms-len atoms)))

(define-request set-selection-owner 22
 ((pad bytes 1) (window owner) (atom selection) (timestamp time)) ())

(define-request get-selection-owner 23 ((pad bytes 1) (atom selection))
 ((pad bytes 1) (window owner)))

(define-request convert-selection 24
 ((pad bytes 1) (window requestor) (atom selection) (atom target)
  (atom property) (timestamp time))
 ())

(export '+send-event-dest--pointer-window+)

(defconstant +send-event-dest--pointer-window+ 0)

(export '+send-event-dest--item-focus+)

(defconstant +send-event-dest--item-focus+ 1)

(define-request send-event 25
 ((bool propagate) (window destination) (card32 event-mask)
  (list char 32 event))
 ())

(export '+grab-mode--sync+)

(defconstant +grab-mode--sync+ 0)

(export '+grab-mode--async+)

(defconstant +grab-mode--async+ 1)

(export '+grab-status--success+)

(defconstant +grab-status--success+ 0)

(export '+grab-status--already-grabbed+)

(defconstant +grab-status--already-grabbed+ 1)

(export '+grab-status--invalid-time+)

(defconstant +grab-status--invalid-time+ 2)

(export '+grab-status--not-viewable+)

(defconstant +grab-status--not-viewable+ 3)

(export '+grab-status--frozen+)

(defconstant +grab-status--frozen+ 4)

(export '+cursor--none+)

(defconstant +cursor--none+ 0)

(define-request grab-pointer 26
 ((bool owner-events) (window grab-window) (card16 event-mask)
  (byte pointer-mode) (byte keyboard-mode) (window confine-to) (cursor cursor)
  (timestamp time))
 ((byte status)))

(define-request ungrab-pointer 27 ((pad bytes 1) (timestamp time)) ())

(export '+button-index--any+)

(defconstant +button-index--any+ 0)

(export '+button-index--1+)

(defconstant +button-index--1+ 1)

(export '+button-index--2+)

(defconstant +button-index--2+ 2)

(export '+button-index--3+)

(defconstant +button-index--3+ 3)

(export '+button-index--4+)

(defconstant +button-index--4+ 4)

(export '+button-index--5+)

(defconstant +button-index--5+ 5)

(define-request grab-button 28
 ((bool owner-events) (window grab-window) (card16 event-mask)
  (card8 pointer-mode) (card8 keyboard-mode) (window confine-to)
  (cursor cursor) (card8 button) (pad bytes 1) (card16 modifiers))
 ())

(define-request ungrab-button 29
 ((card8 button) (window grab-window) (card16 modifiers) (pad bytes 2)) ())

(define-request change-active-pointer-grab 30
 ((pad bytes 1) (cursor cursor) (timestamp time) (card16 event-mask)
  (pad bytes 2))
 ())

(define-request grab-keyboard 31
 ((bool owner-events) (window grab-window) (timestamp time) (byte pointer-mode)
  (byte keyboard-mode) (pad bytes 2))
 ((byte status)))

(define-request ungrab-keyboard 32 ((pad bytes 1) (timestamp time)) ())

(export '+grab--any+)

(defconstant +grab--any+ 0)

(define-request grab-key 33
 ((bool owner-events) (window grab-window) (card16 modifiers) (keycode key)
  (card8 pointer-mode) (card8 keyboard-mode) (pad bytes 3))
 ())

(define-request ungrab-key 34
 ((keycode key) (window grab-window) (card16 modifiers) (pad bytes 2)) ())

(export '+allow--async-pointer+)

(defconstant +allow--async-pointer+ 0)

(export '+allow--sync-pointer+)

(defconstant +allow--sync-pointer+ 1)

(export '+allow--replay-pointer+)

(defconstant +allow--replay-pointer+ 2)

(export '+allow--async-keyboard+)

(defconstant +allow--async-keyboard+ 3)

(export '+allow--sync-keyboard+)

(defconstant +allow--sync-keyboard+ 4)

(export '+allow--replay-keyboard+)

(defconstant +allow--replay-keyboard+ 5)

(export '+allow--async-both+)

(defconstant +allow--async-both+ 6)

(export '+allow--sync-both+)

(defconstant +allow--sync-both+ 7)

(define-request allow-events 35 ((card8 mode) (timestamp time)) ())

(define-request grab-server 36 () ())

(define-request ungrab-server 37 () ())

(define-request query-pointer 38 ((pad bytes 1) (window window))
 ((bool same-screen) (window root) (window child) (int16 root-x) (int16 root-y)
  (int16 win-x) (int16 win-y) (card16 mask) (pad bytes 2)))

(define-struct timecoord ((timestamp time) (int16 x) (int16 y)))

(define-request get-motion-events 39
 ((pad bytes 1) (window window) (timestamp start) (timestamp stop))
 ((pad bytes 1) (card32 events-len) (pad bytes 20)
  (list timecoord events-len events)))

(define-request translate-coordinates 40
 ((pad bytes 1) (window src-window) (window dst-window) (int16 src-x)
  (int16 src-y))
 ((bool same-screen) (window child) (int16 dst-x) (int16 dst-y)))

(define-request warp-pointer 41
 ((pad bytes 1) (window src-window) (window dst-window) (int16 src-x)
  (int16 src-y) (card16 src-width) (card16 src-height) (int16 dst-x)
  (int16 dst-y))
 ())

(export '+input-focus--none+)

(defconstant +input-focus--none+ 0)

(export '+input-focus--pointer-root+)

(defconstant +input-focus--pointer-root+ 1)

(export '+input-focus--parent+)

(defconstant +input-focus--parent+ 2)

(export '+input-focus--follow-keyboard+)

(defconstant +input-focus--follow-keyboard+ 3)

(define-request set-input-focus 42
 ((card8 revert-to) (window focus) (timestamp time)) ())

(define-request get-input-focus 43 () ((card8 revert-to) (window focus)))

(define-request query-keymap 44 () ((pad bytes 1) (list card8 32 keys)))

(define-request open-font 45
 ((pad bytes 1) (font fid) (card16 name-len) (pad bytes 2)
  (list char name-len name))
 ())

(define-request close-font 46 ((pad bytes 1) (font font)) ())

(export '+font-draw--left-to-right+)

(defconstant +font-draw--left-to-right+ 0)

(export '+font-draw--right-to-left+)

(defconstant +font-draw--right-to-left+ 1)

(define-struct fontprop ((atom name) (card32 value)))

(define-struct charinfo
 ((int16 left-side-bearing) (int16 right-side-bearing) (int16 character-width)
  (int16 ascent) (int16 descent) (card16 attributes)))

(define-request query-font 47 ((pad bytes 1) (fontable font))
 ((pad bytes 1) (charinfo min-bounds) (pad bytes 4) (charinfo max-bounds)
  (pad bytes 4) (card16 min-char-or-byte2) (card16 max-char-or-byte2)
  (card16 default-char) (card16 properties-len) (byte draw-direction)
  (card8 min-byte1) (card8 max-byte1) (bool all-chars-exist)
  (int16 font-ascent) (int16 font-descent) (card32 char-infos-len)
  (list fontprop properties-len properties)
  (list charinfo char-infos-len char-infos)))

(define-request query-text-extents 48
 ((aux (bool odd-length) (logand string-len 1)) (fontable font)
  (list char2b (length string) string))
 ((byte draw-direction) (int16 font-ascent) (int16 font-descent)
  (int16 overall-ascent) (int16 overall-descent) (int32 overall-width)
  (int32 overall-left) (int32 overall-right)))

(define-struct str ((card8 name-len) (list char name-len name)))

(define-request list-fonts 49
 ((pad bytes 1) (card16 max-names) (card16 pattern-len)
  (list char pattern-len pattern))
 ((pad bytes 1) (card16 names-len) (pad bytes 22) (list str names-len names)))

(define-request list-fonts-with-info 50
 ((pad bytes 1) (card16 max-names) (card16 pattern-len)
  (list char pattern-len pattern))
 ((card8 name-len) (charinfo min-bounds) (pad bytes 4) (charinfo max-bounds)
  (pad bytes 4) (card16 min-char-or-byte2) (card16 max-char-or-byte2)
  (card16 default-char) (card16 properties-len) (byte draw-direction)
  (card8 min-byte1) (card8 max-byte1) (bool all-chars-exist)
  (int16 font-ascent) (int16 font-descent) (card32 replies-hint)
  (list fontprop properties-len properties) (list char name-len name)))

(define-request set-font-path 51
 ((pad bytes 1) (card16 font-qty) (pad bytes 2) (list str font-qty font)) ())

(define-request get-font-path 52 ()
 ((pad bytes 1) (card16 path-len) (pad bytes 22) (list str path-len path)))

(define-request create-pixmap 53
 ((card8 depth) (pixmap pid) (drawable drawable) (card16 width)
  (card16 height))
 ())

(define-request free-pixmap 54 ((pad bytes 1) (pixmap pixmap)) ())

(export '+gc--function+)

(defconstant +gc--function+ 0)

(export '+gc--plane-mask+)

(defconstant +gc--plane-mask+ 1)

(export '+gc--foreground+)

(defconstant +gc--foreground+ 2)

(export '+gc--background+)

(defconstant +gc--background+ 3)

(export '+gc--line-width+)

(defconstant +gc--line-width+ 4)

(export '+gc--line-style+)

(defconstant +gc--line-style+ 5)

(export '+gc--cap-style+)

(defconstant +gc--cap-style+ 6)

(export '+gc--join-style+)

(defconstant +gc--join-style+ 7)

(export '+gc--fill-style+)

(defconstant +gc--fill-style+ 8)

(export '+gc--fill-rule+)

(defconstant +gc--fill-rule+ 9)

(export '+gc--tile+)

(defconstant +gc--tile+ 10)

(export '+gc--stipple+)

(defconstant +gc--stipple+ 11)

(export '+gc--tile-stipple-origin-x+)

(defconstant +gc--tile-stipple-origin-x+ 12)

(export '+gc--tile-stipple-origin-y+)

(defconstant +gc--tile-stipple-origin-y+ 13)

(export '+gc--font+)

(defconstant +gc--font+ 14)

(export '+gc--subwindow-mode+)

(defconstant +gc--subwindow-mode+ 15)

(export '+gc--graphics-exposures+)

(defconstant +gc--graphics-exposures+ 16)

(export '+gc--clip-origin-x+)

(defconstant +gc--clip-origin-x+ 17)

(export '+gc--clip-origin-y+)

(defconstant +gc--clip-origin-y+ 18)

(export '+gc--clip-mask+)

(defconstant +gc--clip-mask+ 19)

(export '+gc--dash-offset+)

(defconstant +gc--dash-offset+ 20)

(export '+gc--dash-list+)

(defconstant +gc--dash-list+ 21)

(export '+gc--arc-mode+)

(defconstant +gc--arc-mode+ 22)

(export '+gx--clear+)

(defconstant +gx--clear+ 0)

(export '+gx--and+)

(defconstant +gx--and+ 1)

(export '+gx--and-reverse+)

(defconstant +gx--and-reverse+ 2)

(export '+gx--copy+)

(defconstant +gx--copy+ 3)

(export '+gx--and-inverted+)

(defconstant +gx--and-inverted+ 4)

(export '+gx--noop+)

(defconstant +gx--noop+ 5)

(export '+gx--xor+)

(defconstant +gx--xor+ 6)

(export '+gx--or+)

(defconstant +gx--or+ 7)

(export '+gx--nor+)

(defconstant +gx--nor+ 8)

(export '+gx--equiv+)

(defconstant +gx--equiv+ 9)

(export '+gx--invert+)

(defconstant +gx--invert+ 10)

(export '+gx--or-reverse+)

(defconstant +gx--or-reverse+ 11)

(export '+gx--copy-inverted+)

(defconstant +gx--copy-inverted+ 12)

(export '+gx--or-inverted+)

(defconstant +gx--or-inverted+ 13)

(export '+gx--nand+)

(defconstant +gx--nand+ 14)

(export '+gx--set+)

(defconstant +gx--set+ 15)

(export '+line-style--solid+)

(defconstant +line-style--solid+ 0)

(export '+line-style--on-off-dash+)

(defconstant +line-style--on-off-dash+ 1)

(export '+line-style--double-dash+)

(defconstant +line-style--double-dash+ 2)

(export '+cap-style--not-last+)

(defconstant +cap-style--not-last+ 0)

(export '+cap-style--butt+)

(defconstant +cap-style--butt+ 1)

(export '+cap-style--round+)

(defconstant +cap-style--round+ 2)

(export '+cap-style--projecting+)

(defconstant +cap-style--projecting+ 3)

(export '+join-style--miter+)

(defconstant +join-style--miter+ 0)

(export '+join-style--round+)

(defconstant +join-style--round+ 1)

(export '+join-style--bevel+)

(defconstant +join-style--bevel+ 2)

(export '+fill-style--solid+)

(defconstant +fill-style--solid+ 0)

(export '+fill-style--tiled+)

(defconstant +fill-style--tiled+ 1)

(export '+fill-style--stippled+)

(defconstant +fill-style--stippled+ 2)

(export '+fill-style--opaque-stippled+)

(defconstant +fill-style--opaque-stippled+ 3)

(export '+fill-rule--even-odd+)

(defconstant +fill-rule--even-odd+ 0)

(export '+fill-rule--winding+)

(defconstant +fill-rule--winding+ 1)

(export '+subwindow-mode--clip-by-children+)

(defconstant +subwindow-mode--clip-by-children+ 0)

(export '+subwindow-mode--include-inferiors+)

(defconstant +subwindow-mode--include-inferiors+ 1)

(export '+arc-mode--chord+)

(defconstant +arc-mode--chord+ 0)

(export '+arc-mode--pie-slice+)

(defconstant +arc-mode--pie-slice+ 1)

(define-request create-gc 55
 ((pad bytes 1) (gcontext cid) (drawable drawable) (card32 value-mask)
  (bitcase value-mask () ((+gc--function+) ((card32 function)))
   ((+gc--plane-mask+) ((card32 plane-mask)))
   ((+gc--foreground+) ((card32 foreground)))
   ((+gc--background+) ((card32 background)))
   ((+gc--line-width+) ((card32 line-width)))
   ((+gc--line-style+) ((card32 line-style)))
   ((+gc--cap-style+) ((card32 cap-style)))
   ((+gc--join-style+) ((card32 join-style)))
   ((+gc--fill-style+) ((card32 fill-style)))
   ((+gc--fill-rule+) ((card32 fill-rule))) ((+gc--tile+) ((pixmap tile)))
   ((+gc--stipple+) ((pixmap stipple)))
   ((+gc--tile-stipple-origin-x+) ((int32 tile-stipple-x-origin)))
   ((+gc--tile-stipple-origin-y+) ((int32 tile-stipple-y-origin)))
   ((+gc--font+) ((font font)))
   ((+gc--subwindow-mode+) ((card32 subwindow-mode)))
   ((+gc--graphics-exposures+) ((bool32 graphics-exposures)))
   ((+gc--clip-origin-x+) ((int32 clip-x-origin)))
   ((+gc--clip-origin-y+) ((int32 clip-y-origin)))
   ((+gc--clip-mask+) ((pixmap clip-mask)))
   ((+gc--dash-offset+) ((card32 dash-offset)))
   ((+gc--dash-list+) ((card32 dashes)))
   ((+gc--arc-mode+) ((card32 arc-mode)))))
 ())

(define-request change-gc 56
 ((pad bytes 1) (gcontext gc) (card32 value-mask)
  (bitcase value-mask () ((+gc--function+) ((card32 function)))
   ((+gc--plane-mask+) ((card32 plane-mask)))
   ((+gc--foreground+) ((card32 foreground)))
   ((+gc--background+) ((card32 background)))
   ((+gc--line-width+) ((card32 line-width)))
   ((+gc--line-style+) ((card32 line-style)))
   ((+gc--cap-style+) ((card32 cap-style)))
   ((+gc--join-style+) ((card32 join-style)))
   ((+gc--fill-style+) ((card32 fill-style)))
   ((+gc--fill-rule+) ((card32 fill-rule))) ((+gc--tile+) ((pixmap tile)))
   ((+gc--stipple+) ((pixmap stipple)))
   ((+gc--tile-stipple-origin-x+) ((int32 tile-stipple-x-origin)))
   ((+gc--tile-stipple-origin-y+) ((int32 tile-stipple-y-origin)))
   ((+gc--font+) ((font font)))
   ((+gc--subwindow-mode+) ((card32 subwindow-mode)))
   ((+gc--graphics-exposures+) ((bool32 graphics-exposures)))
   ((+gc--clip-origin-x+) ((int32 clip-x-origin)))
   ((+gc--clip-origin-y+) ((int32 clip-y-origin)))
   ((+gc--clip-mask+) ((pixmap clip-mask)))
   ((+gc--dash-offset+) ((card32 dash-offset)))
   ((+gc--dash-list+) ((card32 dashes)))
   ((+gc--arc-mode+) ((card32 arc-mode)))))
 ())

(define-request copy-gc 57
 ((pad bytes 1) (gcontext src-gc) (gcontext dst-gc) (card32 value-mask)) ())

(define-request set-dashes 58
 ((pad bytes 1) (gcontext gc) (card16 dash-offset) (card16 dashes-len)
  (list card8 dashes-len dashes))
 ())

(export '+clip-ordering--unsorted+)

(defconstant +clip-ordering--unsorted+ 0)

(export '+clip-ordering--ysorted+)

(defconstant +clip-ordering--ysorted+ 1)

(export '+clip-ordering--yxsorted+)

(defconstant +clip-ordering--yxsorted+ 2)

(export '+clip-ordering--yxbanded+)

(defconstant +clip-ordering--yxbanded+ 3)

(define-request set-clip-rectangles 59
 ((byte ordering) (gcontext gc) (int16 clip-x-origin) (int16 clip-y-origin)
  (list rectangle (length rectangles) rectangles))
 ())

(define-request free-gc 60 ((pad bytes 1) (gcontext gc)) ())

(define-request clear-area 61
 ((bool exposures) (window window) (int16 x) (int16 y) (card16 width)
  (card16 height))
 ())

(define-request copy-area 62
 ((pad bytes 1) (drawable src-drawable) (drawable dst-drawable) (gcontext gc)
  (int16 src-x) (int16 src-y) (int16 dst-x) (int16 dst-y) (card16 width)
  (card16 height))
 ())

(define-request copy-plane 63
 ((pad bytes 1) (drawable src-drawable) (drawable dst-drawable) (gcontext gc)
  (int16 src-x) (int16 src-y) (int16 dst-x) (int16 dst-y) (card16 width)
  (card16 height) (card32 bit-plane))
 ())

(export '+coord-mode--origin+)

(defconstant +coord-mode--origin+ 0)

(export '+coord-mode--previous+)

(defconstant +coord-mode--previous+ 1)

(define-request poly-point 64
 ((byte coordinate-mode) (drawable drawable) (gcontext gc)
  (list point (length points) points))
 ())

(define-request poly-line 65
 ((byte coordinate-mode) (drawable drawable) (gcontext gc)
  (list point (length points) points))
 ())

(define-struct segment ((int16 x1) (int16 y1) (int16 x2) (int16 y2)))

(define-request poly-segment 66
 ((pad bytes 1) (drawable drawable) (gcontext gc)
  (list segment (length segments) segments))
 ())

(define-request poly-rectangle 67
 ((pad bytes 1) (drawable drawable) (gcontext gc)
  (list rectangle (length rectangles) rectangles))
 ())

(define-request poly-arc 68
 ((pad bytes 1) (drawable drawable) (gcontext gc)
  (list arc (length arcs) arcs))
 ())

(export '+poly-shape--complex+)

(defconstant +poly-shape--complex+ 0)

(export '+poly-shape--nonconvex+)

(defconstant +poly-shape--nonconvex+ 1)

(export '+poly-shape--convex+)

(defconstant +poly-shape--convex+ 2)

(define-request fill-poly 69
 ((pad bytes 1) (drawable drawable) (gcontext gc) (card8 shape)
  (card8 coordinate-mode) (pad bytes 2) (list point (length points) points))
 ())

(define-request poly-fill-rectangle 70
 ((pad bytes 1) (drawable drawable) (gcontext gc)
  (list rectangle (length rectangles) rectangles))
 ())

(define-request poly-fill-arc 71
 ((pad bytes 1) (drawable drawable) (gcontext gc)
  (list arc (length arcs) arcs))
 ())

(export '+image-format--xybitmap+)

(defconstant +image-format--xybitmap+ 0)

(export '+image-format--xypixmap+)

(defconstant +image-format--xypixmap+ 1)

(export '+image-format--zpixmap+)

(defconstant +image-format--zpixmap+ 2)

(define-request put-image 72
 ((card8 format) (drawable drawable) (gcontext gc) (card16 width)
  (card16 height) (int16 dst-x) (int16 dst-y) (card8 left-pad) (card8 depth)
  (pad bytes 2) (list byte (length data) data))
 ())

(define-request get-image 73
 ((card8 format) (drawable drawable) (int16 x) (int16 y) (card16 width)
  (card16 height) (card32 plane-mask))
 ((card8 depth) (visualid visual) (pad bytes 20) (list byte (* length 4) data)))

(define-request poly-text8 74
 ((pad bytes 1) (drawable drawable) (gcontext gc) (int16 x) (int16 y)
  (list byte (length items) items))
 ())

(define-request poly-text16 75
 ((pad bytes 1) (drawable drawable) (gcontext gc) (int16 x) (int16 y)
  (list byte (length items) items))
 ())

(define-request image-text8 76
 ((byte string-len) (drawable drawable) (gcontext gc) (int16 x) (int16 y)
  (list char string-len string))
 ())

(define-request image-text16 77
 ((byte string-len) (drawable drawable) (gcontext gc) (int16 x) (int16 y)
  (list char2b string-len string))
 ())

(export '+colormap-alloc--none+)

(defconstant +colormap-alloc--none+ 0)

(export '+colormap-alloc--all+)

(defconstant +colormap-alloc--all+ 1)

(define-request create-colormap 78
 ((byte alloc) (colormap mid) (window window) (visualid visual)) ())

(define-request free-colormap 79 ((pad bytes 1) (colormap cmap)) ())

(define-request copy-colormap-and-free 80
 ((pad bytes 1) (colormap mid) (colormap src-cmap)) ())

(define-request install-colormap 81 ((pad bytes 1) (colormap cmap)) ())

(define-request uninstall-colormap 82 ((pad bytes 1) (colormap cmap)) ())

(define-request list-installed-colormaps 83 ((pad bytes 1) (window window))
 ((pad bytes 1) (card16 cmaps-len) (pad bytes 22)
  (list colormap cmaps-len cmaps)))

(define-request alloc-color 84
 ((pad bytes 1) (colormap cmap) (card16 red) (card16 green) (card16 blue)
  (pad bytes 2))
 ((pad bytes 1) (card16 red) (card16 green) (card16 blue) (pad bytes 2)
  (card32 pixel)))

(define-request alloc-named-color 85
 ((pad bytes 1) (colormap cmap) (card16 name-len) (pad bytes 2)
  (list char name-len name))
 ((pad bytes 1) (card32 pixel) (card16 exact-red) (card16 exact-green)
  (card16 exact-blue) (card16 visual-red) (card16 visual-green)
  (card16 visual-blue)))

(define-request alloc-color-cells 86
 ((bool contiguous) (colormap cmap) (card16 colors) (card16 planes))
 ((pad bytes 1) (card16 pixels-len) (card16 masks-len) (pad bytes 20)
  (list card32 pixels-len pixels) (list card32 masks-len masks)))

(define-request alloc-color-planes 87
 ((bool contiguous) (colormap cmap) (card16 colors) (card16 reds)
  (card16 greens) (card16 blues))
 ((pad bytes 1) (card16 pixels-len) (pad bytes 2) (card32 red-mask)
  (card32 green-mask) (card32 blue-mask) (pad bytes 8)
  (list card32 pixels-len pixels)))

(define-request free-colors 88
 ((pad bytes 1) (colormap cmap) (card32 plane-mask)
  (list card32 (length pixels) pixels))
 ())

(export '+color-flag--red+)

(defconstant +color-flag--red+ 0)

(export '+color-flag--green+)

(defconstant +color-flag--green+ 1)

(export '+color-flag--blue+)

(defconstant +color-flag--blue+ 2)

(define-struct coloritem
 ((card32 pixel) (card16 red) (card16 green) (card16 blue) (byte flags)
  (pad bytes 1)))

(define-request store-colors 89
 ((pad bytes 1) (colormap cmap) (list coloritem (length items) items)) ())

(define-request store-named-color 90
 ((card8 flags) (colormap cmap) (card32 pixel) (card16 name-len) (pad bytes 2)
  (list char name-len name))
 ())

(define-struct rgb ((card16 red) (card16 green) (card16 blue) (pad bytes 2)))

(define-request query-colors 91
 ((pad bytes 1) (colormap cmap) (list card32 (length pixels) pixels))
 ((pad bytes 1) (card16 colors-len) (pad bytes 22)
  (list rgb colors-len colors)))

(define-request lookup-color 92
 ((pad bytes 1) (colormap cmap) (card16 name-len) (pad bytes 2)
  (list char name-len name))
 ((pad bytes 1) (card16 exact-red) (card16 exact-green) (card16 exact-blue)
  (card16 visual-red) (card16 visual-green) (card16 visual-blue)))

(export '+pixmap--none+)

(defconstant +pixmap--none+ 0)

(define-request create-cursor 93
 ((pad bytes 1) (cursor cid) (pixmap source) (pixmap mask) (card16 fore-red)
  (card16 fore-green) (card16 fore-blue) (card16 back-red) (card16 back-green)
  (card16 back-blue) (card16 x) (card16 y))
 ())

(export '+font--none+)

(defconstant +font--none+ 0)

(define-request create-glyph-cursor 94
 ((pad bytes 1) (cursor cid) (font source-font) (font mask-font)
  (card16 source-char) (card16 mask-char) (card16 fore-red) (card16 fore-green)
  (card16 fore-blue) (card16 back-red) (card16 back-green) (card16 back-blue))
 ())

(define-request free-cursor 95 ((pad bytes 1) (cursor cursor)) ())

(define-request recolor-cursor 96
 ((pad bytes 1) (cursor cursor) (card16 fore-red) (card16 fore-green)
  (card16 fore-blue) (card16 back-red) (card16 back-green) (card16 back-blue))
 ())

(export '+query-shape-of--largest-cursor+)

(defconstant +query-shape-of--largest-cursor+ 0)

(export '+query-shape-of--fastest-tile+)

(defconstant +query-shape-of--fastest-tile+ 1)

(export '+query-shape-of--fastest-stipple+)

(defconstant +query-shape-of--fastest-stipple+ 2)

(define-request query-best-size 97
 ((card8 class) (drawable drawable) (card16 width) (card16 height))
 ((pad bytes 1) (card16 width) (card16 height)))

(define-request query-extension 98
 ((pad bytes 1) (card16 name-len) (pad bytes 2) (list char name-len name))
 ((pad bytes 1) (bool present) (card8 major-opcode) (card8 first-event)
  (card8 first-error)))

(define-request list-extensions 99 ()
 ((card8 names-len) (pad bytes 24) (list str names-len names)))

(define-request change-keyboard-mapping 100
 ((card8 keycode-count) (keycode first-keycode) (card8 keysyms-per-keycode)
  (pad bytes 2) (list keysym (* keycode-count keysyms-per-keycode) keysyms))
 ())

(define-request get-keyboard-mapping 101
 ((pad bytes 1) (keycode first-keycode) (card8 count))
 ((byte keysyms-per-keycode) (pad bytes 24) (list keysym length keysyms)))

(export '+kb--key-click-percent+)

(defconstant +kb--key-click-percent+ 0)

(export '+kb--bell-percent+)

(defconstant +kb--bell-percent+ 1)

(export '+kb--bell-pitch+)

(defconstant +kb--bell-pitch+ 2)

(export '+kb--bell-duration+)

(defconstant +kb--bell-duration+ 3)

(export '+kb--led+)

(defconstant +kb--led+ 4)

(export '+kb--led-mode+)

(defconstant +kb--led-mode+ 5)

(export '+kb--key+)

(defconstant +kb--key+ 6)

(export '+kb--auto-repeat-mode+)

(defconstant +kb--auto-repeat-mode+ 7)

(export '+led-mode--off+)

(defconstant +led-mode--off+ 0)

(export '+led-mode--on+)

(defconstant +led-mode--on+ 1)

(export '+auto-repeat-mode--off+)

(defconstant +auto-repeat-mode--off+ 0)

(export '+auto-repeat-mode--on+)

(defconstant +auto-repeat-mode--on+ 1)

(export '+auto-repeat-mode--default+)

(defconstant +auto-repeat-mode--default+ 2)

(define-request change-keyboard-control 102
 ((pad bytes 1) (card32 value-mask)
  (bitcase value-mask ()
   ((+kb--key-click-percent+) ((int32 key-click-percent)))
   ((+kb--bell-percent+) ((int32 bell-percent)))
   ((+kb--bell-pitch+) ((int32 bell-pitch)))
   ((+kb--bell-duration+) ((int32 bell-duration))) ((+kb--led+) ((card32 led)))
   ((+kb--led-mode+) ((card32 led-mode))) ((+kb--key+) ((keycode32 key)))
   ((+kb--auto-repeat-mode+) ((card32 auto-repeat-mode)))))
 ())

(define-request get-keyboard-control 103 ()
 ((byte global-auto-repeat) (card32 led-mask) (card8 key-click-percent)
  (card8 bell-percent) (card16 bell-pitch) (card16 bell-duration) (pad bytes 2)
  (list card8 32 auto-repeats)))

(define-request bell 104 ((int8 percent)) ())

(define-request change-pointer-control 105
 ((pad bytes 1) (int16 acceleration-numerator) (int16 acceleration-denominator)
  (int16 threshold) (bool do-acceleration) (bool do-threshold))
 ())

(define-request get-pointer-control 106 ()
 ((pad bytes 1) (card16 acceleration-numerator)
  (card16 acceleration-denominator) (card16 threshold) (pad bytes 18)))

(export '+blanking--not-preferred+)

(defconstant +blanking--not-preferred+ 0)

(export '+blanking--preferred+)

(defconstant +blanking--preferred+ 1)

(export '+blanking--default+)

(defconstant +blanking--default+ 2)

(export '+exposures--not-allowed+)

(defconstant +exposures--not-allowed+ 0)

(export '+exposures--allowed+)

(defconstant +exposures--allowed+ 1)

(export '+exposures--default+)

(defconstant +exposures--default+ 2)

(define-request set-screen-saver 107
 ((pad bytes 1) (int16 timeout) (int16 interval) (card8 prefer-blanking)
  (card8 allow-exposures))
 ())

(define-request get-screen-saver 108 ()
 ((pad bytes 1) (card16 timeout) (card16 interval) (byte prefer-blanking)
  (byte allow-exposures) (pad bytes 18)))

(export '+host-mode--insert+)

(defconstant +host-mode--insert+ 0)

(export '+host-mode--delete+)

(defconstant +host-mode--delete+ 1)

(export '+family--internet+)

(defconstant +family--internet+ 0)

(export '+family--decnet+)

(defconstant +family--decnet+ 1)

(export '+family--chaos+)

(defconstant +family--chaos+ 2)

(export '+family--server-interpreted+)

(defconstant +family--server-interpreted+ 5)

(export '+family--internet6+)

(defconstant +family--internet6+ 6)

(define-request change-hosts 109
 ((card8 mode) (card8 family) (pad bytes 1) (card16 address-len)
  (list byte address-len address))
 ())

(define-struct host
 ((card8 family) (pad bytes 1) (card16 address-len)
  (list byte address-len address) (pad align 4)))

(define-request list-hosts 110 ()
 ((byte mode) (card16 hosts-len) (pad bytes 22) (list host hosts-len hosts)))

(export '+access-control--disable+)

(defconstant +access-control--disable+ 0)

(export '+access-control--enable+)

(defconstant +access-control--enable+ 1)

(define-request set-access-control 111 ((card8 mode)) ())

(export '+close-down--destroy-all+)

(defconstant +close-down--destroy-all+ 0)

(export '+close-down--retain-permanent+)

(defconstant +close-down--retain-permanent+ 1)

(export '+close-down--retain-temporary+)

(defconstant +close-down--retain-temporary+ 2)

(define-request set-close-down-mode 112 ((card8 mode)) ())

(export '+kill--all-temporary+)

(defconstant +kill--all-temporary+ 0)

(define-request kill-client 113 ((pad bytes 1) (card32 resource)) ())

(define-request rotate-properties 114
 ((pad bytes 1) (window window) (card16 atoms-len) (int16 delta)
  (list atom atoms-len atoms))
 ())

(export '+screen-saver--reset+)

(defconstant +screen-saver--reset+ 0)

(export '+screen-saver--active+)

(defconstant +screen-saver--active+ 1)

(define-request force-screen-saver 115 ((card8 mode)) ())

(export '+mapping-status--success+)

(defconstant +mapping-status--success+ 0)

(export '+mapping-status--busy+)

(defconstant +mapping-status--busy+ 1)

(export '+mapping-status--failure+)

(defconstant +mapping-status--failure+ 2)

(define-request set-pointer-mapping 116
 ((card8 map-len) (list card8 map-len map)) ((byte status)))

(define-request get-pointer-mapping 117 ()
 ((card8 map-len) (pad bytes 24) (list card8 map-len map)))

(export '+map-index--shift+)

(defconstant +map-index--shift+ 0)

(export '+map-index--lock+)

(defconstant +map-index--lock+ 1)

(export '+map-index--control+)

(defconstant +map-index--control+ 2)

(export '+map-index--1+)

(defconstant +map-index--1+ 3)

(export '+map-index--2+)

(defconstant +map-index--2+ 4)

(export '+map-index--3+)

(defconstant +map-index--3+ 5)

(export '+map-index--4+)

(defconstant +map-index--4+ 6)

(export '+map-index--5+)

(defconstant +map-index--5+ 7)

(define-request set-modifier-mapping 118
 ((card8 keycodes-per-modifier)
  (list keycode (* keycodes-per-modifier 8) keycodes))
 ((byte status)))

(define-request get-modifier-mapping 119 ()
 ((card8 keycodes-per-modifier) (pad bytes 24)
  (list keycode (* keycodes-per-modifier 8) keycodes)))

(define-request no-operation 127 () ())

