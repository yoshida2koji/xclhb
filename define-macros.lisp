(in-package :xclhb)

(defglobal *read-reply-functions* (make-array 256 :initial-element nil))

(defglobal *read-event-functions* (make-array 256 :initial-element nil))

(defglobal *write-event-functions* (make-array 256 :initial-element nil))

(defglobal *error-names* (make-array 256 :initial-element nil))

(defun length-symbol-p (sym)
  (and (symbolp sym)
       (let* ((name (symbol-name sym))
              (suffix "-LEN")
              (name-len (length name))
              (suffix-len (length suffix)))
         (and (>= name-len suffix-len)
              (equal (subseq name (- name-len suffix-len)) suffix)))))

(defun length-symbol->target-symbol (sym)
  (let* ((name (symbol-name sym))
         (suffix "-LEN")
         (name-len (length name))
         (suffix-len (length suffix)))
    (intern (subseq name 0 (- name-len suffix-len)))))

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


(defun op-form (form)
  (etypecase form
    (cons `(,(car form) ,@(mapcar #'op-form (cdr form))))
    (symbol (if (length-symbol-p form)
                `(length ,(length-symbol->target-symbol form))
                form))
    (number form)))


(defun flatten (list)
  (let ((flat-list))
    (labels ((el (x)
               (cond ((cl:atom x)
                      (push x flat-list))
                     (t
                      (el (car x))
                      (when (cdr x)
                        (el (cdr x)))))))
      (el list))
    (nreverse flat-list)))

