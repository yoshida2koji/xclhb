(defsystem "xclhb-shm"
  :version "0.1"
  :author "yoshida koji"
  :license "MIT"
  :depends-on ("xclhb" "cffi" "trivial-garbage")
  :serial t
  :components ((:file "shm")))
