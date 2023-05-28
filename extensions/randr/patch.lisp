;; rewrite this form 
(xclhb::define-extension-event notify +extension-name+ 1
 ((xclhb:card8 sub-code) (xclhb:card32 u)))

;; to
(progn
  (export '+notify-event+)
  (defconstant +notify-event+ 1)
  (struct+:defstruct+ notify-event (:export-all-p t :include xclhb:x-event)
                      (sub-code 0 :type xclhb:card8) (data nil :type (or null crtc-change output-change
                                                                         output-property provider-change
                                                                         provider-property resource-change
                                                                         lease-notify)))
  (defun read-notify-event (xclhb::buffer xclhb::offset)
    (let ((xclhb:str (make-notify-event)))
      (with-notify-event (sub-code data) xclhb:str
        (setf sub-code
              (xclhb:read-card8 xclhb::buffer
                                (xclhb:offset-get xclhb::offset)))
        (xclhb:offset-inc xclhb::offset 1) (xclhb:offset-inc xclhb::offset 2)
        (setf data
              (case sub-code
                (0 (read-crtc-change xclhb::buffer xclhb::offset))
                (1 (read-output-change xclhb::buffer xclhb::offset))
                (2 (read-output-property xclhb::buffer xclhb::offset))
                (3 (read-provider-change xclhb::buffer xclhb::offset))
                (4 (read-provider-property xclhb::buffer xclhb::offset))
                (5 (read-resource-change xclhb::buffer xclhb::offset))
                (6 (read-lease-notify xclhb::buffer xclhb::offset)))))
      xclhb:str))
  ()
  (defun write-notify-event (xclhb::buffer xclhb::offset xclhb:str)
    (let-notify-event (sub-code data) xclhb:str
                      (xclhb:write-card8 xclhb::buffer (xclhb:offset-get xclhb::offset) sub-code)
                      (xclhb:offset-inc xclhb::offset 1) (xclhb:offset-inc xclhb::offset 2)
                      (case sub-code
                        (0 (write-crtc-change xclhb::buffer xclhb::offset data))
                        (1 (write-output-change xclhb::buffer xclhb::offset data))
                        (2 (write-output-property xclhb::buffer xclhb::offset data))
                        (3 (write-provider-change xclhb::buffer xclhb::offset data))
                        (4 (write-provider-property xclhb::buffer xclhb::offset data))
                        (5 (write-resource-change xclhb::buffer xclhb::offset data))
                        (6 (write-lease-notify xclhb::buffer xclhb::offset data)))))
  ())

