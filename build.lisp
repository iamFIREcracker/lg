(format t "~a/~a~&" (lisp-implementation-type) (lisp-implementation-version))

(ql:quickload :deploy :silent T)

;; By adding the current directory to ql:*local-project-directories*, we can
;; QL:QUICKLOAD this without asking users to symlink this repo inside
;; ~/quicklisp/local-projects, or clone it right there in the first place.
(push #P"." ql:*local-project-directories*)
(ql:quickload :lg :silent T)

(setf lg:*version* (let* ((system (asdf:find-system :lg nil))
                          (base-version (asdf:component-version system))
                          (git-cmd (format NIL "git rev-list v~a..HEAD --count" base-version))
                          (output (uiop:run-program git-cmd
                                                    :output :string
                                                    :ignore-error-status T))
                          (pending (parse-integer output :junk-allowed T)))
                     (if (or (not pending) (zerop pending))
                       (format NIL "~a" base-version)
                       (format NIL "~a-r~a" base-version pending))))

(setf deploy:*status-output* nil)
(pushnew :deploy-console *features*)

(let ((deploy:*status-output* t))
  (asdf:make :lg :force t))
