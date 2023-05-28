(in-package :xclhb-shm)

(cffi:defcfun "shmget" :int
  (key :int)
  (size :long)
  (flags :int))

(cffi:defcfun "shmat" :pointer
  (segment-id :int)
  (segment-pointer :pointer)
  (flags :int))

(cffi:defcfun "shmdt" :int
  (segment-pointer :pointer))

(cffi:defcfun "shmctl" :int
  (segment-id :int)
  (command :int)
  (shmid-ds :pointer))

(export '(shm-segment shm-segment-id shm-segment-size shm-segment-data))
(defstruct (shm-segment (:constructor make-shm-segment%))
  (id 0 :type (integer 0) :read-only t)
  (size 0 :type (integer 0) :read-only t)
  (data nil :type cffi:foreign-pointer :read-only t))

(defun get-segment-id (size)
  "when error, return -1"
  (shmget 0 size #o1777))

(defun attach-segment (segment-id)
  "return foreign pointer. when error, return -1"
  (shmat segment-id (cffi:null-pointer) 0))

(defun attach-fail-p (pointer)
  (let ((addr (cffi:pointer-address pointer)))
    (dotimes (i (integer-length addr))
      (unless (logbitp i addr)
        (return-from attach-fail-p nil)))
    t))

(defun detach-segment (segment-pointer)
  (shmdt segment-pointer))

(defun free (segment-id)
  (shmctl segment-id 0 (cffi:null-pointer)))

(export 'make-shm-segment)
(defun make-shm-segment (size)
  (let ((id (get-segment-id size)))
    (when (= id -1)
      (error "failed to shmget"))
    (let ((pointer (attach-segment id)))
      (when (attach-fail-p pointer)
        (error "failed to shmat"))
      (let ((segment (make-shm-segment% :id id :size size :data pointer)))
        (tg:finalize segment (lambda ()
                               (detach-segment pointer)
                               (free id)))
        segment))))

(export 'free-shm-segment)
(defun free-shm-segment (segment)
  (detach-segment (shm-segment-data segment))
  (free (shm-segment-id segment))
  (values))
