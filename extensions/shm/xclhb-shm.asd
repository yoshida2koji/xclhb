(defsystem "xclhb-shm"
  :version "0.1"
  :author "yoshida koji"
  :license "MIT"
  :depends-on ("xclhb" "cffi" "trivial-garbage")
  :components ((:file "shm")
               (:file "segment")))

