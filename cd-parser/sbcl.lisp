;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C-c M-o slime-repl-clear-buffer
;; C-c C-q slime-close-all-parens-in-sexp
;; Property list or plist where every odd element is a symbol that
;; describes what the next element is
;; C-x 4 C-o quickly change window back to original content
;; dolist loops over a list
;; ~<directive> is like %d of C
;; ~{, the next argument consumed must be a list
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun make-cd (title artist rating ripped)
  (list :title title
	:artist artist
	:rating rating
	:ripped ripped))		; store cd info as plist

(defvar *db* nil)			; create empty database

(defun add-record (cd) (push cd *db*)) ; add cd to database

;; add some cds to database
(add-record (make-cd "American Idiot" "Green Day" 5 t))
(add-record (make-cd "Until Now" "Swedish House Mafia" 5 t))
(add-record (make-cd "Soul Sucker" "This Century" 4 t))
(add-record (make-cd "Monk's Dream" "Thelonious Monk" 4 t))
(add-record (make-cd "Kind of Blue" "Miles Davis" 5 t))
(add-record (make-cd "Clarity" "Zedd" 3.5 t))
(add-record (make-cd "The Dark Side of The Moon" "Pink Floyd" 4 t))

(defun dump-db ()
  (dolist (cd *db*)			; python style looping
    (format t "~{~a:~10t~a~%~}~%" cd)))
;; (defun dump-db ()
;;   (format t "~{~{~a:~10t~a~%~}~%~}" *db*)) ; scary oneliner

(dump-db)

;; given a prompt, take in user friendly input while displaying prompt
(defun prompt-read (prompt)
  (format *query-io* "~a: " prompt)	; store input in *query-io*
  (force-output *query-io*)		; don't wait for newline
					; before printing prompt
  (read-line *query-io*))

;; structure for prompt for one cd
(defun prompt-for-cd ()
  (make-cd
   (prompt-read "Title ")
   (prompt-read "Artist ")
   (or (parse-integer (prompt-read "Rating [1-5] ")
		  :junk-allowed t) 0)
   (y-or-n-p "Ripped [y/n] ")))

(defun add-cds ()
  (loop (add-record (prompt-for-cd))
     (if (not (y-or-n-p "Another? [y/n]")) (return))))

(defun save-db (filename)
  (with-open-file (out filename
		      :direction :output
		      :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))

(save-db "~/Desktop/lisp/my-cds.db")

(defun load-db (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
      (setf *db* (read in)))))

(load-db "~/Desktop/lisp/my-cds.db")
