(in-package :xclhb)

(export '(allocate-resource-id))

;;;; referred to clx

(defun make-byte-spec-for-resource-id (resource-id-mask)
  (if (zerop resource-id-mask)
      nil
      (do ((first 0 (1+ first))
           (mask resource-id-mask (ash mask -1)))
          ((logbitp 0 mask)
           (cl:byte (integer-length mask) first)))))

(defun allocate-resource-id (client)
  (with-client (resource-id-count resource-id-byte-spec resource-id-base resource-id-list) client
    (let ((id (dpb (incf resource-id-count)
                   resource-id-byte-spec
                   resource-id-base)))
      (push id resource-id-list)
      id)))


