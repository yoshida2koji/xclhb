(in-package :xclhb)

(export '(defglobal defglobals make-mask))

(defmacro defglobal (name value &optional doc)
  #+sbcl
  `(sb-ext:defglobal ,name ,value ,doc)
  #+ccl
  `(ccl:defglobal ,name ,value ,doc)
  #-(or sbcl ccl)
  `(defvar ,name ,value ,doc))

(defmacro defglobals (&rest forms)
  `(progn
     ,@(mapcar (lambda (form) (cons 'defglobal form)) forms)))

(defmacro define-at-compile (name lambda-list &body body)
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     (defun ,name ,lambda-list ,@body)))

(defmacro define-inline (name lambda-list &body body)
  `(progn
     (declaim (inline ,name))
     (defun ,name ,lambda-list ,@body)))

(defun make-mask (&rest positions)
  (let ((mask 0))
    (dolist (pos positions)
      (setf (ldb (cl:byte 1 pos) mask) 1))
    mask))

(defun reexport (symbol package)
  (import symbol package)
  (export symbol package))
