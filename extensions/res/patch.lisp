;; from
(uiop:define-package :xclhb-res (:use :cl)
                     (:import-from :xclhb :pad :bytes :align :bitcase))

;; to
(uiop:define-package :xclhb-res (:use :cl)
                     (:import-from :xclhb :pad :bytes :align :bitcase)
                     (:shadow :type))
