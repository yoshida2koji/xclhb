(uiop:define-package :xclhb-render (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-render)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "RENDER")

(export '+pict-type--indexed+)

(defconstant +pict-type--indexed+ 0)

(export '+pict-type--direct+)

(defconstant +pict-type--direct+ 1)

(export '+picture--none+)

(defconstant +picture--none+ 0)

(export '+pict-op--clear+)

(defconstant +pict-op--clear+ 0)

(export '+pict-op--src+)

(defconstant +pict-op--src+ 1)

(export '+pict-op--dst+)

(defconstant +pict-op--dst+ 2)

(export '+pict-op--over+)

(defconstant +pict-op--over+ 3)

(export '+pict-op--over-reverse+)

(defconstant +pict-op--over-reverse+ 4)

(export '+pict-op--in+)

(defconstant +pict-op--in+ 5)

(export '+pict-op--in-reverse+)

(defconstant +pict-op--in-reverse+ 6)

(export '+pict-op--out+)

(defconstant +pict-op--out+ 7)

(export '+pict-op--out-reverse+)

(defconstant +pict-op--out-reverse+ 8)

(export '+pict-op--atop+)

(defconstant +pict-op--atop+ 9)

(export '+pict-op--atop-reverse+)

(defconstant +pict-op--atop-reverse+ 10)

(export '+pict-op--xor+)

(defconstant +pict-op--xor+ 11)

(export '+pict-op--add+)

(defconstant +pict-op--add+ 12)

(export '+pict-op--saturate+)

(defconstant +pict-op--saturate+ 13)

(export '+pict-op--disjoint-clear+)

(defconstant +pict-op--disjoint-clear+ 16)

(export '+pict-op--disjoint-src+)

(defconstant +pict-op--disjoint-src+ 17)

(export '+pict-op--disjoint-dst+)

(defconstant +pict-op--disjoint-dst+ 18)

(export '+pict-op--disjoint-over+)

(defconstant +pict-op--disjoint-over+ 19)

(export '+pict-op--disjoint-over-reverse+)

(defconstant +pict-op--disjoint-over-reverse+ 20)

(export '+pict-op--disjoint-in+)

(defconstant +pict-op--disjoint-in+ 21)

(export '+pict-op--disjoint-in-reverse+)

(defconstant +pict-op--disjoint-in-reverse+ 22)

(export '+pict-op--disjoint-out+)

(defconstant +pict-op--disjoint-out+ 23)

(export '+pict-op--disjoint-out-reverse+)

(defconstant +pict-op--disjoint-out-reverse+ 24)

(export '+pict-op--disjoint-atop+)

(defconstant +pict-op--disjoint-atop+ 25)

(export '+pict-op--disjoint-atop-reverse+)

(defconstant +pict-op--disjoint-atop-reverse+ 26)

(export '+pict-op--disjoint-xor+)

(defconstant +pict-op--disjoint-xor+ 27)

(export '+pict-op--conjoint-clear+)

(defconstant +pict-op--conjoint-clear+ 32)

(export '+pict-op--conjoint-src+)

(defconstant +pict-op--conjoint-src+ 33)

(export '+pict-op--conjoint-dst+)

(defconstant +pict-op--conjoint-dst+ 34)

(export '+pict-op--conjoint-over+)

(defconstant +pict-op--conjoint-over+ 35)

(export '+pict-op--conjoint-over-reverse+)

(defconstant +pict-op--conjoint-over-reverse+ 36)

(export '+pict-op--conjoint-in+)

(defconstant +pict-op--conjoint-in+ 37)

(export '+pict-op--conjoint-in-reverse+)

(defconstant +pict-op--conjoint-in-reverse+ 38)

(export '+pict-op--conjoint-out+)

(defconstant +pict-op--conjoint-out+ 39)

(export '+pict-op--conjoint-out-reverse+)

(defconstant +pict-op--conjoint-out-reverse+ 40)

(export '+pict-op--conjoint-atop+)

(defconstant +pict-op--conjoint-atop+ 41)

(export '+pict-op--conjoint-atop-reverse+)

(defconstant +pict-op--conjoint-atop-reverse+ 42)

(export '+pict-op--conjoint-xor+)

(defconstant +pict-op--conjoint-xor+ 43)

(export '+pict-op--multiply+)

(defconstant +pict-op--multiply+ 48)

(export '+pict-op--screen+)

(defconstant +pict-op--screen+ 49)

(export '+pict-op--overlay+)

(defconstant +pict-op--overlay+ 50)

(export '+pict-op--darken+)

(defconstant +pict-op--darken+ 51)

(export '+pict-op--lighten+)

(defconstant +pict-op--lighten+ 52)

(export '+pict-op--color-dodge+)

(defconstant +pict-op--color-dodge+ 53)

(export '+pict-op--color-burn+)

(defconstant +pict-op--color-burn+ 54)

(export '+pict-op--hard-light+)

(defconstant +pict-op--hard-light+ 55)

(export '+pict-op--soft-light+)

(defconstant +pict-op--soft-light+ 56)

(export '+pict-op--difference+)

(defconstant +pict-op--difference+ 57)

(export '+pict-op--exclusion+)

(defconstant +pict-op--exclusion+ 58)

(export '+pict-op--hslhue+)

(defconstant +pict-op--hslhue+ 59)

(export '+pict-op--hslsaturation+)

(defconstant +pict-op--hslsaturation+ 60)

(export '+pict-op--hslcolor+)

(defconstant +pict-op--hslcolor+ 61)

(export '+pict-op--hslluminosity+)

(defconstant +pict-op--hslluminosity+ 62)

(export '+poly-edge--sharp+)

(defconstant +poly-edge--sharp+ 0)

(export '+poly-edge--smooth+)

(defconstant +poly-edge--smooth+ 1)

(export '+poly-mode--precise+)

(defconstant +poly-mode--precise+ 0)

(export '+poly-mode--imprecise+)

(defconstant +poly-mode--imprecise+ 1)

(export '+cp--repeat+)

(defconstant +cp--repeat+ 0)

(export '+cp--alpha-map+)

(defconstant +cp--alpha-map+ 1)

(export '+cp--alpha-xorigin+)

(defconstant +cp--alpha-xorigin+ 2)

(export '+cp--alpha-yorigin+)

(defconstant +cp--alpha-yorigin+ 3)

(export '+cp--clip-xorigin+)

(defconstant +cp--clip-xorigin+ 4)

(export '+cp--clip-yorigin+)

(defconstant +cp--clip-yorigin+ 5)

(export '+cp--clip-mask+)

(defconstant +cp--clip-mask+ 6)

(export '+cp--graphics-exposure+)

(defconstant +cp--graphics-exposure+ 7)

(export '+cp--subwindow-mode+)

(defconstant +cp--subwindow-mode+ 8)

(export '+cp--poly-edge+)

(defconstant +cp--poly-edge+ 9)

(export '+cp--poly-mode+)

(defconstant +cp--poly-mode+ 10)

(export '+cp--dither+)

(defconstant +cp--dither+ 11)

(export '+cp--component-alpha+)

(defconstant +cp--component-alpha+ 12)

(export '+sub-pixel--unknown+)

(defconstant +sub-pixel--unknown+ 0)

(export '+sub-pixel--horizontal-rgb+)

(defconstant +sub-pixel--horizontal-rgb+ 1)

(export '+sub-pixel--horizontal-bgr+)

(defconstant +sub-pixel--horizontal-bgr+ 2)

(export '+sub-pixel--vertical-rgb+)

(defconstant +sub-pixel--vertical-rgb+ 3)

(export '+sub-pixel--vertical-bgr+)

(defconstant +sub-pixel--vertical-bgr+ 4)

(export '+sub-pixel--none+)

(defconstant +sub-pixel--none+ 5)

(export '+repeat--none+)

(defconstant +repeat--none+ 0)

(export '+repeat--normal+)

(defconstant +repeat--normal+ 1)

(export '+repeat--pad+)

(defconstant +repeat--pad+ 2)

(export '+repeat--reflect+)

(defconstant +repeat--reflect+ 3)

(export 'glyph)

(deftype glyph () 'xclhb:card32)

(export 'glyphset)

(deftype glyphset () 'xclhb:xid)

(export 'picture)

(deftype picture () 'xclhb:xid)

(export 'pictformat)

(deftype pictformat () 'xclhb:xid)

(export 'fixed)

(deftype fixed () 'xclhb:int32)

(xclhb::define-extension-error pict-format +extension-name+ 0)

(xclhb::define-extension-error picture +extension-name+ 1)

(xclhb::define-extension-error pict-op +extension-name+ 2)

(xclhb::define-extension-error glyph-set +extension-name+ 3)

(xclhb::define-extension-error glyph +extension-name+ 4)

(xclhb::define-struct directformat
 ((xclhb:card16 red-shift) (xclhb:card16 red-mask) (xclhb:card16 green-shift)
  (xclhb:card16 green-mask) (xclhb:card16 blue-shift) (xclhb:card16 blue-mask)
  (xclhb:card16 alpha-shift) (xclhb:card16 alpha-mask)))

(xclhb::define-struct pictforminfo
 ((pictformat id) (xclhb:card8 type) (xclhb:card8 depth) (pad bytes 2)
  (directformat direct) (xclhb:colormap colormap)))

(xclhb::define-struct pictvisual ((xclhb:visualid visual) (pictformat format)))

(xclhb::define-struct pictdepth
 ((xclhb:card8 depth) (pad bytes 1) (xclhb:card16 num-visuals) (pad bytes 4)
  (list pictvisual num-visuals visuals)))

(xclhb::define-struct pictscreen
 ((xclhb:card32 num-depths) (pictformat fallback)
  (list pictdepth num-depths depths)))

(xclhb::define-struct indexvalue
 ((xclhb:card32 pixel) (xclhb:card16 red) (xclhb:card16 green)
  (xclhb:card16 blue) (xclhb:card16 alpha)))

(xclhb::define-struct color
 ((xclhb:card16 red) (xclhb:card16 green) (xclhb:card16 blue)
  (xclhb:card16 alpha)))

(xclhb::define-struct pointfix ((fixed x) (fixed y)))

(xclhb::define-struct linefix ((pointfix p1) (pointfix p2)))

(xclhb::define-struct triangle ((pointfix p1) (pointfix p2) (pointfix p3)))

(xclhb::define-struct trapezoid
 ((fixed top) (fixed bottom) (linefix left) (linefix right)))

(xclhb::define-struct glyphinfo
 ((xclhb:card16 width) (xclhb:card16 height) (xclhb:int16 x) (xclhb:int16 y)
  (xclhb:int16 x-off) (xclhb:int16 y-off)))

(xclhb::define-extension-request query-version +extension-name+ 0
 ((xclhb:card32 client-major-version) (xclhb:card32 client-minor-version))
 ((pad bytes 1) (xclhb:card32 major-version) (xclhb:card32 minor-version)
  (pad bytes 16)))

(xclhb::define-extension-request query-pict-formats +extension-name+ 1 ()
 ((pad bytes 1) (xclhb:card32 num-formats) (xclhb:card32 num-screens)
  (xclhb:card32 num-depths) (xclhb:card32 num-visuals)
  (xclhb:card32 num-subpixel) (pad bytes 4)
  (list pictforminfo num-formats formats) (list pictscreen num-screens screens)
  (list xclhb:card32 num-subpixel subpixels)))

(xclhb::define-extension-request query-pict-index-values +extension-name+ 2
 ((pictformat format))
 ((pad bytes 1) (xclhb:card32 num-values) (pad bytes 20)
  (list indexvalue num-values values)))

(xclhb::define-extension-request create-picture +extension-name+ 4
 ((picture pid) (xclhb:drawable drawable) (pictformat format)
  (xclhb:card32 value-mask)
  (bitcase value-mask () ((+cp--repeat+) ((xclhb:card32 repeat)))
   ((+cp--alpha-map+) ((picture alphamap)))
   ((+cp--alpha-xorigin+) ((xclhb:int32 alphaxorigin)))
   ((+cp--alpha-yorigin+) ((xclhb:int32 alphayorigin)))
   ((+cp--clip-xorigin+) ((xclhb:int32 clipxorigin)))
   ((+cp--clip-yorigin+) ((xclhb:int32 clipyorigin)))
   ((+cp--clip-mask+) ((xclhb:pixmap clipmask)))
   ((+cp--graphics-exposure+) ((xclhb:card32 graphicsexposure)))
   ((+cp--subwindow-mode+) ((xclhb:card32 subwindowmode)))
   ((+cp--poly-edge+) ((xclhb:card32 polyedge)))
   ((+cp--poly-mode+) ((xclhb:card32 polymode)))
   ((+cp--dither+) ((xclhb:atom dither)))
   ((+cp--component-alpha+) ((xclhb:card32 componentalpha)))))
 ())

(xclhb::define-extension-request change-picture +extension-name+ 5
 ((picture picture) (xclhb:card32 value-mask)
  (bitcase value-mask () ((+cp--repeat+) ((xclhb:card32 repeat)))
   ((+cp--alpha-map+) ((picture alphamap)))
   ((+cp--alpha-xorigin+) ((xclhb:int32 alphaxorigin)))
   ((+cp--alpha-yorigin+) ((xclhb:int32 alphayorigin)))
   ((+cp--clip-xorigin+) ((xclhb:int32 clipxorigin)))
   ((+cp--clip-yorigin+) ((xclhb:int32 clipyorigin)))
   ((+cp--clip-mask+) ((xclhb:pixmap clipmask)))
   ((+cp--graphics-exposure+) ((xclhb:card32 graphicsexposure)))
   ((+cp--subwindow-mode+) ((xclhb:card32 subwindowmode)))
   ((+cp--poly-edge+) ((xclhb:card32 polyedge)))
   ((+cp--poly-mode+) ((xclhb:card32 polymode)))
   ((+cp--dither+) ((xclhb:atom dither)))
   ((+cp--component-alpha+) ((xclhb:card32 componentalpha)))))
 ())

(xclhb::define-extension-request set-picture-clip-rectangles +extension-name+ 6
 ((picture picture) (xclhb:int16 clip-x-origin) (xclhb:int16 clip-y-origin)
  (list xclhb:rectangle (length rectangles) rectangles))
 ())

(xclhb::define-extension-request free-picture +extension-name+ 7
 ((picture picture)) ())

(xclhb::define-extension-request composite +extension-name+ 8
 ((xclhb:card8 op) (pad bytes 3) (picture src) (picture mask) (picture dst)
  (xclhb:int16 src-x) (xclhb:int16 src-y) (xclhb:int16 mask-x)
  (xclhb:int16 mask-y) (xclhb:int16 dst-x) (xclhb:int16 dst-y)
  (xclhb:card16 width) (xclhb:card16 height))
 ())

(xclhb::define-extension-request trapezoids +extension-name+ 10
 ((xclhb:card8 op) (pad bytes 3) (picture src) (picture dst)
  (pictformat mask-format) (xclhb:int16 src-x) (xclhb:int16 src-y)
  (list trapezoid (length traps) traps))
 ())

(xclhb::define-extension-request triangles +extension-name+ 11
 ((xclhb:card8 op) (pad bytes 3) (picture src) (picture dst)
  (pictformat mask-format) (xclhb:int16 src-x) (xclhb:int16 src-y)
  (list triangle (length triangles) triangles))
 ())

(xclhb::define-extension-request tri-strip +extension-name+ 12
 ((xclhb:card8 op) (pad bytes 3) (picture src) (picture dst)
  (pictformat mask-format) (xclhb:int16 src-x) (xclhb:int16 src-y)
  (list pointfix (length points) points))
 ())

(xclhb::define-extension-request tri-fan +extension-name+ 13
 ((xclhb:card8 op) (pad bytes 3) (picture src) (picture dst)
  (pictformat mask-format) (xclhb:int16 src-x) (xclhb:int16 src-y)
  (list pointfix (length points) points))
 ())

(xclhb::define-extension-request create-glyph-set +extension-name+ 17
 ((glyphset gsid) (pictformat format)) ())

(xclhb::define-extension-request reference-glyph-set +extension-name+ 18
 ((glyphset gsid) (glyphset existing)) ())

(xclhb::define-extension-request free-glyph-set +extension-name+ 19
 ((glyphset glyphset)) ())

(xclhb::define-extension-request add-glyphs +extension-name+ 20
 ((glyphset glyphset) (xclhb:card32 glyphs-len)
  (list xclhb:card32 glyphs-len glyphids) (list glyphinfo glyphs-len glyphs)
  (list xclhb:byte (length data) data))
 ())

(xclhb::define-extension-request free-glyphs +extension-name+ 22
 ((glyphset glyphset) (list glyph (length glyphs) glyphs)) ())

(xclhb::define-extension-request composite-glyphs8 +extension-name+ 23
 ((xclhb:card8 op) (pad bytes 3) (picture src) (picture dst)
  (pictformat mask-format) (glyphset glyphset) (xclhb:int16 src-x)
  (xclhb:int16 src-y) (list xclhb:byte (length glyphcmds) glyphcmds))
 ())

(xclhb::define-extension-request composite-glyphs16 +extension-name+ 24
 ((xclhb:card8 op) (pad bytes 3) (picture src) (picture dst)
  (pictformat mask-format) (glyphset glyphset) (xclhb:int16 src-x)
  (xclhb:int16 src-y) (list xclhb:byte (length glyphcmds) glyphcmds))
 ())

(xclhb::define-extension-request composite-glyphs32 +extension-name+ 25
 ((xclhb:card8 op) (pad bytes 3) (picture src) (picture dst)
  (pictformat mask-format) (glyphset glyphset) (xclhb:int16 src-x)
  (xclhb:int16 src-y) (list xclhb:byte (length glyphcmds) glyphcmds))
 ())

(xclhb::define-extension-request fill-rectangles +extension-name+ 26
 ((xclhb:card8 op) (pad bytes 3) (picture dst) (color color)
  (list xclhb:rectangle (length rects) rects))
 ())

(xclhb::define-extension-request create-cursor +extension-name+ 27
 ((xclhb:cursor cid) (picture source) (xclhb:card16 x) (xclhb:card16 y)) ())

(xclhb::define-struct transform
 ((fixed matrix11) (fixed matrix12) (fixed matrix13) (fixed matrix21)
  (fixed matrix22) (fixed matrix23) (fixed matrix31) (fixed matrix32)
  (fixed matrix33)))

(xclhb::define-extension-request set-picture-transform +extension-name+ 28
 ((picture picture) (transform transform)) ())

(xclhb::define-extension-request query-filters +extension-name+ 29
 ((xclhb:drawable drawable))
 ((pad bytes 1) (xclhb:card32 num-aliases) (xclhb:card32 num-filters)
  (pad bytes 16) (list xclhb:card16 num-aliases aliases)
  (list xclhb:str num-filters filters)))

(xclhb::define-extension-request set-picture-filter +extension-name+ 30
 ((picture picture) (xclhb:card16 filter-len) (pad bytes 2)
  (list xclhb:char filter-len filter) (pad align 4)
  (list fixed (length values) values))
 ())

(xclhb::define-struct animcursorelt
 ((xclhb:cursor cursor) (xclhb:card32 delay)))

(xclhb::define-extension-request create-anim-cursor +extension-name+ 31
 ((xclhb:cursor cid) (list animcursorelt (length cursors) cursors)) ())

(xclhb::define-struct spanfix ((fixed l) (fixed r) (fixed y)))

(xclhb::define-struct trap ((spanfix top) (spanfix bot)))

(xclhb::define-extension-request add-traps +extension-name+ 32
 ((picture picture) (xclhb:int16 x-off) (xclhb:int16 y-off)
  (list trap (length traps) traps))
 ())

(xclhb::define-extension-request create-solid-fill +extension-name+ 33
 ((picture picture) (color color)) ())

(xclhb::define-extension-request create-linear-gradient +extension-name+ 34
 ((picture picture) (pointfix p1) (pointfix p2) (xclhb:card32 num-stops)
  (list fixed num-stops stops) (list color num-stops colors))
 ())

(xclhb::define-extension-request create-radial-gradient +extension-name+ 35
 ((picture picture) (pointfix inner) (pointfix outer) (fixed inner-radius)
  (fixed outer-radius) (xclhb:card32 num-stops) (list fixed num-stops stops)
  (list color num-stops colors))
 ())

(xclhb::define-extension-request create-conical-gradient +extension-name+ 36
 ((picture picture) (pointfix center) (fixed angle) (xclhb:card32 num-stops)
  (list fixed num-stops stops) (list color num-stops colors))
 ())

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+ (list))
 (xclhb::set-extension-error-names client +extension-name+
  (list (list 4 "glyph") (list 3 "glyph-set") (list 2 "pict-op")
   (list 1 "picture") (list 0 "pict-format")))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 29 #'read-query-filters-reply)
   (list 2 #'read-query-pict-index-values-reply)
   (list 1 #'read-query-pict-formats-reply)
   (list 0 #'read-query-version-reply))))

