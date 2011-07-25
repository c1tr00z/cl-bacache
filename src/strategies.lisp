(in-package ru.bazon.tools.cl-bacache)

(defclass strategy()())

(defgeneric get-uuid2delete (strategy level))
(defgeneric get-uuid2delete (strategy level))
(defclass lru-strategy (strategy) ())

(defclass mru-strategy (strategy) ())

(defclass lfu-strategy (strategy) ())

(defmethod get-uuid2delete ((strategy lru-strategy) level)
  (let ((date (get-universal-time))))
  (iter (for (compare-date . item) in (uuids-by-date level))
	(if (< compare-date date)
	  (setf date compare-date)))
  (gethash date (uuids-by-date level)))

(defmethod get-uuid2delete ((strategy mru-strategy) level)
  (let ((date nil)))
  (iter (for (compare-date . item) in (uuids-by-date level))
        (if (or (equal date nil) (> compare-date date))
          (setf date compare-date)))
 (gethash date (uuids-by-date level)))

(defmethod get-uuid2delete ((strategy lru-strategy) level)
  (let ((counter-2-del -1) (object-2-del nil)))
  (iter (for (uuid . using-counter) in (uuids-by-using level))
    (if (or (equal object-2-del nil) (< using-counter counter-2-del))
      (progn
        (setf object-2-del uuid)
        (setf counter-2-del using-counter)))))
