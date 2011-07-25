(in-package ru.bazon.tools.cl-bacache)

(defclass abstract-level()
  ((uuids :type hash-table
  :accessor uuids)
  (uuids-by-date :type hash-table
  :accessor uuids-by-date)
  (uuids-by-using :type hash-table
  :accessor uuids-by-using)
  (size :type integer
  :accessor size)
  (strategy :type strategy)
  (next-level :type abstract-level
  :accessor next-level)))

(defmethod initialize-instance :after ((level abstract-level) &key strategy size n-level)
  (if (equal strategy nil)
    (setf (strategy level) (make-instance 'lru-strategy))
    (setf (strategy level) strategy))
  (if (< size 0)
    (setf (size level) 0)
    (setf (size level) size))
  (setf (next-level level) n-level)
  (setf (uuids level) (make-hash-table))
  (setf (uuids-by-date level) (make-hash-table))
  (setf (uuids-by-using level) (make-hash-table)))

(defmethod add-object-uuid((level abstract-level) &key uuid)
  (let ((date (local-time:make-timestamp))))
  (setf (get-hash uuid (getf level 'uuids)) date)
  (setf (get-hash date (getf level 'uuids-by-date)) uuid)
  (setf (get-hash uuid (getf level 'uuids-by-using)) 0))

(defgeneric add-object (level object uuid))

(defgeneric just-get-object (level uuid))

(defmethod delete-object ((level abstract-level) &key uuid)
  (setf (get-hash uuid (getf level uuids)) nil)
  (setf (get-hash date (getf level uuids-by-date)) nil)
  (setf (Get-hash uuid (getf level uuids-by-using)) nil))

(defmethod get-object ((level abstract-level) &key uuid)
  (if (not (equal uuid nil))
      (progn
	(if (equal (get-hash uuid (getf level 'uuids-by-using)) nil)
	  (setf (get-hash uuid (getf level 'uuids-by-using)) 0)
	  (progn
	    (setf use-count (get-hash  uuid (getf level 'uuids-by-using)))
	    (setf (get-hash (getf level 'uuids-by-using) uuid) (+ use-count 1))))
	(setf (get-hash (get-hash uuid (getf level 'uuids)) (getf level 'uuids-by-date)) (local-time:make-timestamp))
	(just-get-object level uuid))
    (nil)))

(defmethod add-object-to-level ((level abstract-level) %key next-level object uuid)
  (add-object level uuid))