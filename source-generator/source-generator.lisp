(defpackage :xclhb-source-generator
  (:use :cl :arrow-macros)
  (:export :generate))

(in-package :xclhb-source-generator)

(cl-punch:enable-punch-syntax)

(defparameter *extension-source-file-names*
  '("bigreq.xml" "composite.xml" "damage.xml" "dpms.xml" "dri2.xml" "dri3.xml" "ge.xml" "glx.xml"
    "present.xml" "randr.xml" "record.xml" "render.xml" "res.xml" "screensaver.xml"
    "shape.xml" "shm.xml" "sync.xml" "xc_misc.xml" "xevie.xml"
    "xf86dri.xml" "xf86vidmode.xml" "xfixes.xml" "xinerama.xml" "xinput.xml" "xkb.xml"
    "xprint.xml" "xselinux.xml" "xtest.xml" "xv.xml" "xvmc.xml"))

(defvar *stdout* *standard-output* )

(defvar *event-fields-map* nil)

(defvar *extension-p* nil)

(defvar *extension-name* nil)

(defvar *extension-event-readers* nil)

(defvar *extension-error-names* nil)

(defvar *extension-reply-readers* nil)

(defun assoc-value (name list)
  (second (assoc name list :test #'equal)))

(defun node-attr-value (node attr-name)
  (assoc-value attr-name (xmls:node-attrs node)))

(defun to-lisp-name (name)
  (with-output-to-string (s)
    (loop :for pre-c := nil :then c
          :for c :across (etypecase name
                           (string name)
                           (symbol (symbol-name name)))
          :do (cond ((upper-case-p c)
                     (when (and pre-c (lower-case-p pre-c))
                       (write-char #\- s))
                     (write-char (char-downcase c) s))
                    ((char= #\_ c)
                     (write-char #\- s))
                    (t
                     (write-char c s))))))

(defun intern-string (fmt &rest strs)
  (let* ((value (string-upcase (apply #'format nil fmt (mapcar #'to-lisp-name strs))))
         (colon-pos (position #\: value)))
    (intern (if colon-pos
                (subseq value (+ colon-pos 1))
                value))))

(defun intern-node-attr (node attr-name)
  (intern-string "~a" (node-attr-value node attr-name)))


(defun node-content (node)
  (car (xmls:node-children node)))

(defun intern-node-content (node)
  (intern-string "~a" (node-content node)))

(defun write-form (form &optional (out *standard-output*))
  (format out "~s" form)
  (terpri out)
  (terpri out))

(defun write-xidtype (node)
  (write-form
   (let ((name (intern-node-attr node "name")))
     `(progn
        (export ',name)
        (deftype ,name () 'xid)))))

(defun write-xidunion (node)
  (write-form
   (let ((name (intern-node-attr node "name")))
     `(progn
        (export ',name)
        (deftype ,name ()
          '(or ,@(mapcar #'intern-node-content (xmls:node-children node))))))))

(defun write-typedef (node)
  (write-form
   (let ((name (intern-node-attr node "newname")))
     `(progn
        (export ',name)
        (deftype ,name ()
          ',(intern-node-attr node "oldname"))))))

;; (defun make-list-length-form (node)
;;   (if (null node)
;;       nil
;;       (str:string-case (xmls:node-name node)
;;         ("value" (parse-integer (car (xmls:node-children node))))
;;         ("fieldref" (intern-node-content node))
;;         ("op" (destructuring-bind (a b) (xmls:node-children node)
;;                 (list (intern-node-attr node "op")
;;                       (make-list-length-form a)
;;                       (make-list-length-form b)))))))

(defun list-node (node)
  `(list ,(intern-node-attr node "type")
         ,(node->field (car (xmls:node-children node)))
         ,(intern-node-attr node "name")))

(defun field-node (node)
  `(,(intern-node-attr node "type") ,(intern-node-attr node "name")))

(defun pad-node (node)
  (destructuring-bind (name value) (car (xmls:node-attrs node))
    `(pad ,(intern-string "~a" name) ,(parse-integer value))))

(defun %write-event (name number fields)
  (write-form
   (cond (*extension-p*
          (push (list 'list number `#',(intern-string "read-~a" name)) *extension-event-readers*)
          `(define-extension-event ,name ,*extension-name* ,number ,fields))
         (t
          `(define-event ,name ,number ,fields)))))

(defun write-event (node)
  (let ((name (intern-string "~a" (node-attr-value node "name")))
        (fields (remove nil
                        (mapcar (lambda (node)
                                  (str:string-case (xmls:node-name node)
                                    ("list" (list-node node))
                                    ("field" (field-node node))
                                    ("pad" (pad-node node))
                                    ("doc" ())))
                                (xmls:node-children node))))
        (number (parse-integer (node-attr-value node "number"))))
    (push (cons name fields) *event-fields-map*)
    (%write-event name number fields)))


(defun write-eventcopy (node)
  (let* ((name (intern-string "~a" (node-attr-value node "name")))
         (ref (intern-string "~a" (node-attr-value node "ref")))
         (fields (cdr (assoc ref *event-fields-map*)))
         (number (parse-integer (node-attr-value node "number"))))
    (%write-event name number fields)))

(defun intern-enum-constant (enum-name item-name)
  (intern-string "+~a--~a+" enum-name item-name))

(defun filter-by-tag (tag-name node-list)
  (remove-if-not (lambda (node)
                   (equal (xmls:node-name node) tag-name))
                 node-list))

(defun write-enum (node)
  (let ((name (node-attr-value node "name")))
    (mapc (lambda (item)
            (write-form
             (let ((name (intern-enum-constant name (node-attr-value item "name"))))
               `(progn
                  (export ',name)
                  (defconstant ,name
                    ,(parse-integer (node-content (node-content item))))))))
          (filter-by-tag "item" (xmls:node-children node)))))


(defun switch-node (node)
  (let* ((children (xmls:node-children node))
         (ref (node->field (car children)))
         (cases (cdr children))
         (node-name (xmls:node-name (car cases))))
    `(,(intern-string "~a" node-name) ,ref
      ,@(mapcar ^(destructuring-bind (enum-ref &rest fields) (xmls:node-children _)
                   `(,(intern-enum-constant (node-attr-value enum-ref "ref")
                                            (node-content enum-ref))
                     ,@(mapcar #'node->field fields)))
                cases))))

(defun op-node (node)
  (let ((op (node-attr-value node "op"))
        (children (xmls:node-children node)))
    (list
     (str:string-case op
       ("+" '+)
       ("-" '-)
       ("*" '*)
       ("/" '/)
       ("&" 'logand))
     (node->field (first children))
     (node->field (second children)))))


(defun unop-node (node)
  (let ((op (node-attr-value node "op"))
        (children (xmls:node-children node)))
    (list
     (str:string-case op
       ("~" 'lognot))
     (node->field (first children)))))

(defun exprfield-node (node)
  `(aux ,(field-node node) ,(node->field (first (xmls:node-children node)))))


(defun node->field (node)
  (if (null node)
      nil
      (str:string-case (xmls:node-name node)
        ("op" (op-node node))
        ("unop" (unop-node node))
        ("value" (parse-integer (car (xmls:node-children node))))
        ("fieldref" (intern-node-content node))
        ("exprfield" (exprfield-node node))
        ("switch" (switch-node node))
        ("doc" ())
        ("pad"  (pad-node node))
        ("field" (field-node node))
        ("list" (list-node node)))))

(defun reply-node (node)
  (remove nil
          (mapcar (lambda (node)
                    (str:string-case (xmls:node-name node)
                      ("pad"  (pad-node node))
                      ("field" (field-node node))
                      ("list" (list-node node))))
                  (xmls:node-children node))))

(defun write-request (node)
  (let* ((name (intern-string "~a" (node-attr-value node "name")))
         (fields (remove nil
                         (mapcar #'node->field (xmls:node-children node))))
         (reply (find-if ^(equal (xmls:node-name _) "reply") (xmls:node-children node)))
         (reply-fields (and reply (reply-node reply)))
         (opcode (parse-integer (node-attr-value node "opcode"))))
    (write-form
     (cond (*extension-p*
            (when reply
              (push (list 'list  opcode `#',(intern-string "read-~a-reply" name)) *extension-reply-readers*))
            `(define-extension-request ,name ,*extension-name* ,opcode ,fields ,reply-fields))
           (t
            `(define-request ,name ,opcode ,fields ,reply-fields))))))

(defun write-error (node)
  (let ((name (intern-string "~a" (node-attr-value node "name")))
        (number (parse-integer (node-attr-value node "number"))))
    (write-form
     (cond (*extension-p*
            (push (list 'list number (node-attr-value node "name")) *extension-error-names*)
            `(define-extension-error ,name ,*extension-name* ,number))
           (t
            `(define-error ,name ,number))))))

(defun write-struct (node)
  (write-form
   `(define-struct ,(intern-string "~a" (node-attr-value node "name"))
        ,(remove nil
                 (mapcar (lambda (node)
                           (str:string-case (xmls:node-name node)
                             ("pad"  (pad-node node))
                             ("field" (field-node node))
                             ("list" (list-node node))))
                         (xmls:node-children node))))))

(defun write-xproto (node)
  (fresh-line)
  (str:string-case (xmls:node-name node)
    ("xidtype" (write-xidtype node))
    ("xidunion" (write-xidunion node))
    ("typedef" (write-typedef node))
    ("eventcopy" (write-eventcopy node))
    ("union" nil)
    ("event" (write-event node))
    ("error" (write-error node))
    ("errorcopy" (write-error node))
    ("struct" (write-struct node))
    ("enum" (write-enum node))
    ("request" (write-request node))
    (otherwise nil)))

(defun intern-package-name (main-package-name &optional sub-package-name)
  (intern (string-upcase (if sub-package-name
                             (format nil "~a-~a" main-package-name sub-package-name)
                             main-package-name))
          :keyword))

(defun import-headers (root)
  (remove "xproto"
          (mapcar (lambda (node)
                    (car (xmls:node-children node)))
                  (remove-if-not (lambda (node)
                                   (equal (xmls:node-name node) "import"))
                                 (xmls:node-children root)))
          :test #'equal))

(defun extension-p (root)
  (if (node-attr-value root "extension-name") t nil))

(defun defpackage-form (root package-name helper-package-name)
  (let ((header-name (node-attr-value root "header"))
        (package (intern-package-name package-name))
        (helper-package (intern-package-name helper-package-name)))
    `(uiop:define-package ,(intern-package-name package-name header-name)
       ,(append `(:use :cl ,package ,helper-package)
                (mapcar (lambda (name) (intern-package-name package-name name)) (import-headers root)))
       (:shadowing-import-from ,package :atom :byte :char :format))))

(defun in-package-form (root package-name)
  `(in-package ,(intern-package-name package-name (if *extension-p* (node-attr-value root "header") nil))))

(defun defsystem-form (root package-name version author license)
  `(defsystem ,(format nil "~a-~a" package-name (node-attr-value root "header"))
     :version ,version
     :author ,author
     :license ,license
     :depends-on ,(append `((:version ,package-name ,version)) (import-headers root))
     :components ((:file ,(node-attr-value root "header")))))

(defun init-extension-form ()
  `(progn
     (export 'init)
     (defun init (client)
       (init-extension client ,*extension-name*)
       (set-extension-event-readers client ,*extension-name* (list ,@*extension-event-readers*))
       (set-extension-error-names client ,*extension-name* (list ,@*extension-error-names*))
       (set-extension-reply-readers client ,*extension-name* (list ,@*extension-reply-readers*)))))

(defun %generate-1 (in package-name helper-package-name)
  (let* ((root (xmls:parse in))
         (*event-fields-map* nil)
         (*extension-p* (extension-p root))
         (*extension-name* (node-attr-value root "extension-xname"))
         (*extension-event-readers* nil)
         (*extension-error-names* nil)
         (*extension-reply-readers* nil))
    (when *extension-p*
      (write-form (defpackage-form root package-name helper-package-name)))
    (write-form (in-package-form root package-name))
    (mapc #'write-xproto (xmls:node-children root))
    (when *extension-p*
      (write-form (init-extension-form))))
  (values))

(defun generate (in-path out-path package-name helper-package-name)
  (with-open-file (in in-path)
    (if out-path
        (with-open-file (out out-path
                             :direction :output
                             :if-does-not-exist :create
                             :if-exists :supersede)
          (let ((*standard-output* out))
            (%generate-1 in package-name helper-package-name)))
        (%generate-1 in  package-name helper-package-name))))

(defun generate-extension (in-base-path out-base-path extension-file-name package-name helper-package-name
                           version author license)
  (let ((in-path (format nil "~a/~a"in-base-path extension-file-name)))
    (with-open-file (in in-path)
      (let* ((root (xmls:parse in))
             (extension-name (node-attr-value root "header"))
             (extension-dir-name (format nil "~a/~a" out-base-path extension-name))
             (asdf-file-path (format nil "~a/~a-~a.asd" extension-dir-name package-name extension-name))
             (lisp-file-path (format nil "~a/~a.lisp" extension-dir-name extension-name)))
        (ensure-directories-exist asdf-file-path)
        (with-open-file (out asdf-file-path :direction :output :if-exists :supersede)
          (write-form (defsystem-form root package-name version author license) out))
        (generate in-path lisp-file-path package-name helper-package-name)))))

(defun generate-extensions (in-base-path out-base-path package-name helper-package-name
                            version author license)
  (dolist (name *extension-source-file-names*)
    (generate-extension in-base-path out-base-path name package-name helper-package-name
                        version author license)))
