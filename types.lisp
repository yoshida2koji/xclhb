(in-package :xclhb)

(export '(card8 card16 card32 card64
          int8 int16 int32
          xid fd char byte bool void))

(deftype card8 () '(unsigned-byte 8))
(deftype card16 () '(unsigned-byte 16))
(deftype card32 () '(unsigned-byte 32))
(deftype card64 () '(unsigned-byte 64))
(deftype int8 () '(signed-byte 8))
(deftype int16 () '(signed-byte 16))
(deftype int32 () '(signed-byte 32))
(deftype xid () 'card32)
(deftype fd () 'card32)
(deftype char () 'card8)
(deftype byte () 'card8)
(deftype bool () 'card8)
(deftype void () 'card8)
