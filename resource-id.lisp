(in-package :xclhb)

(export '(allocate-resource-id free-resource-id))

;;;; referred to clx

(defun make-byte-spec-for-resource-id (resource-id-mask)
  (if (zerop resource-id-mask)
      nil
      (do ((first 0 (1+ first))
           (mask resource-id-mask (ash mask -1)))
          ((logbitp 0 mask)
           (cl:byte (integer-length mask) first)))))

(defun allocate-resource-id (client)
  "Returns nil if there is no resource id available for allocation"
  (with-client (resource-id-count resource-id-byte-spec resource-id-base resource-id-table) client
    (let ((begin resource-id-count))
      (labels ((find-unused-id ()
                 (let ((id (dpb resource-id-count
                                resource-id-byte-spec
                                resource-id-base)))
                   (cond ((= id resource-id-base)
                          (setf resource-id-count 1)
                          (find-unused-id))
                         ((gethash id resource-id-table)
                          (incf resource-id-count)
                          (if (= begin resource-id-count)
                              nil
                              (find-unused-id)))
                         (t (setf (gethash id resource-id-table) id)
                            id)))))
        (find-unused-id)))))

(defun free-resource-id (client id)
  (remhash id (client-resource-id-table client))
  (values))

