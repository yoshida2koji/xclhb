;; change this form
(uiop:define-package :xclhb-dri3 (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

;; to
(uiop:define-package :xclhb-dri3 (:use :cl)
                     (:import-from :xclhb :pad :bytes :align :bitcase)
                     (:shadow :open))
