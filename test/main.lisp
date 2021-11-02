(defpackage :lg-tests
  (:use :cl :lg)
  (:export #:run))

(in-package :lg-tests)

(defvar *tests* nil "A list of tests; the default argument to `run'.")

(defun run () (1am:run *tests*))

(defmacro deftest (name &body body)
  "Define a test function and add it to `*tests*`."
  `(let ((1am:*tests* *tests*))
     (1am:test ,name ,@body)
     (pushnew ',name *tests*)))

(deftest simple
  (1am:is (member "http://matteolandi.net"
                  (lg::grab-links "http://matteolandi.net")
                  :test 'equal)))

(deftest markdown
  (1am:is (member "http://matteolandi.net"
                  (lg::grab-links "[home](http://matteolandi.net)")
                  :test 'equal)))

(deftest angle-brackets
  (1am:is (member "http://matteolandi.net"
                  (lg::grab-links "<http://matteolandi.net>")
                  :test 'equal)))
