(cl:in-package :cl-user)

(uiop:define-package :xclhb
  (:use :cl :struct+)
  (:shadow :atom :byte :char :format)
  (:import-from :uiop
   :if-let))

