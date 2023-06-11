(uiop:define-package :xclhb-sync (:use :cl)
 (:import-from :xclhb :pad :bytes :align :bitcase))

(in-package :xclhb-sync)

(export '+extension-name+)

(xclhb:defglobal +extension-name+ "SYNC")

(export 'alarm)

(deftype alarm () 'xclhb:xid)

(export '+alarmstate--active+)

(defconstant +alarmstate--active+ 0)

(export '+alarmstate--inactive+)

(defconstant +alarmstate--inactive+ 1)

(export '+alarmstate--destroyed+)

(defconstant +alarmstate--destroyed+ 2)

(export 'counter)

(deftype counter () 'xclhb:xid)

(export 'fence)

(deftype fence () 'xclhb:xid)

(export '+testtype--positive-transition+)

(defconstant +testtype--positive-transition+ 0)

(export '+testtype--negative-transition+)

(defconstant +testtype--negative-transition+ 1)

(export '+testtype--positive-comparison+)

(defconstant +testtype--positive-comparison+ 2)

(export '+testtype--negative-comparison+)

(defconstant +testtype--negative-comparison+ 3)

(export '+valuetype--absolute+)

(defconstant +valuetype--absolute+ 0)

(export '+valuetype--relative+)

(defconstant +valuetype--relative+ 1)

(export '+ca--counter+)

(defconstant +ca--counter+ 0)

(export '+ca--value-type+)

(defconstant +ca--value-type+ 1)

(export '+ca--value+)

(defconstant +ca--value+ 2)

(export '+ca--test-type+)

(defconstant +ca--test-type+ 3)

(export '+ca--delta+)

(defconstant +ca--delta+ 4)

(export '+ca--events+)

(defconstant +ca--events+ 5)

(xclhb::define-struct int64 ((xclhb:int32 hi) (xclhb:card32 lo)))

(xclhb::define-struct systemcounter
 ((counter counter) (int64 resolution) (xclhb:card16 name-len)
  (list xclhb:char name-len name) (pad align 4)))

(xclhb::define-struct trigger
 ((counter counter) (xclhb:card32 wait-type) (int64 wait-value)
  (xclhb:card32 test-type)))

(xclhb::define-struct waitcondition ((trigger trigger) (int64 event-threshold)))

(xclhb::define-extension-error counter +extension-name+ 0)

(xclhb::define-extension-error alarm +extension-name+ 1)

(xclhb::define-extension-request initialize +extension-name+ 0
 ((xclhb:card8 desired-major-version) (xclhb:card8 desired-minor-version))
 ((pad bytes 1) (xclhb:card8 major-version) (xclhb:card8 minor-version)
  (pad bytes 22)))

(xclhb::define-extension-request list-system-counters +extension-name+ 1 ()
 ((pad bytes 1) (xclhb:card32 counters-len) (pad bytes 20)
  (list systemcounter counters-len counters)))

(xclhb::define-extension-request create-counter +extension-name+ 2
 ((counter id) (int64 initial-value)) ())

(xclhb::define-extension-request destroy-counter +extension-name+ 6
 ((counter counter)) ())

(xclhb::define-extension-request query-counter +extension-name+ 5
 ((counter counter)) ((pad bytes 1) (int64 counter-value)))

(xclhb::define-extension-request await +extension-name+ 7
 ((list waitcondition (length wait-list) wait-list)) ())

(xclhb::define-extension-request change-counter +extension-name+ 4
 ((counter counter) (int64 amount)) ())

(xclhb::define-extension-request set-counter +extension-name+ 3
 ((counter counter) (int64 value)) ())

(xclhb::define-extension-request create-alarm +extension-name+ 8
 ((alarm id) (xclhb:card32 value-mask)
  (bitcase value-mask () ((+ca--counter+) ((counter counter)))
   ((+ca--value-type+) ((xclhb:card32 value-type)))
   ((+ca--value+) ((int64 value)))
   ((+ca--test-type+) ((xclhb:card32 test-type)))
   ((+ca--delta+) ((int64 delta))) ((+ca--events+) ((xclhb:card32 events)))))
 ())

(xclhb::define-extension-request change-alarm +extension-name+ 9
 ((alarm id) (xclhb:card32 value-mask)
  (bitcase value-mask () ((+ca--counter+) ((counter counter)))
   ((+ca--value-type+) ((xclhb:card32 value-type)))
   ((+ca--value+) ((int64 value)))
   ((+ca--test-type+) ((xclhb:card32 test-type)))
   ((+ca--delta+) ((int64 delta))) ((+ca--events+) ((xclhb:card32 events)))))
 ())

(xclhb::define-extension-request destroy-alarm +extension-name+ 11
 ((alarm alarm)) ())

(xclhb::define-extension-request query-alarm +extension-name+ 10
 ((alarm alarm))
 ((pad bytes 1) (trigger trigger) (int64 delta) (xclhb:bool events)
  (xclhb:card8 state) (pad bytes 2)))

(xclhb::define-extension-request set-priority +extension-name+ 12
 ((xclhb:card32 id) (xclhb:int32 priority)) ())

(xclhb::define-extension-request get-priority +extension-name+ 13
 ((xclhb:card32 id)) ((pad bytes 1) (xclhb:int32 priority)))

(xclhb::define-extension-request create-fence +extension-name+ 14
 ((xclhb:drawable drawable) (fence fence) (xclhb:bool initially-triggered)) ())

(xclhb::define-extension-request trigger-fence +extension-name+ 15
 ((fence fence)) ())

(xclhb::define-extension-request reset-fence +extension-name+ 16
 ((fence fence)) ())

(xclhb::define-extension-request destroy-fence +extension-name+ 17
 ((fence fence)) ())

(xclhb::define-extension-request query-fence +extension-name+ 18
 ((fence fence)) ((pad bytes 1) (xclhb:bool triggered) (pad bytes 23)))

(xclhb::define-extension-request await-fence +extension-name+ 19
 ((list fence (length fence-list) fence-list)) ())

(xclhb::define-extension-event counter-notify +extension-name+ 0
 ((xclhb:card8 kind) (counter counter) (int64 wait-value) (int64 counter-value)
  (xclhb:timestamp timestamp) (xclhb:card16 count) (xclhb:bool destroyed)
  (pad bytes 1)))

(xclhb::define-extension-event alarm-notify +extension-name+ 1
 ((xclhb:card8 kind) (alarm alarm) (int64 counter-value) (int64 alarm-value)
  (xclhb:timestamp timestamp) (xclhb:card8 state) (pad bytes 3)))

(export 'init)

(defun init (client) (xclhb::init-extension client +extension-name+)
 (xclhb::set-extension-event-readers client +extension-name+
  (list (list 1 #'read-alarm-notify-event)
   (list 0 #'read-counter-notify-event)))
 (xclhb::set-extension-error-names client +extension-name+
  (list (list 1 "alarm") (list 0 "counter")))
 (xclhb::set-extension-reply-readers client +extension-name+
  (list (list 18 #'read-query-fence-reply) (list 13 #'read-get-priority-reply)
   (list 10 #'read-query-alarm-reply) (list 5 #'read-query-counter-reply)
   (list 1 #'read-list-system-counters-reply)
   (list 0 #'read-initialize-reply))))

