(defsystem "xclhb-shm"
  :version "0.2"
  :author "yoshida koji"
  :license "MIT"
  :depends-on ((:version "xclhb" "0.2")
               "cffi"
               "trivial-garbage")
  :serial t
  :components ((:file "shm")))
