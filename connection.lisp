(in-package :xclhb)

;;;; referred to clx for auth and unix domain socket

;;; auth
(defparameter *protocol-families*
  '(;; X11/X.h, Family*
    (:internet . 0) 
    (:decnet . 1)
    (:chaos . 2)
    ;; X11/Xauth.h "not part of X standard"
    (:Local . 256)
    (:Wild . 65535)
    (:Netname . 254)
    (:Krb5Principal . 253)
    (:LocalHost . 252)))

(defun read-xauth-entry (stream)
  (labels ((read-short (stream &optional (eof-errorp t))
             (let ((high-byte (read-byte stream eof-errorp)))
               (and high-byte
                    (dpb high-byte (cl:byte 8 8) (read-byte stream)))))
           (read-short-length-string (stream)
             (let ((length (read-short stream)))
               (let ((string (make-string length)))
                 (dotimes (k length)
                   (setf (schar string k) (code-char (read-byte stream))))
                 string)))
           (read-short-length-vector (stream)
             (let ((length (read-short stream)))
               (let ((vector (make-array length 
                                         :element-type '(unsigned-byte 8))))
                 (dotimes (k length)
                   (setf (aref vector k) (read-byte stream)))
                 vector))))
    (let ((family-id (read-short stream nil)))
      (if (null family-id)
          (list nil nil nil nil nil)
          (let* ((address-data (read-short-length-vector stream))
                 (num-string (read-short-length-string stream))
                 (number (when (string/= num-string "") (parse-integer num-string)))
                 (name (read-short-length-vector stream))
                 (data (read-short-length-vector stream))
                 (family (car (rassoc family-id *protocol-families*))))
            (unless family
              (return-from read-xauth-entry
                (list family-id nil nil nil nil)))
            (let ((address 
                   (case family
                     (:local (map 'string #'code-char address-data))
                     (:internet (coerce address-data 'list))
                     (t nil))))
              (list family address number name data)))))))

(defun get-auth-info ()
  (let ((auth-file-path (uiop:getenv "XAUTHORITY")))
    (if auth-file-path
        (with-open-file (in auth-file-path :element-type '(unsigned-byte 8)
                                           :if-does-not-exist nil)
          (when in
            (destructuring-bind (family address number name data)
                (read-xauth-entry in)
              (declare (ignore family address number))
              (list name data))))
      (list (make-array 0 :element-type 'card8) (make-array 0 :element-type 'card8)))))


(defun read-setup-response (stream)
  (let ((header-buffer (make-buffer 8)))
    (read-sequence header-buffer stream)
    (let* ((status (read-card8 header-buffer 0))
           (length (read-card16 header-buffer 6))
           (buffer (make-buffer (+ 8 (* 4 length)))))
      (dotimes (i (length header-buffer))
        (setf (aref buffer i) (aref header-buffer i)))
      (read-sequence buffer stream :start (length header-buffer))
      (values (funcall (ecase status
                         (0 #'read-setup-failed)
                         (1 #'read-setup)
                         (2 #'read-setup-authenticate))
                       buffer (make-offset))
              status))))

#+ (or sbcl ecl)
(defun make-x-stream (&optional host)
  (let ((socket #-win32 (if host
                            (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp)
                            (make-instance 'sb-bsd-sockets:local-socket :type :stream))
                #+win32 (make-instance 'sb-bsd-sockets:inet-socket :type :stream :protocol :tcp)))
    (if host
        (sb-bsd-sockets:socket-connect socket
                                       (sb-bsd-sockets:host-ent-address (sb-bsd-sockets:get-host-by-name host))
                                       6000)
        (sb-bsd-sockets:socket-connect socket "/tmp/.X11-unix/X0"))
    (sb-bsd-sockets:socket-make-stream socket
                                       :element-type '(unsigned-byte 8)
                                       :auto-close t
                                       :input t
                                       :output t)))
#+ccl
(defun make-x-stream (&optional host)
  (if host
      (ccl::make-socket :connect :active
                        :address-family :internet
                        :auto-close t
                        :remote-host host
                        :remote-port 6000)
      (ccl::make-socket :connect :active
                    :address-family :file
                    :auto-close t
                        :remote-filename "/tmp/.X11-unix/X0")))

(defun x-connect (&optional host)
  (let ((stream (make-x-stream host)))
    ;; request
    (destructuring-bind (auth-name auth-data) (get-auth-info)
      (let* ((setup-request (make-setup-request :byte-order #x6C ; lsb
                                                :protocol-major-version 11
                                                :protocol-minor-version 0
                                                :authorization-protocol-name-len (length auth-name)
                                                :authorization-protocol-data-len (length auth-data)
                                                :authorization-protocol-name auth-name
                                                :authorization-protocol-data auth-data))
             (buf (make-buffer (%setup-request-length setup-request))))
        (write-setup-request buf (make-offset) setup-request)
        (write-sequence buf stream))
      (finish-output stream))
    (multiple-value-bind (response status) (read-setup-response stream)
      (if (= status 1)
          (with-setup (resource-id-base resource-id-mask) response
            (make-client :stream stream
                         :server-information response
                         :resource-id-base resource-id-base
                         :resource-id-byte-spec (make-byte-spec-for-resource-id resource-id-mask)))
          (values nil response)))))

(export '(x-connect))



