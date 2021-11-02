(ql:quickload "deploy" :silent T)
(ql:quickload "lg" :silent T)

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

;; From :deploy README:
;;
;;   Alternatively, on Windows, you can build your binary with the feature
;;   flag :deploy-console present, which will force it to deploy as a console
;;   application.
(pushnew :deploy-console *features*)

;; Disable :deploy status messages for the final binary
;; but enable it during the build process
(setf deploy:*status-output* nil)
(let ((deploy:*status-output* t))
  (asdf:make :lg :force t))
