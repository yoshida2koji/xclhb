;; from
(uiop:define-package :xclhb-xv (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

;; to
(uiop:define-package :xclhb-xv (:use :cl)
                     (:import-from :xclhb :pad :bytes :align :bitcase)
                     (:shadow :rational :format))
