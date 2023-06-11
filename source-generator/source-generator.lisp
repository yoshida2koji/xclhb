(defpackage :xclhb-source-generator
  (:use :cl)
  (:export :generate))

(in-package :xclhb-source-generator)

(cl-interpol:enable-interpol-syntax)

(defvar *header-table* nil)

(defvar *header* nil)

(defvar *out* nil)

(defparameter *pre-defined-symbols* '("card8" "card16" "card32" "card64" "int8" "int16" "int32"
                                      "xid" "char" "byte" "bool" "void"
                                      "float" "double" "fd"))

(defvar *package-base-name* nil)

(defun assoc-value (name list)
  (second (assoc name list :test #'equal)))

(defun node-attr-value (node attr-name)
  (assoc-value attr-name (xmls:node-attrs node)))

(defun node-attr-value-lispy (node attr-name)
  (to-lisp-name (assoc-value attr-name (xmls:node-attrs node))))

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


(defun node-content (node)
  (car (xmls:node-children node)))

(defun node-content-lispy (node)
  (to-lisp-name (car (xmls:node-children node))))

(defun dq (str)
  (format nil "~s" str))

(defmacro let-node-slots ((name attrs children) node &body body)
  (let ((node-sym (gensym)))
    `(let ((,node-sym ,node))
       (let ((,name (xmls:node-name ,node-sym))
             (,attrs (xmls:node-attrs ,node-sym))
             (,children (xmls:node-children ,node-sym)))
         (declare (ignorable ,name ,attrs ,children))
         ,@body))))

(defmacro let-attrs (sym-key-list attrs &body body)
  (let ((attrs-sym (gensym)))
    `(let ((,attrs-sym ,attrs))
       (let ,(loop for (sym key) on sym-key-list by #'cddr
                   collect `(,sym (assoc-value ,key ,attrs-sym)))
         ,@body))))

(defun make-table (&rest initial-contents)
  (let ((table (make-hash-table :test #'equal)))
    (loop for (k v) on initial-contents by #'cddr
          do (setf (gethash k table) v))
    table))

(defstruct header
  name extension-name imports symbols
  extension-event-readers
  extension-error-names
  extension-reply-readers
  event-fields-map)

(defun extension-p (&optional (header *header*))
  (if (header-extension-name header) t nil))

(defun register-header (name extension-name)
  (let ((h (make-header :name name
                        :extension-name extension-name
                        :imports (if (equal *package-base-name* name)
                                     nil
                                     (list *package-base-name*))
                        :symbols (make-table))))
    (setf (gethash name *header-table*) h
          *header* h)))

(defun add-import (header-name &optional (header *header*))
  (unless (equal "xproto" header-name)
    (setf (header-imports header)
          (append (header-imports header) (list #?"${ *package-base-name* }-${ header-name }" )))))

(defun get-symbol (name &optional (header *header*))
  (labels ((f (x)
             (etypecase x
               (null nil)
               (header (let ((s (gethash name (header-symbols x))))
                         (if s
                             (if (equal (header-name x) (header-name *header*))
                                 s
                                 (format nil "~a:~a" (header-name x) s))
                             (f (header-imports x)))))
               (cons (or (f (car x)) (f (cdr x))))
               (string (f (gethash x *header-table*))))))
    (let ((pos (position #\: name)))
      (if pos
          (let ((header-name (subseq name 0 pos)))
            (get-symbol (subseq name (+ pos 1))
                        (if (equal header-name "xproto")
                            *package-base-name*
                            #?"${ *package-base-name* }-${ header-name }")))
          (or (f header)
              (let ((s (find name *pre-defined-symbols* :test #'equal)))
                (if (equal (header-name *header*) *package-base-name*)
                    s
                    #?"${ *package-base-name* }:${ s }")))))))

(defun register-symbol (name &optional (header *header*))
  (setf (gethash name (header-symbols header)) name))

(defun register-attr-name (attrs &optional (key "name"))
  (register-symbol (to-lisp-name (assoc-value key attrs))))

(defun convert-value-if-possible (v)
  (cond ((null v) nil)
        ((equal v "true") t)
        ((equal v "false") nil)
        (t (or (parse-integer v :junk-allowed t) (to-lisp-name v)))))

(defun convert-attr-value-if-possible (attr)
  (loop for (k v) in attr
        collect (let ((cv (convert-value-if-possible v)))
                  (list k (if (equal k "type")
                              (get-symbol cv)
                              cv)))))

(defun inner-node-default (node)
  (let-node-slots (node-name attrs children) node
    (let ((first-child (car children)))
      `(,node-name ,(convert-attr-value-if-possible attrs)
                   ,(if (xmls:node-p first-child)
                        (mapcar #'process-inner-node children)
                        (convert-value-if-possible first-child))))))

(defun field-form (node)
  `(,(get-symbol (node-attr-value-lispy node "type")) ,(node-attr-value-lispy node "name")))

(defun list-from (node)
  (let ((content (node-content node))
        (name (node-attr-value-lispy node "name")))
    `("list" ,(get-symbol (node-attr-value-lispy node "type"))
             ,(if content (process-inner-node content) `("length" ,name))
             ,name)))

(defun op-form (node)
  (let ((op (node-attr-value node "op")))
    (cons
     (str:string-case op
       ("&" "logand")
       ("~" "lognot")
       (otherwise op))
     (mapcar #'process-inner-node (xmls:node-children node)))))

(defun pad-form (node)
  (let ((bytes (node-attr-value node "bytes"))
        (align (node-attr-value node "align")))
    `("pad" ,(if bytes "bytes" "align") ,(parse-integer (or bytes align)))))

(defun enum-constant-name (enum-name item-name)
  (to-lisp-name (format nil "+~a--~a+" enum-name item-name)))

(defun enumref-form (node)
  (get-symbol (enum-constant-name (node-attr-value-lispy node "ref")
                                  (node-content-lispy node))))

(defun enumref-node-p (node)
  (equal "enumref" (xmls:node-name node)))


(defun switch-form (node)
  (let* ((children (xmls:node-children node))
         (ref (process-inner-node (car children)))
         (required-start-align (second children))
         (required-start-align-p (equal "required_start_align" (xmls:node-name required-start-align)))
         (cases (nthcdr  (if required-start-align-p 2 1) children))
         (node-name (xmls:node-name (car cases))))
    `(,(to-lisp-name node-name)
      ,ref
      ,(and required-start-align-p `(":align" ,(parse-integer (node-attr-value required-start-align "align"))
                                             ":offset" ,(or (parse-integer (node-attr-value required-start-align "align") :junk-allowed t) 0)))
      ,@(mapcar (lambda (node)
                  (let ((case-children (xmls:node-children node)))
                    `(,(mapcar #'enumref-form (remove-if-not #'enumref-node-p case-children))
                      ,(mapcar #'process-inner-node (remove-if #'enumref-node-p case-children)))))
                cases))))

(defun exprfield-form (node)
  `("aux" ,(field-form node) ,(process-inner-node (first (xmls:node-children node)))))

;; fieldエレメントの type enum属性のみ 名前空間の指定あり
(defun process-inner-node (node)
  (let-node-slots (name attrs children) node
    (str:string-case name
      ("reply"  nil;; (inner-node-default node)
       )
      ;;("item" (inner-node-default node))
      ("required_start_align" nil ;;(inner-node-default node)
                              )
      ;;("type" (inner-node-default node))
      
      ("pad" (pad-form node))
      ("field" (field-form node))
      ;;("length" (inner-node-default node)) ; xinput
      ("fd" `(,(get-symbol "card32") ,(node-attr-value-lispy node "name"))) ; randr shm dri3
      ("list" (list-from node))
      ("exprfield" (exprfield-form node)) ; QueryTextExtents
      ;;("valueparam" (inner-node-default node)) ; not used
      ("switch" (switch-form node))
      ;;("bitcase" (inner-node-default node))
      ;;("case" (inner-node-default node))
      ("op" (op-form node))
      ("fieldref" (to-lisp-name (node-content node)))
      ("paramref" nil ;(inner-node-default node)
                  ) ; xinput DeviceTimeCoord
      ("value" (parse-integer (node-content node)))
      ("bit" (parse-integer (node-content node)))
      ;;("enumref" (inner-node-default node))
      ("unop" (op-form node))
      ;;("sumof" (inner-node-default node)) ; xinput xkb
      ;;("popcount" (inner-node-default node)) ; xinput xkb
      ;;("listelement-ref" (inner-node-default node)) ; xinput
      ;; event type selector
      ;;("allowed" (inner-node-default node))  ; xinput EventForSend
      ("doc" nil)
      (otherwise (error "Unknown node ~a." name)))
    
    ))

(defun top-level-node-default (node &optional (name "name"))
  (let-node-slots (node-name attrs children) node
    (let ((name (to-lisp-name (assoc-value name attrs))))
      (register-symbol name)
      `(,node-name ,name ,(mapcar #'process-inner-node children)))))

(defun define-struct-form (node)
  (let-node-slots (name attrs children) node
    (let ((name (to-lisp-name (assoc-value "name" attrs))))
      (register-symbol name)
      (register-symbol #?"${ name }-length-form")
      (register-symbol #?"read-${ name }")
      (register-symbol #?"${ name }-length-form")
      `(,(if (extension-p)
             #?"${ *package-base-name* }::define-struct"
             "define-struct")
        ,name
        ,(remove nil (mapcar #'process-inner-node children))))))

(defun deftype-form (name form)
  (setf name (to-lisp-name name))
  (register-symbol name)
  `("progn"
    ("export" ',name)
    ("deftype" ,name ()
               ',form)))

(defun filter-by-tag (tag-name node-list)
  (remove-if-not (lambda (node)
                   (equal (xmls:node-name node) tag-name))
                 node-list))

(defun defconstant-form (node)
  (let ((name (node-attr-value-lispy node "name")))
    `("progn"
      ,@(mapcar (lambda (item)
                  (let ((name (enum-constant-name name (node-attr-value-lispy item "name"))))
                    (register-symbol name)
                    `("progn"
                      ("export" ',name)
                      ("defconstant" ,name
                                     ,(parse-integer (node-content (node-content item)))))))
                (filter-by-tag "item" (xmls:node-children node))))))

(defun define-request-form (node)
  (let* ((name (node-attr-value-lispy node "name"))
         (children (xmls:node-children node))
         (fields (remove nil (mapcar #'process-inner-node children)))
         (reply (find-if (lambda (node) (equal (xmls:node-name node) "reply")) children))
         (reply-fields (and reply (remove nil (mapcar #'process-inner-node (xmls:node-children reply)))))
         (opcode (parse-integer (node-attr-value node "opcode"))))
    (cond ((extension-p)
           (when reply
             (push (list "list"  opcode `#',#?"read-${name}-reply")
                   (header-extension-reply-readers *header*)))
           `(,#?"${*package-base-name*}::define-extension-request" ,name
                "+extension-name+" ,opcode ,fields ,reply-fields))
          (t
           `("define-request" ,name ,opcode ,fields ,reply-fields)))))

(defun %define-event-form (name number fields)
  (register-symbol name)
  (cond ((extension-p)
         (push (list "list" number `#',#?"read-${name}-event") (header-extension-event-readers *header*))
         `(,#?"${*package-base-name*}::define-extension-event" ,name
             "+extension-name+" ,number ,fields))
        (t
         `("define-event" ,name ,number ,fields))))

(defun define-event-form (node)
  (let ((name (node-attr-value-lispy node "name"))
        (fields (remove nil (mapcar #'process-inner-node (xmls:node-children node))))
        (number (parse-integer (node-attr-value node "number"))))
    (push (cons name fields) (header-event-fields-map *header*))
    (%define-event-form name number fields)))

(defun define-eventcopy-from (node)
  (let* ((name (node-attr-value-lispy node "name"))
         (ref (node-attr-value-lispy node "ref"))
         (fields (cdr (assoc ref (header-event-fields-map *header*) :test #'equal)))
         (number (parse-integer (node-attr-value node "number"))))
    (%define-event-form name number fields)))

(defun define-error-form (node)
  (let ((name (node-attr-value-lispy node "name"))
        (number (parse-integer (node-attr-value node "number"))))
    (register-symbol name)
    (cond ((extension-p)
           (push (list "list" number (dq (node-attr-value-lispy node "name"))) (header-extension-error-names *header*))
           `(,#?"${*package-base-name*}::define-extension-error" ,name "+extension-name+" ,number))
          (t
           `("define-error" ,name ,number)))))

(defun init-extension-form ()
  `("progn"
    ("export" '"init")
    ("defun" "init" ("client")
             (,#?"${ *package-base-name* }::init-extension" "client" "+extension-name+")
             (,#?"${ *package-base-name* }::set-extension-event-readers" "client" "+extension-name+"
                 ("list" ,@(header-extension-event-readers *header*)))
             (,#?"${ *package-base-name* }::set-extension-error-names" "client" "+extension-name+"
                ("list" ,@(header-extension-error-names *header*)))
             (,#?"${ *package-base-name* }::set-extension-reply-readers" "client" "+extension-name+"
                 ("list" ,@(header-extension-reply-readers *header*))))))

(defun process-top-level-node (node)
  (let-node-slots (name attrs children) node
    (str:string-case name
      ("import" (progn (add-import (node-content node)) nil))
      ("struct" (define-struct-form node))
      ;; xproto ClientMessageData, randr xkb
      ("union" nil ;(top-level-node-default node)
       ) 
      ;; xinput
      ("eventstruct" nil ;(top-level-node-default node)
       )
      ("xidtype" (deftype-form (assoc-value "name" attrs) (get-symbol "xid")))
      ;; ; xproto DRAWABLE FONTABLE, glx DRAWABLE
      ("xidunion" (deftype-form (assoc-value "name" attrs)
                      `("or" ,@(mapcar (lambda (node)
                                         (get-symbol (node-content-lispy node)))
                                       children)))) 
      ("enum" (defconstant-form node))
      ("typedef" (deftype-form (assoc-value "newname" attrs)
                     (get-symbol (node-attr-value-lispy node "oldname"))))
      ("request" (define-request-form node))
      ("event" (define-event-form node))
      ("error" (define-error-form node))
      ("eventcopy" (define-eventcopy-from node))
      ("errorcopy" (define-error-form node))
      (otherwise (error "Unknown node ~a." name)))))

(defun defsystem-form (name simple-name version author license depends-on )
  `("defsystem" ,(dq name)
     ":version" ,(dq version)
     ":author" ,(dq author)
     ":license" ,(dq license)
     ":depends-on" ,(mapcar #'dq depends-on) 
     ":components" ((":file" ,(dq simple-name)))))


(defun defpackage-form (name)
  `("uiop:define-package" ,#?":${name}"
                          (":use" ":cl")
                          (":import-from" ,#?":${ *package-base-name* }"
                                          ":pad" ":bytes" ":align" ":bitcase")))

(defun in-package-form (name)
  `("in-package" ,#?":${name}"))



(defun process-root-node (node out-dir version author license)
  (let-node-slots (name attrs children) node
    (let-attrs (header-name "header" extension-name "extension-xname") attrs
      (let ((package-name (if (equal "xproto" header-name)
                              *package-base-name*
                              #?"${ *package-base-name* }-${ header-name }")))
        (register-header package-name extension-name)
        (let ((path #?"${ out-dir }/${ header-name }/${ header-name }.lisp"))
          (ensure-directories-exist path)
          (with-open-file (out path :direction :output :if-exists :supersede)
            (let ((*out* out))
              (when (extension-p)
                (write-form (defpackage-form package-name)))
              (write-form (in-package-form package-name))
              (when (extension-p)
                (write-form '("export" "'+extension-name+"))
                (write-form `(,#?"${ *package-base-name* }:defglobal" "+extension-name+" ,(dq extension-name))))
              (dolist (node  children)
                (write-form (process-top-level-node node)))
              (when (extension-p)
                (write-form (init-extension-form))))))
        (when (extension-p)
          (with-open-file (out #?"${ out-dir }/${ header-name }/${ package-name }.asd"
                               :direction :output :if-exists :supersede)
            (let ((*out* out))
              (write-form
               (defsystem-form package-name header-name version author license (header-imports *header*))))))))))

(defun write-form (form)
  (when form
    (cond ((equal (car form) "progn")
           (mapc #'write-form (cdr form)))
          (t
           (princ form *out*)
           (terpri *out*)
           (terpri *out*)))))

(defun generate (src-dir out-dir version author license src-file-names)
  (let ((*header-table* (make-table))
        (*out* nil)
        (*header* nil)
        (*package-base-name* "xclhb")
        (*print-pprint-dispatch* (copy-pprint-dispatch)))
    (set-pprint-dispatch 'null (lambda (s o) (declare (ignore o)) (format s "()")))
    (dolist (name src-file-names)
      (with-open-file (in #?"${ src-dir }/${ name }")
        (let ((root (xmls:parse in)))
          (process-root-node root out-dir version author license))
        ;;(print (header-name *header*))
        ;;(maphash (lambda (k v) (print (list k v))) (header-symbols *header*))
        ))))

;; 流れ
;; ファイルを順番に読み込み
;; ルート要素を読む
;; トップレベル要素
;; 内部

