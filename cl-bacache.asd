(defsystem :cl-bacache
  :name "cl-bacache"
  :author "Igor R. Nikitin <0-range@bazon.ru>"
  :licence "Lessor Lisp General Public License"
  :version "0.0.0.1-prealpha"
  :description "Cache System"
  :depends-on (cl-store iterate local-time)
  :components ((module "src"
                :components
                  ((:file "package")
                  (:file "levels" :depends-on ("package"))
                  (:file "strategies" :depends-on ("package"))))))
