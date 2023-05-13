(cl:in-package :cl-user)

(defpackage :xclhb
  (:use :cl :struct+)
  (:shadow :atom :byte :char :format)
  (:import-from :uiop
   :if-let))

(defpackage :%xclhb
  (:use :xclhb))
