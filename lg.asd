(asdf:defsystem #:lg
  :description "Matteo's link grabber"
  :author "Matteo Landi <matteo@matteolandi.net>"
  :license  "MIT"
  :version "0.0.1"
  :depends-on (
               #:cl-ppcre
               #:unix-opts
               )

  :defsystem-depends-on (:deploy)
  :build-operation "deploy-op"
  :build-pathname "lg"
  :entry-point "lg:toplevel"

  :in-order-to ((test-op (test-op :lg/tests)))
  :serial t
  :components
  (
   (:file "package")
   (:module "src" :serial t
            :components
            ((:file "main")))))

(asdf:defsystem :lg/tests
  :description "Matteo's link grabber"
  :author "Matteo Landi <matteo@matteolandi.net>"
  :license  "MIT"
  :version "0.0.1"
  :depends-on (
               #:lg
               #:1am
               )
  :serial t
  :components
  ((:module "test"
    :serial t
    :components ((:file "main"))))
  :perform (test-op (o c) (uiop:symbol-call :1am '#:run)))
