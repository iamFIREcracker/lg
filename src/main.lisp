(in-package #:lg)

(defvar *version* nil "Application version")
;; https://gist.github.com/gruber/249502
(defvar *link-regexp* "(?i)\\b((?:[a-z][\\w-]+:(?:/{1,3}|[a-z0-9%])|www\\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\\s()<>]+|\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\))+(?:\\(([^\\s()<>]+|(\\([^\\s()<>]+\\)))*\\)|[^\\s`!()\\[\\]{};:'\".,<>?«»“”‘’]))")

; Options -----------------------------------------------------------------------------------------

(opts:define-opts
  (:name :help
         :description "print the help text and exit"
         :short #\h
         :long "help")
  (:name :version
         :description "print the version and exit"
         :short #\v
         :long "version"))

(defun parse-opts ()
  (multiple-value-bind (options)
    (handler-case
        (opts:get-opts)
      (opts:unknown-option (condition)
        (format t "~s option is unknown!~%" (opts:option condition))
        (opts:exit 1)))
    (if (getf options :help)
      (progn
        (opts:describe
          :prefix "Grab links from stdin, and print them to stdout."
          :args "[keywords]")
        (opts:exit)))
    (if (getf options :version)
      (progn
        (format T "~a~%" *version*)
        (opts:exit)))))

; API ---------------------------------------------------------------------------------------------

(defun grab-links (s)
  (cl-ppcre:all-matches-as-strings *link-regexp* s))

(defun toplevel ()
  (parse-opts)
  (loop
    :for line = (read-line NIL NIL :eof)
    :until (eq line :eof)
    :do (loop
          :for link :in (grab-links line)
          :do (format T "~a~%" link))))
