(handler-case (ql:quickload :lg/tests)
  (error (a) (format t "caught error ~s~%~a~%" a a) (uiop:quit 17)))

(handler-case (time (asdf:test-system :lg))
  (error (a)
    (format T "caught error ~s~%~a~%" a a) (uiop:quit 13)))
