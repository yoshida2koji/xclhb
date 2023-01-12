(in-package :xclhb)

(defglobal *read-reply-functions* (make-array 256 :initial-element nil))

(defglobal *read-event-functions* (make-array 256 :initial-element nil))

(defglobal *write-event-functions* (make-array 256 :initial-element nil))

(defglobal *error-names* (make-array 256 :initial-element nil))

(defun number-type-p (type)
  (subtypep type 'number))

(defun field-name (field)
  (case (first field)
    (pad nil)
    (list (fourth field))
    (otherwise (second field))))

(defun field-names (fields)
  (remove nil (mapcar #'field-name fields)))

(defun field->slot (field)
  (case (first field)
    (pad nil)
    (list (let ((type (second field))
                (name (fourth field)))
            `(,name nil :type (or null (simple-array ,type (*))))))
    (otherwise (let ((type (first field))
                     (name (second field)))
                 (if (number-type-p type)
                     `(,name 0 :type ,type)
                     `(,name nil :type (or null ,type)))))))

(defun fields->slots (fields)
  (remove nil (mapcar #'field->slot fields)))

(defun pad-field (field)
  (destructuring-bind (type value) (cdr field)
    `(offset-inc offset
                 ,(case type
                    (bytes value)
                    (align '(align-pad-length (offset-get offset)))))))



(defun initial-value-of (type)
  (if (number-type-p type)
      0
      nil))

(defun array-type-of (type)
  (if (number-type-p type)
      type
      `(or null ,type)))

(defun read-list-form (type len name)
  (if (number-type-p type)
      `(dotimes (i ,len)
         (setf (aref ,name i) (,(reader-of type) buffer (offset-get offset)))
         (offset-inc offset ,(size-of type)))
      `(dotimes (i ,len)
         (setf (aref ,name i) (,(reader-of type) buffer offset)))))

(defun write-list-form (type len name)
  (let ((count (or len `(length ,name))))
    (if (number-type-p type)
        `(dotimes (i ,count)
           (,(writer-of type) buffer (offset-get offset) (aref ,name i))
           (offset-inc offset ,(size-of type)))
        `(dotimes (i ,count)
           (,(writer-of type) buffer offset (aref ,name i))))))

(defun field->read-form (field)
  (case (first field)
    (pad (pad-field field))
    (list (destructuring-bind (type len name) (cdr field)
            `(progn
               (setf ,name (make-array ,len :element-type ',(array-type-of type) :initial-element ,(initial-value-of type)))
               ,(read-list-form type len name))))
    (otherwise (destructuring-bind (type name) field
                 `(progn
                    (setf ,name (,(reader-of type) buffer (offset-get offset)))
                    (offset-inc offset ,(size-of type)))))))

(defun field->write-form (field)
  (case (first field)
    (pad (pad-field field))
    (list (destructuring-bind (type len name) (cdr field)
            (write-list-form type len name)))
    (bitcase (destructuring-bind (mask &rest forms) (cdr field)
               `(progn
                  ,@(mapcar (lambda (form)
                              `(when (logbitp ,(first form) ,mask)
                                 ,@(cdr (field->write-form (second form)))))
                            forms))))
    (otherwise (destructuring-bind (type name) field
                 `(progn
                    (,(writer-of type) buffer (offset-get offset) ,name)
                    (offset-inc offset ,(size-of type)))))))

(defun flatten-1 (list &key (mark 'progn) (remove-mark-p t))
  (reduce (lambda (a b)
            (if (and (consp b) (eql (car b) mark))
                (append a (if remove-mark-p (cdr b) b))
                (append a (list b))))
          list
          :initial-value '()))

(defun fields->read-forms (fields)
  (flatten-1 (mapcar #'field->read-form fields)))

(defun fields->write-forms (fields)
  (flatten-1 (mapcar #'field->write-form fields)))

(defun insert (value list i)
  (append (subseq list 0 i) (list value) (nthcdr i list)))


(defun field-length (field)
  (case (first field)
    (pad (if (eql (second field) 'bytes)
             (third field)
             'align))
    (list (let* ((type (second field))
                 (name (fourth field))
                 (len (or (third field) `(length ,name)))
                 (element-size (size-of type)))
            (etypecase element-size
              (number `((* ,element-size ,len) ,len))
              (symbol `((loop :for i :from 0 :below ,len
                              :sum (,element-size (aref ,name i)))
                        ,len
                        ,name)))))
    (bitcase `((* ,(size-of 'card32) (logcount ,(second field)))))
    (otherwise (size-of (first field)))))

(defun collect-operand-vars (form)
  (let (vars)
    (labels ((f (form)
               (cond ((null form) nil)
                     ((symbolp form) (push form vars))
                     ((cl:atom form) nil)
                     (t (dolist (x (cdr form))
                          (f x))))))
      (f form)
      (remove-duplicates vars))))

(defun length-ref-slots (length-list)
  (let (slots)
    (dolist (x length-list)
      (when (consp x)
        (if-let (len (second x))
          (setf slots (append (collect-operand-vars len) slots)))
        (if-let (name (third x))
          (push name slots))))
    (remove-duplicates slots)))

(defun compose-length (length-list &optional (init 0))
  (let ((len init)
        (forms))
    (dolist (x length-list)
      (cond
        ((numberp x) (incf len x))
        ((consp x) (push (first x) forms))
        ((eql 'align x) (setf (first forms)
                              `(aligned-length ,(first forms))))
        (t (error "unexpected value ~a" x))))
    `(+ ,len ,@forms)))

(defun struct-length (name fields)
  (let ((length-list (mapcar #'field-length fields)))
    (if (every #'numberp length-list)
        (apply #'+ length-list)
        `((,(intern-name name "with-~a" ) ,(length-ref-slots length-list) ,name
           ,(compose-length length-list))))))

