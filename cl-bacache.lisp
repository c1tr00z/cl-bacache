(load "/usr/share/common-lisp/source/asdf/asdf.lisp")
;#-quicklisp
;(let ((quicklisp-init (merge-pathnames "quicklisp/setup.lisp" (user-homedir-pathname))))
;  (when (probe-file quicklisp-init)
;    (load quicklisp-init)))
(ql:quickload "cl-store")
(asdf:load-system 'cl-store)
(with-output-to-string (*standard-output*)
  (asdf:oos 'asdf:load-op 'cl-bacache))
