(defsystem "xclhb"
  :version "0.3"
  :author "yoshida koji"
  :license "MIT"
  :depends-on ((:version "struct+" "0.2"))
  :serial t
  :components ((:file "package")
               (:file "misc")
               (:file "types")
               (:file "buffer")
               (:file "client")
               (:file "resource-id")
               (:file "define-macros")
               (:file "xproto")
               (:file "xproto2")
               (:file "process-input")
               (:file "connection")
               (:file "keysym")
               (:file "util")))