;; define-structでstructの長さを返す関数定義
;; listの場合 各要素の長さが4の倍数 (* xxx-len 要素のサイズ)
;; それ以外 (aligned-length (* xxx-len 要素のサイズ))
;; リストで長さがないものはリクエストの末尾のみ
;; リクエストにリストは1つのみ
;; switchは末尾に0or1

(defmacro define-struct (name fields)
  (let ((length-form (struct-length name fields)))
    `(progn
       (defstruct+ ,name (:export-all-p t)
         ,@(fields->slots fields))
       (define-at-compile ,(intern-name name "~a-length-form") ()
         ,(if (consp length-form)
              `',(intern-name name "%~a-length")
              length-form))
       ,(when (consp length-form)
          `(define-at-compile ,(intern-name name "%~a-length") (,name)
             ,@length-form))
       (defun ,(intern-name name "read-~a") (buffer offset)
         (let ((str (,(intern-name name "make-~a"))))
           (,(intern-name name "with-~a") ,(field-names fields) str
            ,@(fields->read-forms fields))
           str))
       (defun ,(intern-name name "write-~a") (buffer offset str)
         (,(intern-name name "let-~a") ,(field-names fields) str
          ,@(fields->write-forms fields))))))

(export 'x-event)
(defstruct x-event)

(defmacro define-event (name code fields)
  (unless (member name '(client-message ge-generic))
    (let* ((base-name (intern-name name "~a-event"))
           (reader-name (intern-name base-name "read-~a"))
           (writer-name (intern-name base-name "write-~a"))
           (constant-name (intern-name base-name "+~a+")))
      `(progn
         (export ',constant-name)
         (defconstant ,constant-name ,code)
         (defstruct+ ,base-name (:export-all-p t :include x-event)
           ,@(fields->slots fields))
         (defun ,reader-name (buffer offset)
           (let ((str (,(intern-name base-name "make-~a"))))
             (,(intern-name base-name "with-~a") ,(field-names fields) str
              ;; add sequence number pad
              ,@(fields->read-forms (insert '(pad bytes 2) fields 1)))
             str))
         (setf (aref *read-event-functions* ,code) #',reader-name)
         (defun ,writer-name (buffer offset str)
           (,(intern-name base-name "let-~a") ,(field-names fields) str
            ;; add sequence number pad
            ,@(fields->write-forms (insert '(pad bytes 2) fields 1))))
         (setf (aref *write-event-functions* ,code) #',writer-name)))))

;;; error

(defstruct+ x-error (:export-all-p t)
  (code 0 :type card8)
  (sequence-number 0 :type card16)
  (bad-value 0 :type card32)
  (minor-opcode 0 :type card16)
  (major-opcode 0 :type card8))

(defun read-x-error (buffer)
  (make-x-error :code (read-card8 buffer 1)
                :sequence-number (read-card16 buffer 2)
                :bad-value (read-card32 buffer 4)
                :minor-opcode (read-card16 buffer 8)
                :major-opcode (read-card8 buffer 10)))


(defmacro define-error (name code)
  (let ((constant-name (intern-name name "+~a-error+")))
    `(progn
       (export ',constant-name)
       (defconstant ,constant-name ,code)
       (setf (aref *error-names* ,code) ,(symbol-name name)))))

(defun exclude-refs (fields)
  (remove-if (lambda (x)
               (or (null x) (numberp x)))
             (mapcar (lambda (f)
                       (case (first f)
                         (list (third f))
                         (bitcase (second f))))
                     fields)))

(defun find-recursive (item list)
  (cond ((cl:atom list) (eql item list))
        ((null list) nil)
        ((find-recursive item (car list)) t)
        (t (find-recursive item (cdr list)))))


(defun request-args (fields)
  (flatten-1
   (remove nil (mapcar (lambda (f)
                         (case (first f)
                           (pad nil)
                           (list (fourth f))
                           (bitcase `(&key ,@(mapcar #'cadadr (cddr f))))
                           (otherwise (second f))))
                       fields))
   :mark '&key))

(defun request-length (fields)
  (let ((length-list (mapcar #'field-length (cdr fields))))
    (if (every #'numberp length-list)
        (aligned-length (apply #'+ 4 length-list))
        `(aligned-length ,(compose-length length-list 4)))))

(defstruct+ reply-collback (:export-all-p t)
  (major-opcode 0 :type card8)
  (minor-opcode nil :type (or null card16))
  (fn nil :type function))

(export 'x-reply)
(defstruct x-reply)

(defmacro define-request (name code request-fields reply-fields)
  `(progn
     (export ',name)
     ,(let ((write-length-form '(card16 (/ request-length 4))))
        `(defun ,name ,(remove nil `(client ,(if reply-fields 'callback) ,@(request-args request-fields)))
           (let* ((request-length ,(request-length request-fields))
                  (buffer (if (> request-length (length (client-output-buffer client)))
                              (make-buffer request-length)
                              (client-output-buffer client)))
                  (offset (make-offset 1)))
             (declare (dynamic-extent offset)
                      (ignorable offset))
             (write-card8 buffer 0 ,code)
             ,@(if request-fields
                   (fields->write-forms (insert write-length-form request-fields 1))
                   (fields->write-forms `((pad bytes 1) ,write-length-form)))
             (write-sequence buffer (client-stream client) :end request-length)
             (let ((seq-no (client-request-sequence-number client)))
               ,(when reply-fields
                  `(push (cons seq-no (make-reply-collback :major-opcode ,code :fn callback))
                         (client-request-reply-callback-table client)))
               (setf (client-request-sequence-number client) (+ seq-no 1))
               seq-no))))
     ,(when reply-fields
        (let* ((str-name (intern-name name "~a-reply"))
               (reader-name (intern-name str-name "read-~a")))
          `(progn
             (defstruct+ ,str-name (:export-all-p t :include x-reply)
               ,@(fields->slots reply-fields))
             (defun ,reader-name (buffer offset length)
               (declare (ignorable length))
               (let ((str (,(intern-name str-name "make-~a"))))
                 (,(intern-name str-name "with-~a") ,(field-names reply-fields) str
                  ,@(fields->read-forms (insert '(pad bytes 6) reply-fields 1)))
                 str))
             (setf (aref *read-reply-functions* ,code) #',reader-name))))))
