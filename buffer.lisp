(in-package :xclhb)

(export '(make-offset offset-get offset-set offset-inc make-buffer
          read-card8 read-card16 read-card32 read-card64
          read-int8 read-int16 read-int32
          write-card8 write-card16 write-card32 write-card64
          write-int8 write-int16 write-int32
          string->card8-vector card8-vector->string))

(define-inline make-offset (&optional (init 0))
  (make-array 1 :element-type '(integer 0) :initial-element init))

(define-inline offset-get (offset)
  (aref offset 0))

(define-inline offset-set (offset value)
  (setf (aref offset 0) value))

(define-inline offset-inc (offset delta)
  (incf (aref offset 0) delta))

(define-inline make-buffer (size)
  (make-array size :element-type 'card8 :initial-element 0))

(defun bytes-per-data (format)
  (case format
    (8 1)
    (16 2)
    (32 4)))

(define-inline card8->int8 (x)
  (if (logbitp 7 x)
      (- x #x100)
      x))

(define-inline card16->int16 (x)
  (if (logbitp 15 x)
      (- x #x10000)
      x))

(define-inline card32->int32 (x)
  (if (logbitp 31 x)
      (- x #x100000000)
      x))

(define-inline int8->card8 (x)
  (ldb (cl:byte 8 0) x))

(define-inline int16->card16 (x)
  (ldb (cl:byte 16 0) x))

(define-inline int32->card32 (x)
  (ldb (cl:byte 32 0) x))

(define-inline read-card8 (buffer offset)
  (aref buffer offset))

(define-inline read-card16 (buffer offset)
  (logior (aref buffer offset)
          (ash (aref buffer (+ offset 1)) 8)))

(define-inline read-card32 (buffer offset)
  (logior (aref buffer offset)
          (ash (aref buffer (+ offset 1)) 8)
          (ash (aref buffer (+ offset 2)) 16)
          (ash (aref buffer (+ offset 3)) 24)))

(define-inline read-card64 (buffer offset)
  (logior (aref buffer offset)
          (ash (aref buffer (+ offset 1)) 8)
          (ash (aref buffer (+ offset 2)) 16)
          (ash (aref buffer (+ offset 3)) 24)
          (ash (aref buffer (+ offset 4)) 32)
          (ash (aref buffer (+ offset 5)) 40)
          (ash (aref buffer (+ offset 6)) 48)
          (ash (aref buffer (+ offset 7)) 56)))

(define-inline read-int8 (buffer offset)
  (card8->int8 (read-card8 buffer offset)))

(define-inline read-int16 (buffer offset)
  (card16->int16 (read-card16 buffer offset)))

(define-inline read-int32 (buffer offset)
  (card32->int32 (read-card32 buffer offset)))

(define-inline write-card8 (buffer offset value)
  (setf (aref buffer offset) value))

(define-inline write-card16 (buffer offset value)
  (setf (aref buffer offset) (ldb (cl:byte 8 0) value)
        (aref buffer (+ offset 1)) (ldb (cl:byte 8 8) value)))

(define-inline write-card32 (buffer offset value)
  (setf (aref buffer offset) (ldb (cl:byte 8 0) value)
        (aref buffer (+ offset 1)) (ldb (cl:byte 8 8) value)
        (aref buffer (+ offset 2)) (ldb (cl:byte 8 16) value)
        (aref buffer (+ offset 3)) (ldb (cl:byte 8 24) value)))

(define-inline write-card64 (buffer offset value)
  (setf (aref buffer offset) (ldb (cl:byte 8 0) value)
        (aref buffer (+ offset 1)) (ldb (cl:byte 8 8) value)
        (aref buffer (+ offset 2)) (ldb (cl:byte 8 16) value)
        (aref buffer (+ offset 3)) (ldb (cl:byte 8 24) value)
        (aref buffer (+ offset 4)) (ldb (cl:byte 8 32) value)
        (aref buffer (+ offset 5)) (ldb (cl:byte 8 40) value)
        (aref buffer (+ offset 6)) (ldb (cl:byte 8 48) value)
        (aref buffer (+ offset 7)) (ldb (cl:byte 8 56) value)))

(define-inline write-int8 (buffer offset value)
  (write-card8 buffer offset (int8->card8 value)))

(define-inline write-int16 (buffer offset value)
  (write-card16 buffer offset (int16->card16 value)))

(define-inline write-int32 (buffer offset value)
  (write-card32 buffer offset (int32->card32 value)))

(defun read-string8 (buffer offset size)
  (let ((string (make-string size)))
    (dotimes (i size)
      (setf (aref string i) (code-char (aref buffer (+ offset i)))))
    string))

(defun string->card8-vector (string)
  (map 'vector #'char-code string))

(defun card8-vector->string (vec)
  (coerce (map 'vector #'code-char vec) 'string))


(defun write-string8 (buffer offset string)
  (dotimes (i (length string))
    (setf (aref buffer (+ offset i)) (aref string i))))

(defun read-list-of-data (buffer offset size bytes-per-data)
  (let ((read-fn (case bytes-per-data
                   (1 #'read-card8)
                   (2 #'read-card16)
                   (4 #'read-card32)))
        (vec (make-array size)))
    (loop :for i :from 0 :below size
          :for j :from offset :by bytes-per-data
          :do (setf (aref vec i) (funcall read-fn buffer j)))
    vec))

(defun write-list-of-data (buffer offset data bytes-per-data)
  (let ((write-fn (case bytes-per-data
                    (1 #'write-card8)
                    (2 #'write-card16)
                    (4 #'write-card32))))
    (loop :for e :across data
          :for i :from offset :by bytes-per-data
          :do (funcall write-fn buffer i e))))

(defun align-pad-length (e)
  (mod (- 4 (mod e 4)) 4))


(defun aligned-length (len)
  (+ (align-pad-length len) len))

(defun find-form (type format)
  (flet ((find-form-fn (package)
           (find-symbol (cl:format nil format type) package)))
    (let ((sym (find-form-fn *package*)))
      (or
          sym
          (some #'find-form-fn
                '(:xclhb
                  :xclhb-render
                  :xclhb-shape
                  :xclhb-xfixes
                  :xclhb-randr
                  :xclhb-sync
                  :xclhb-shm
                  :xclhb-xv
                  ))))))

(defun reader-of (type)
  (cond ((subtypep type 'card8) 'read-card8)
        ((subtypep type 'int8) 'read-int8)
        ((subtypep type 'card16) 'read-card16)
        ((subtypep type 'int16) 'read-int16)
        ((subtypep type 'card32) 'read-card32)
        ((subtypep type 'int32) 'read-int32)
        ((subtypep type 'card64) 'read-card64)
        ;;(t (intern-name type "read-~a"))
        (t (find-form type "~:@(read-~a~)"))))

(defun writer-of (type)
  (cond ((subtypep type 'card8) 'write-card8)
        ((subtypep type 'int8) 'write-int8)
        ((subtypep type 'card16) 'write-card16)
        ((subtypep type 'int16) 'write-int16)
        ((subtypep type 'card32) 'write-card32)
        ((subtypep type 'int32) 'write-int32)
        ((subtypep type 'card64) 'write-card64)
        ;;(t (intern-name type "write-~a"))
        (t (find-form type "~:@(write-~a~)"))))

(defun size-of (type)
  (cond ((subtypep type 'card8) 1)
        ((subtypep type 'int8) 1)
        ((subtypep type 'card16) 2)
        ((subtypep type 'int16) 2)
        ((subtypep type 'card32) 4)
        ((subtypep type 'int32) 4)
        ((subtypep type 'card64) 8)
        ;;(t (funcall (intern-name type "~a-length-form")))
        (t (funcall (find-form type "~:@(~a-length-form~)")))))