(defun flatten-1 (list &key (mark 'progn) (remove-mark-p t))
  (reduce (lambda (a b)
            (if (and (consp b) (eql (car b) mark))
                (append a (if remove-mark-p (cdr b) b))
                (append a (list b))))
          list
          :initial-value '()))

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

(defun fields->read-forms (fields)
  (flatten-1 (mapcar #'field->read-form fields)))

(defun field->write-form (field)
  (let ((field-type (first field)))
    (case field-type
        (pad (pad-field field))
      (list (destructuring-bind (type len name) (cdr field)
              (write-list-form type len name)))
      ((bitcase case) (destructuring-bind (ref &rest forms) (cdr field)
                        (let ((pred (if (eql 'bitcase field-type) 'logbitp 'eql)))
                          `(progn
                             ,@(mapcar (lambda (form)
                                         `(when (,pred ,(first form) ,ref)
                                            ,@(flatten-1 (mapcar #'field->write-form (cdr form)))))
                                       forms)))))
      (aux (field->write-form (list (first (second field)) (third field))))
      (otherwise (destructuring-bind (type name) field
                   `(progn
                      (,(writer-of type) buffer (offset-get offset) ,name)
                      (offset-inc offset ,(size-of type))))))))

(defun fields->write-forms (fields)
  (flatten-1 (mapcar #'field->write-form fields)))

(defun insert (value list i)
  (append (subseq list 0 i) (list value) (nthcdr i list)))


(defun field-length (field)
  (let ((field-type (first field)))
    (case field-type
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
      ;;(bitcase `((* ,(size-of 'card32) (logcount ,(second field)))))
      ((bitcase case) (destructuring-bind (ref &rest forms) (cdr field)
                        (let ((pred (if (eql 'bitcase field-type) 'logbitp 'eql)))
                          `((+ ,@(mapcar (lambda (f)
                                            `(if (,pred ,(first f) ,ref)
                                                 (+ ,@(mapcar #'field-length (cdr f)))
                                                 0))
                                          forms))))))
      (aux (field-length (second field)))
      (otherwise (size-of (first field))))))

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
  (let* ((length-form (struct-length name fields))
         (length-form-name (intern-name name "~a-length-form"))
         (length-name (intern-name name "%~a-length"))
         (reader-name (intern-name name "read-~a"))
         (writer-name (intern-name name "write-~a")))
    `(progn
       (defstruct+ ,name (:export-all-p t)
                   ,@(fields->slots fields))
       (reexport ',length-form-name :%xclhb)
       (define-at-compile ,length-form-name ()
         ,(if (consp length-form)
              `',(intern-name name "%~a-length")
              length-form))
       ,(when (consp length-form)
          `(progn
             (reexport ',length-name :%xclhb)
             (define-at-compile ,length-name (,name)
               ,@length-form)))
       (reexport ',reader-name :%xclhb)
       (defun ,reader-name (buffer offset)
         (let ((str (,(intern-name name "make-~a"))))
           (,(intern-name name "with-~a") ,(field-names fields) str
            ,@(fields->read-forms fields))
           str))
       (reexport ',writer-name :%xclhb)
       (defun ,writer-name (buffer offset str)
         (,(intern-name name "let-~a") ,(field-names fields) str
          ,@(fields->write-forms fields))))))

(export 'x-event)
(defstruct x-event)

(defmacro define-event (name code fields &optional offset)
  (unless (member name '(client-message ge-generic))
    (let* ((base-name (intern-name name "~a-event"))
           (reader-name (intern-name base-name "read-~a"))
           (writer-name (intern-name base-name "write-~a"))
           (constant-name (intern-name base-name "+~a+")))
      `(progn
         (export ',constant-name)
         (defconstant ,constant-name ,(or offset code))
         (defstruct+ ,base-name (:export-all-p t :include x-event)
           ,@(fields->slots fields))
         (defun ,reader-name (buffer offset)
           (let ((str (,(intern-name base-name "make-~a"))))
             (,(intern-name base-name "with-~a") ,(field-names fields) str
              ;; add sequence number pad
              ,@(fields->read-forms (insert '(pad bytes 2) fields 1)))
             str))
         ,(unless offset
            `(setf (aref *read-event-functions* ,code) #',reader-name))
         (defun ,writer-name (buffer offset str)
           (,(intern-name base-name "let-~a") ,(field-names fields) str
            ;; add sequence number pad
            ,@(fields->write-forms (insert '(pad bytes 2) fields 1))))
         ,(unless offset
            `(setf (aref *write-event-functions* ,code) #',writer-name))))))

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


(defmacro define-error (name code &optional offset)
  (let ((constant-name (intern-name name "+~a-error+")))
    `(progn
       (export ',constant-name)
       (defconstant ,constant-name ,(or offset code))
       ,(unless offset
          `(setf (aref *error-names* ,code) ,(symbol-name name))))))

(defun exclude-refs (fields)
  (remove-if (lambda (x)
               (or (null x) (numberp x)))
             (mapcar (lambda (f)
                       (case (first f)
                         (list (third f))
                         ((bitcase case) (second f))))
                     fields)))

(defun find-recursive (item list)
  (cond ((cl:atom list) (eql item list))
        ((null list) nil)
        ((find-recursive item (car list)) t)
        (t (find-recursive item (cdr list)))))


(defun first-request-form (fields)
  (let ((field (first fields)))
    (case (first field)
      (null nil)
      (pad nil)
      (aux (third field))
      (otherwise (second field)))))

(defun request-arg (field)
  (case (first field)
    (pad nil)
    (list (fourth field))
    ((bitcase case) (mapcar (lambda (f)
                               (mapcar #'request-arg (cdr f)))
                             (cddr field)))
    (aux nil)
    (otherwise (second field))))

(defun request-args (fields)
  (remove nil (flatten (mapcar #'request-arg fields))))

(defun request-length (fields)
  (let ((length-list (mapcar #'field-length (cdr fields))))
    (if (every #'numberp length-list)
        (aligned-length (apply #'+ 4 length-list))
        `(aligned-length ,(compose-length length-list 4)))))

(defstruct+ reply-collback (:export-all-p t)
  (major-opcode 0 :type card8)
  (minor-opcode nil :type (or null card16))
  (fn nil :type function))

;; for sync request
(export 'wait-reply)
(defun wait-reply (client request-fn)
  "request-fn is (lambda (cb) (some-request client cb ...))"
  (let* ((reply)
         (err)
         (pre-error-handler (client-default-error-handler client))
         (seq-no (funcall request-fn (lambda (r) (setf reply r)))))
    (setf (client-default-error-handler client)
          (lambda (e)
            (when (= seq-no (x-error-sequence-number e))
              (setf err e))))
    (flush client)
    (loop :until (or reply err)
          :do (process-input-one client :wait-p t))
    (setf (client-default-error-handler client) pre-error-handler)
    (or reply err)))

(export 'x-reply)
(defstruct x-reply)

(defmacro define-request (name code request-fields reply-fields &key minor-opcode)
  (let* ((rest-args (remove-if-not #'symbolp (request-args request-fields)))
         (args (remove nil `(client ,(if reply-fields 'callback) ,@rest-args)))
         (write-forms (fields->write-forms (cdr request-fields))))
    `(progn
       (export ',name)
       (defun ,name ,args
         (let* ((request-length ,(request-length request-fields))
                (big-request-p (> request-length #.(* 4 #xffff)))
                (actual-request-length (if big-request-p (+ 4 request-length) request-length))
                (buffer (if (> actual-request-length (length (client-output-buffer client)))
                            (make-buffer actual-request-length)
                            (client-output-buffer client)))
                (offset (make-offset (if big-request-p 8 4))))
           (declare (dynamic-extent offset)
                    (ignorable offset))
           ;; major opcode
           (write-card8 buffer 0 ,code)
           ;; first field
           ,(if-let (first-form (first-request-form request-fields))
              `(write-card8 buffer 1 ,(op-form first-form)))
           ;; request length
           (cond (big-request-p
                  (write-card16 buffer 2 0)
                  (write-card32 buffer 4 (/ actual-request-length 4)))
                 (t
                  (write-card16 buffer 2 (/ actual-request-length 4))))
           ;; rest fields
           ,@write-forms
           ;; buffer to stream
           (write-sequence buffer (client-stream client) :end actual-request-length)
           (let ((seq-no (client-request-sequence-number client)))
             ,(when reply-fields
                `(push (cons seq-no (make-reply-collback :major-opcode ,code :minor-opcode ,minor-opcode :fn callback))
                       (client-request-reply-callback-table client)))
             (setf (client-request-sequence-number client) (+ seq-no 1))
             seq-no)))
       ,(when reply-fields
          (let* ((sync-name (intern-name name "~a-sync"))
                 (sync-args (remove 'callback args)))
            `(progn
               (export ',sync-name)
               (defun ,sync-name ,sync-args
                 (wait-reply client (lambda (cb)
                                      (,name client cb ,@rest-args)))))))
       ,(when reply-fields
          (let* ((str-name (intern-name name "~a-reply"))
                 (reader-name (intern-name str-name "read-~a"))
                 (slots (fields->slots reply-fields))
                 (make-str (intern-name str-name "make-~a"))
                 (with-str (intern-name str-name "with-~a"))
                 (field-names (field-names reply-fields))
                 (read-forms (fields->read-forms (insert '(pad bytes 6) reply-fields 1))))
            `(progn
               (defstruct+ ,str-name (:export-all-p t :include x-reply) ,@slots)
               (defun ,reader-name (buffer offset length)
                 (declare (ignorable length))
                 (let ((str (,make-str)))
                   (,with-str ,field-names str
                     ,@read-forms)
                   str))
               ,(unless minor-opcode
                  `(setf (aref *read-reply-functions* ,code) #',reader-name))))))))

(defmacro define-extension-event (name extension-name offset fields)
  `(define-event ,name (+ (extension-event-base client ,extension-name) ,offset) ,fields ,offset))

(defmacro define-extension-error (name extension-name offset)
  `(define-error ,name (+ (extension-error-base client ,extension-name) ,offset) ,offset))

(defmacro define-extension-request (name extension-name minor-opcode request-fields reply-fields)
  `(define-request ,name (extension-major-opcode client ,extension-name)
     ,(cons `(card8 ,minor-opcode) request-fields) ,reply-fields :minor-opcode ,minor-opcode))

(defun set-extension-event-readers (client extension-name offset-reader-list)
  (loop with base = (extension-event-base client extension-name)
        for (offset reader) in offset-reader-list
        do (setf (aref *read-event-functions* (+ base offset)) reader)))

(defun set-extension-error-names (client extension-name offset-name-list)
  (loop with base = (extension-error-base client extension-name)
        for (offset name) in offset-name-list
        do (setf (aref *error-names* (+ base offset)) name)))

(defun set-extension-reply-readers (client extension-name minor-opcode-reader-list)
  (let* ((max-minor-opcode (loop for (code . nil) in minor-opcode-reader-list
                                 maximize code))
         (major-opcode (extension-major-opcode client extension-name))
         (reader-table (make-array (+ max-minor-opcode 1) :initial-element nil)))
    (setf (aref *read-reply-functions* major-opcode) reader-table)
    (loop for (minor-opcode reader) in minor-opcode-reader-list
          do (setf (aref reader-table minor-opcode) reader))))

(export '(pad bytes align  bitcase define-struct define-extension-event define-extension-error define-extension-request
          set-extension-event-readers set-extension-error-names set-extension-reply-readers))
