(uiop:define-package :xclhb-glx (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-glx)

(xclhb:defglobal +extension-name+ "GLX")

(export 'pixmap)

(deftype pixmap () 'xclhb:xid)

(export 'context)

(deftype context () 'xclhb:xid)

(export 'pbuffer)

(deftype pbuffer () 'xclhb:xid)

(export 'window)

(deftype window () 'xclhb:xid)

(export 'fbconfig)

(deftype fbconfig () 'xclhb:xid)

(export 'drawable)

(deftype drawable () '(or xclhb:window pbuffer pixmap window))

(export 'float32)

;;(deftype float32 () 'xclhb:float)
(deftype float32 () 'xclhb:card32)

(export 'float64)

;;(deftype float64 () 'xclhb:double)
(deftype float64 () 'xclhb:card64)

(export 'bool32)

(deftype bool32 () 'xclhb:card32)

(export 'context-tag)

(deftype context-tag () 'xclhb:card32)

(xclhb::define-extension-error generic +extension-name+ -1)

(xclhb::define-extension-error bad-context +extension-name+ 0)

(xclhb::define-extension-error bad-context-state +extension-name+ 1)

(xclhb::define-extension-error bad-drawable +extension-name+ 2)

(xclhb::define-extension-error bad-pixmap +extension-name+ 3)

(xclhb::define-extension-error bad-context-tag +extension-name+ 4)

(xclhb::define-extension-error bad-current-window +extension-name+ 5)

(xclhb::define-extension-error bad-render-request +extension-name+ 6)

(xclhb::define-extension-error bad-large-request +extension-name+ 7)

(xclhb::define-extension-error unsupported-private-request +extension-name+ 8)

(xclhb::define-extension-error bad-fbconfig +extension-name+ 9)

(xclhb::define-extension-error bad-pbuffer +extension-name+ 10)

(xclhb::define-extension-error bad-current-drawable +extension-name+ 11)

(xclhb::define-extension-error bad-window +extension-name+ 12)

(xclhb::define-extension-error glxbad-profile-arb +extension-name+ 13)

(xclhb::define-extension-event pbuffer-clobber +extension-name+ 0
 ((pad bytes 1) (xclhb:card16 event-type) (xclhb:card16 draw-type)
  (drawable drawable) (xclhb:card32 b-mask) (xclhb:card16 aux-buffer)
  (xclhb:card16 x) (xclhb:card16 y) (xclhb:card16 width) (xclhb:card16 height)
  (xclhb:card16 count) (pad bytes 4)))

(xclhb::define-extension-event buffer-swap-complete +extension-name+ 1
 ((pad bytes 1) (xclhb:card16 event-type) (pad bytes 2) (drawable drawable)
  (xclhb:card32 ust-hi) (xclhb:card32 ust-lo) (xclhb:card32 msc-hi)
  (xclhb:card32 msc-lo) (xclhb:card32 sbc)))

(export '+pbcet--damaged+)

(defconstant +pbcet--damaged+ 32791)

(export '+pbcet--saved+)

(defconstant +pbcet--saved+ 32792)

(export '+pbcdt--window+)

(defconstant +pbcdt--window+ 32793)

(export '+pbcdt--pbuffer+)

(defconstant +pbcdt--pbuffer+ 32794)

(xclhb::define-extension-request render +extension-name+ 1
 ((context-tag context-tag) (list xclhb:byte (length data) data)) ())

(xclhb::define-extension-request render-large +extension-name+ 2
 ((context-tag context-tag) (xclhb:card16 request-num)
  (xclhb:card16 request-total) (xclhb:card32 data-len)
  (list xclhb:byte data-len data))
 ())

(xclhb::define-extension-request create-context +extension-name+ 3
 ((context context) (xclhb:visualid visual) (xclhb:card32 screen)
  (context share-list) (xclhb:bool is-direct) (pad bytes 3))
 ())

(xclhb::define-extension-request destroy-context +extension-name+ 4
 ((context context)) ())

(xclhb::define-extension-request make-current +extension-name+ 5
 ((drawable drawable) (context context) (context-tag old-context-tag))
 ((pad bytes 1) (context-tag context-tag) (pad bytes 20)))

(xclhb::define-extension-request is-direct +extension-name+ 6
 ((context context)) ((pad bytes 1) (xclhb:bool is-direct) (pad bytes 23)))

(xclhb::define-extension-request query-version +extension-name+ 7
 ((xclhb:card32 major-version) (xclhb:card32 minor-version))
 ((pad bytes 1) (xclhb:card32 major-version) (xclhb:card32 minor-version)
  (pad bytes 16)))

(xclhb::define-extension-request wait-gl +extension-name+ 8
 ((context-tag context-tag)) ())

(xclhb::define-extension-request wait-x +extension-name+ 9
 ((context-tag context-tag)) ())

(xclhb::define-extension-request copy-context +extension-name+ 10
 ((context src) (context dest) (xclhb:card32 mask)
  (context-tag src-context-tag))
 ())

(export '+gc--gl-current-bit+)

(defconstant +gc--gl-current-bit+ 0)

(export '+gc--gl-point-bit+)

(defconstant +gc--gl-point-bit+ 1)

(export '+gc--gl-line-bit+)

(defconstant +gc--gl-line-bit+ 2)

(export '+gc--gl-polygon-bit+)

(defconstant +gc--gl-polygon-bit+ 3)

(export '+gc--gl-polygon-stipple-bit+)

(defconstant +gc--gl-polygon-stipple-bit+ 4)

(export '+gc--gl-pixel-mode-bit+)

(defconstant +gc--gl-pixel-mode-bit+ 5)

(export '+gc--gl-lighting-bit+)

(defconstant +gc--gl-lighting-bit+ 6)

(export '+gc--gl-fog-bit+)

(defconstant +gc--gl-fog-bit+ 7)

(export '+gc--gl-depth-buffer-bit+)

(defconstant +gc--gl-depth-buffer-bit+ 8)

(export '+gc--gl-accum-buffer-bit+)

(defconstant +gc--gl-accum-buffer-bit+ 9)

(export '+gc--gl-stencil-buffer-bit+)

(defconstant +gc--gl-stencil-buffer-bit+ 10)

(export '+gc--gl-viewport-bit+)

(defconstant +gc--gl-viewport-bit+ 11)

(export '+gc--gl-transform-bit+)

(defconstant +gc--gl-transform-bit+ 12)

(export '+gc--gl-enable-bit+)

(defconstant +gc--gl-enable-bit+ 13)

(export '+gc--gl-color-buffer-bit+)

(defconstant +gc--gl-color-buffer-bit+ 14)

(export '+gc--gl-hint-bit+)

(defconstant +gc--gl-hint-bit+ 15)

(export '+gc--gl-eval-bit+)

(defconstant +gc--gl-eval-bit+ 16)

(export '+gc--gl-list-bit+)

(defconstant +gc--gl-list-bit+ 17)

(export '+gc--gl-texture-bit+)

(defconstant +gc--gl-texture-bit+ 18)

(export '+gc--gl-scissor-bit+)

(defconstant +gc--gl-scissor-bit+ 19)

(export '+gc--gl-all-attrib-bits+)

(defconstant +gc--gl-all-attrib-bits+ 16777215)

(xclhb::define-extension-request swap-buffers +extension-name+ 11
 ((context-tag context-tag) (drawable drawable)) ())

(xclhb::define-extension-request use-xfont +extension-name+ 12
 ((context-tag context-tag) (xclhb:font font) (xclhb:card32 first)
  (xclhb:card32 count) (xclhb:card32 list-base))
 ())

(xclhb::define-extension-request create-glxpixmap +extension-name+ 13
 ((xclhb:card32 screen) (xclhb:visualid visual) (xclhb:pixmap pixmap)
  (pixmap glx-pixmap))
 ())

(xclhb::define-extension-request get-visual-configs +extension-name+ 14
 ((xclhb:card32 screen))
 ((pad bytes 1) (xclhb:card32 num-visuals) (xclhb:card32 num-properties)
  (pad bytes 16) (list xclhb:card32 length property-list)))

(xclhb::define-extension-request destroy-glxpixmap +extension-name+ 15
 ((pixmap glx-pixmap)) ())

(xclhb::define-extension-request vendor-private +extension-name+ 16
 ((xclhb:card32 vendor-code) (context-tag context-tag)
  (list xclhb:byte (length data) data))
 ())

(xclhb::define-extension-request vendor-private-with-reply +extension-name+ 17
 ((xclhb:card32 vendor-code) (context-tag context-tag)
  (list xclhb:byte (length data) data))
 ((pad bytes 1) (xclhb:card32 retval) (list xclhb:byte 24 data1)
  (list xclhb:byte (* length 4) data2)))

(xclhb::define-extension-request query-extensions-string +extension-name+ 18
 ((xclhb:card32 screen))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (pad bytes 16)))

(xclhb::define-extension-request query-server-string +extension-name+ 19
 ((xclhb:card32 screen) (xclhb:card32 name))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 str-len) (pad bytes 16)
  (list xclhb:char str-len string)))

(xclhb::define-extension-request client-info +extension-name+ 20
 ((xclhb:card32 major-version) (xclhb:card32 minor-version)
  (xclhb:card32 str-len) (list xclhb:char str-len string))
 ())

(xclhb::define-extension-request get-fbconfigs +extension-name+ 21
 ((xclhb:card32 screen))
 ((pad bytes 1) (xclhb:card32 num-fb-configs) (xclhb:card32 num-properties)
  (pad bytes 16) (list xclhb:card32 length property-list)))

(xclhb::define-extension-request create-pixmap +extension-name+ 22
 ((xclhb:card32 screen) (fbconfig fbconfig) (xclhb:pixmap pixmap)
  (pixmap glx-pixmap) (xclhb:card32 num-attribs)
  (list xclhb:card32 (* num-attribs 2) attribs))
 ())

(xclhb::define-extension-request destroy-pixmap +extension-name+ 23
 ((pixmap glx-pixmap)) ())

(xclhb::define-extension-request create-new-context +extension-name+ 24
 ((context context) (fbconfig fbconfig) (xclhb:card32 screen)
  (xclhb:card32 render-type) (context share-list) (xclhb:bool is-direct)
  (pad bytes 3))
 ())

(xclhb::define-extension-request query-context +extension-name+ 25
 ((context context))
 ((pad bytes 1) (xclhb:card32 num-attribs) (pad bytes 20)
  (list xclhb:card32 (* num-attribs 2) attribs)))

(xclhb::define-extension-request make-context-current +extension-name+ 26
 ((context-tag old-context-tag) (drawable drawable) (drawable read-drawable)
  (context context))
 ((pad bytes 1) (context-tag context-tag) (pad bytes 20)))

(xclhb::define-extension-request create-pbuffer +extension-name+ 27
 ((xclhb:card32 screen) (fbconfig fbconfig) (pbuffer pbuffer)
  (xclhb:card32 num-attribs) (list xclhb:card32 (* num-attribs 2) attribs))
 ())

(xclhb::define-extension-request destroy-pbuffer +extension-name+ 28
 ((pbuffer pbuffer)) ())

(xclhb::define-extension-request get-drawable-attributes +extension-name+ 29
 ((drawable drawable))
 ((pad bytes 1) (xclhb:card32 num-attribs) (pad bytes 20)
  (list xclhb:card32 (* num-attribs 2) attribs)))

(xclhb::define-extension-request change-drawable-attributes +extension-name+ 30
 ((drawable drawable) (xclhb:card32 num-attribs)
  (list xclhb:card32 (* num-attribs 2) attribs))
 ())

(xclhb::define-extension-request create-window +extension-name+ 31
 ((xclhb:card32 screen) (fbconfig fbconfig) (xclhb:window window)
  (window glx-window) (xclhb:card32 num-attribs)
  (list xclhb:card32 (* num-attribs 2) attribs))
 ())

(xclhb::define-extension-request delete-window +extension-name+ 32
 ((window glxwindow)) ())

(xclhb::define-extension-request set-client-info-arb +extension-name+ 33
 ((xclhb:card32 major-version) (xclhb:card32 minor-version)
  (xclhb:card32 num-versions) (xclhb:card32 gl-str-len)
  (xclhb:card32 glx-str-len) (list xclhb:card32 (* num-versions 2) gl-versions)
  (list xclhb:char gl-str-len gl-extension-string)
  (list xclhb:char glx-str-len glx-extension-string))
 ())

(xclhb::define-extension-request create-context-attribs-arb +extension-name+ 34
 ((context context) (fbconfig fbconfig) (xclhb:card32 screen)
  (context share-list) (xclhb:bool is-direct) (pad bytes 3)
  (xclhb:card32 num-attribs) (list xclhb:card32 (* num-attribs 2) attribs))
 ())

(xclhb::define-extension-request set-client-info2arb +extension-name+ 35
 ((xclhb:card32 major-version) (xclhb:card32 minor-version)
  (xclhb:card32 num-versions) (xclhb:card32 gl-str-len)
  (xclhb:card32 glx-str-len) (list xclhb:card32 (* num-versions 3) gl-versions)
  (list xclhb:char gl-str-len gl-extension-string)
  (list xclhb:char glx-str-len glx-extension-string))
 ())

(xclhb::define-extension-request new-list +extension-name+ 101
 ((context-tag context-tag) (xclhb:card32 list) (xclhb:card32 mode)) ())

(xclhb::define-extension-request end-list +extension-name+ 102
 ((context-tag context-tag)) ())

(xclhb::define-extension-request delete-lists +extension-name+ 103
 ((context-tag context-tag) (xclhb:card32 list) (xclhb:int32 range)) ())

(xclhb::define-extension-request gen-lists +extension-name+ 104
 ((context-tag context-tag) (xclhb:int32 range))
 ((pad bytes 1) (xclhb:card32 ret-val)))

(xclhb::define-extension-request feedback-buffer +extension-name+ 105
 ((context-tag context-tag) (xclhb:int32 size) (xclhb:int32 type)) ())

(xclhb::define-extension-request select-buffer +extension-name+ 106
 ((context-tag context-tag) (xclhb:int32 size)) ())

(xclhb::define-extension-request render-mode +extension-name+ 107
 ((context-tag context-tag) (xclhb:card32 mode))
 ((pad bytes 1) (xclhb:card32 ret-val) (xclhb:card32 n) (xclhb:card32 new-mode)
  (pad bytes 12) (list xclhb:card32 n data)))

(export '+rm--gl-render+)

(defconstant +rm--gl-render+ 7168)

(export '+rm--gl-feedback+)

(defconstant +rm--gl-feedback+ 7169)

(export '+rm--gl-select+)

(defconstant +rm--gl-select+ 7170)

(xclhb::define-extension-request finish +extension-name+ 108
 ((context-tag context-tag)) ((pad bytes 1)))

(xclhb::define-extension-request pixel-storef +extension-name+ 109
 ((context-tag context-tag) (xclhb:card32 pname) (float32 datum)) ())

(xclhb::define-extension-request pixel-storei +extension-name+ 110
 ((context-tag context-tag) (xclhb:card32 pname) (xclhb:int32 datum)) ())

(xclhb::define-extension-request read-pixels +extension-name+ 111
 ((context-tag context-tag) (xclhb:int32 x) (xclhb:int32 y) (xclhb:int32 width)
  (xclhb:int32 height) (xclhb:card32 format) (xclhb:card32 type)
  (xclhb:bool swap-bytes) (xclhb:bool lsb-first))
 ((pad bytes 1) (pad bytes 24) (list xclhb:byte (* length 4) data)))

(xclhb::define-extension-request get-booleanv +extension-name+ 112
 ((context-tag context-tag) (xclhb:int32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:bool datum)
  (pad bytes 15) (list xclhb:bool n data)))

(xclhb::define-extension-request get-clip-plane +extension-name+ 113
 ((context-tag context-tag) (xclhb:int32 plane))
 ((pad bytes 1) (pad bytes 24) (list float64 (/ length 2) data)))

(xclhb::define-extension-request get-doublev +extension-name+ 114
 ((context-tag context-tag) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float64 datum) (pad bytes 8)
  (list float64 n data)))

(xclhb::define-extension-request get-error +extension-name+ 115
 ((context-tag context-tag)) ((pad bytes 1) (xclhb:int32 error)))

(xclhb::define-extension-request get-floatv +extension-name+ 116
 ((context-tag context-tag) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-integerv +extension-name+ 117
 ((context-tag context-tag) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-lightfv +extension-name+ 118
 ((context-tag context-tag) (xclhb:card32 light) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-lightiv +extension-name+ 119
 ((context-tag context-tag) (xclhb:card32 light) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-mapdv +extension-name+ 120
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 query))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float64 datum) (pad bytes 8)
  (list float64 n data)))

(xclhb::define-extension-request get-mapfv +extension-name+ 121
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 query))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-mapiv +extension-name+ 122
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 query))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-materialfv +extension-name+ 123
 ((context-tag context-tag) (xclhb:card32 face) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-materialiv +extension-name+ 124
 ((context-tag context-tag) (xclhb:card32 face) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-pixel-mapfv +extension-name+ 125
 ((context-tag context-tag) (xclhb:card32 map))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-pixel-mapuiv +extension-name+ 126
 ((context-tag context-tag) (xclhb:card32 map))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:card32 datum)
  (pad bytes 12) (list xclhb:card32 n data)))

(xclhb::define-extension-request get-pixel-mapusv +extension-name+ 127
 ((context-tag context-tag) (xclhb:card32 map))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:card16 datum)
  (pad bytes 16) (list xclhb:card16 n data)))

(xclhb::define-extension-request get-polygon-stipple +extension-name+ 128
 ((context-tag context-tag) (xclhb:bool lsb-first))
 ((pad bytes 1) (pad bytes 24) (list xclhb:byte (* length 4) data)))

(xclhb::define-extension-request get-string +extension-name+ 129
 ((context-tag context-tag) (xclhb:card32 name))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (pad bytes 16)
  (list xclhb:char n string)))

(xclhb::define-extension-request get-tex-envfv +extension-name+ 130
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-tex-enviv +extension-name+ 131
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-tex-gendv +extension-name+ 132
 ((context-tag context-tag) (xclhb:card32 coord) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float64 datum) (pad bytes 8)
  (list float64 n data)))

(xclhb::define-extension-request get-tex-genfv +extension-name+ 133
 ((context-tag context-tag) (xclhb:card32 coord) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-tex-geniv +extension-name+ 134
 ((context-tag context-tag) (xclhb:card32 coord) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-tex-image +extension-name+ 135
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:int32 level)
  (xclhb:card32 format) (xclhb:card32 type) (xclhb:bool swap-bytes))
 ((pad bytes 1) (pad bytes 8) (xclhb:int32 width) (xclhb:int32 height)
  (xclhb:int32 depth) (pad bytes 4) (list xclhb:byte (* length 4) data)))

(xclhb::define-extension-request get-tex-parameterfv +extension-name+ 136
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-tex-parameteriv +extension-name+ 137
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-tex-level-parameterfv +extension-name+ 138
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:int32 level)
  (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-tex-level-parameteriv +extension-name+ 139
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:int32 level)
  (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request is-enabled +extension-name+ 140
 ((context-tag context-tag) (xclhb:card32 capability))
 ((pad bytes 1) (bool32 ret-val)))

(xclhb::define-extension-request is-list +extension-name+ 141
 ((context-tag context-tag) (xclhb:card32 list))
 ((pad bytes 1) (bool32 ret-val)))

(xclhb::define-extension-request flush +extension-name+ 142
 ((context-tag context-tag)) ())

(xclhb::define-extension-request are-textures-resident +extension-name+ 143
 ((context-tag context-tag) (xclhb:int32 n) (list xclhb:card32 n textures))
 ((pad bytes 1) (bool32 ret-val) (pad bytes 20)
  (list xclhb:bool (* length 4) data)))

(xclhb::define-extension-request delete-textures +extension-name+ 144
 ((context-tag context-tag) (xclhb:int32 n) (list xclhb:card32 n textures)) ())

(xclhb::define-extension-request gen-textures +extension-name+ 145
 ((context-tag context-tag) (xclhb:int32 n))
 ((pad bytes 1) (pad bytes 24) (list xclhb:card32 length data)))

(xclhb::define-extension-request is-texture +extension-name+ 146
 ((context-tag context-tag) (xclhb:card32 texture))
 ((pad bytes 1) (bool32 ret-val)))

(xclhb::define-extension-request get-color-table +extension-name+ 147
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 format)
  (xclhb:card32 type) (xclhb:bool swap-bytes))
 ((pad bytes 1) (pad bytes 8) (xclhb:int32 width) (pad bytes 12)
  (list xclhb:byte (* length 4) data)))

(xclhb::define-extension-request get-color-table-parameterfv +extension-name+
 148 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-color-table-parameteriv +extension-name+
 149 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-convolution-filter +extension-name+ 150
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 format)
  (xclhb:card32 type) (xclhb:bool swap-bytes))
 ((pad bytes 1) (pad bytes 8) (xclhb:int32 width) (xclhb:int32 height)
  (pad bytes 8) (list xclhb:byte (* length 4) data)))

(xclhb::define-extension-request get-convolution-parameterfv +extension-name+
 151 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-convolution-parameteriv +extension-name+
 152 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-separable-filter +extension-name+ 153
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 format)
  (xclhb:card32 type) (xclhb:bool swap-bytes))
 ((pad bytes 1) (pad bytes 8) (xclhb:int32 row-w) (xclhb:int32 col-h)
  (pad bytes 8) (list xclhb:byte (* length 4) rows-and-cols)))

(xclhb::define-extension-request get-histogram +extension-name+ 154
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 format)
  (xclhb:card32 type) (xclhb:bool swap-bytes) (xclhb:bool reset))
 ((pad bytes 1) (pad bytes 8) (xclhb:int32 width) (pad bytes 12)
  (list xclhb:byte (* length 4) data)))

(xclhb::define-extension-request get-histogram-parameterfv +extension-name+ 155
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-histogram-parameteriv +extension-name+ 156
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-minmax +extension-name+ 157
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 format)
  (xclhb:card32 type) (xclhb:bool swap-bytes) (xclhb:bool reset))
 ((pad bytes 1) (pad bytes 24) (list xclhb:byte (* length 4) data)))

(xclhb::define-extension-request get-minmax-parameterfv +extension-name+ 158
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (float32 datum) (pad bytes 12)
  (list float32 n data)))

(xclhb::define-extension-request get-minmax-parameteriv +extension-name+ 159
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-compressed-tex-image-arb +extension-name+
 160 ((context-tag context-tag) (xclhb:card32 target) (xclhb:int32 level))
 ((pad bytes 1) (pad bytes 8) (xclhb:int32 size) (pad bytes 12)
  (list xclhb:byte (* length 4) data)))

(xclhb::define-extension-request delete-queries-arb +extension-name+ 161
 ((context-tag context-tag) (xclhb:int32 n) (list xclhb:card32 n ids)) ())

(xclhb::define-extension-request gen-queries-arb +extension-name+ 162
 ((context-tag context-tag) (xclhb:int32 n))
 ((pad bytes 1) (pad bytes 24) (list xclhb:card32 length data)))

(xclhb::define-extension-request is-query-arb +extension-name+ 163
 ((context-tag context-tag) (xclhb:card32 id)) ((pad bytes 1) (bool32 ret-val)))

(xclhb::define-extension-request get-queryiv-arb +extension-name+ 164
 ((context-tag context-tag) (xclhb:card32 target) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-query-objectiv-arb +extension-name+ 165
 ((context-tag context-tag) (xclhb:card32 id) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:int32 datum)
  (pad bytes 12) (list xclhb:int32 n data)))

(xclhb::define-extension-request get-query-objectuiv-arb +extension-name+ 166
 ((context-tag context-tag) (xclhb:card32 id) (xclhb:card32 pname))
 ((pad bytes 1) (pad bytes 4) (xclhb:card32 n) (xclhb:card32 datum)
  (pad bytes 12) (list xclhb:card32 n data)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+
  (list (list 1 #'read-buffer-swap-complete-event)
   (list 0 #'read-pbuffer-clobber-event)))
 (xclhb::set-extension-error-names client +extension-name+
  (list (list 13 "glxbad-profile-arb") (list 12 "bad-window")
   (list 11 "bad-current-drawable") (list 10 "bad-pbuffer")
   (list 9 "bad-fbconfig") (list 8 "unsupported-private-request")
   (list 7 "bad-large-request") (list 6 "bad-render-request")
   (list 5 "bad-current-window") (list 4 "bad-context-tag")
   (list 3 "bad-pixmap") (list 2 "bad-drawable") (list 1 "bad-context-state")
   (list 0 "bad-context") (list -1 "generic")))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 166 #'read-get-query-objectuiv-arb-reply)
   (list 165 #'read-get-query-objectiv-arb-reply)
   (list 164 #'read-get-queryiv-arb-reply) (list 163 #'read-is-query-arb-reply)
   (list 162 #'read-gen-queries-arb-reply)
   (list 160 #'read-get-compressed-tex-image-arb-reply)
   (list 159 #'read-get-minmax-parameteriv-reply)
   (list 158 #'read-get-minmax-parameterfv-reply)
   (list 157 #'read-get-minmax-reply)
   (list 156 #'read-get-histogram-parameteriv-reply)
   (list 155 #'read-get-histogram-parameterfv-reply)
   (list 154 #'read-get-histogram-reply)
   (list 153 #'read-get-separable-filter-reply)
   (list 152 #'read-get-convolution-parameteriv-reply)
   (list 151 #'read-get-convolution-parameterfv-reply)
   (list 150 #'read-get-convolution-filter-reply)
   (list 149 #'read-get-color-table-parameteriv-reply)
   (list 148 #'read-get-color-table-parameterfv-reply)
   (list 147 #'read-get-color-table-reply) (list 146 #'read-is-texture-reply)
   (list 145 #'read-gen-textures-reply)
   (list 143 #'read-are-textures-resident-reply)
   (list 141 #'read-is-list-reply) (list 140 #'read-is-enabled-reply)
   (list 139 #'read-get-tex-level-parameteriv-reply)
   (list 138 #'read-get-tex-level-parameterfv-reply)
   (list 137 #'read-get-tex-parameteriv-reply)
   (list 136 #'read-get-tex-parameterfv-reply)
   (list 135 #'read-get-tex-image-reply) (list 134 #'read-get-tex-geniv-reply)
   (list 133 #'read-get-tex-genfv-reply) (list 132 #'read-get-tex-gendv-reply)
   (list 131 #'read-get-tex-enviv-reply) (list 130 #'read-get-tex-envfv-reply)
   (list 129 #'read-get-string-reply)
   (list 128 #'read-get-polygon-stipple-reply)
   (list 127 #'read-get-pixel-mapusv-reply)
   (list 126 #'read-get-pixel-mapuiv-reply)
   (list 125 #'read-get-pixel-mapfv-reply)
   (list 124 #'read-get-materialiv-reply)
   (list 123 #'read-get-materialfv-reply) (list 122 #'read-get-mapiv-reply)
   (list 121 #'read-get-mapfv-reply) (list 120 #'read-get-mapdv-reply)
   (list 119 #'read-get-lightiv-reply) (list 118 #'read-get-lightfv-reply)
   (list 117 #'read-get-integerv-reply) (list 116 #'read-get-floatv-reply)
   (list 115 #'read-get-error-reply) (list 114 #'read-get-doublev-reply)
   (list 113 #'read-get-clip-plane-reply) (list 112 #'read-get-booleanv-reply)
   (list 111 #'read-read-pixels-reply) (list 108 #'read-finish-reply)
   (list 107 #'read-render-mode-reply) (list 104 #'read-gen-lists-reply)
   (list 29 #'read-get-drawable-attributes-reply)
   (list 26 #'read-make-context-current-reply)
   (list 25 #'read-query-context-reply) (list 21 #'read-get-fbconfigs-reply)
   (list 19 #'read-query-server-string-reply)
   (list 18 #'read-query-extensions-string-reply)
   (list 17 #'read-vendor-private-with-reply-reply)
   (list 14 #'read-get-visual-configs-reply)
   (list 7 #'read-query-version-reply) (list 6 #'read-is-direct-reply)
   (list 5 #'read-make-current-reply))))

