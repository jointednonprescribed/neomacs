
(defvar current-project-path nil)

(defvar current-project-file nil)

(defconst project-analyzer-path )

(defun find-project-file-in-folder ()
  "Finds a project file inside of the already-selected project folder."
  "If found, this function leaves the value inside of the global variable:"
  "'current-project-file' as well as returning the value on completion."

  (if (not current-project-path)
    (progn
      (message "No project loaded.")
      (setq current-project-file nil)
      (identity nil)
      )
  ;; else...

    (let (
	  (project-filepath (file-name-concat current-project-path ".neomacs-project"))
	  )

      (setq project-filepath (file-name-concat current-project-path (concat (nth 0 (file-name-split current-project-path)) ".neomacs-project")))

      (defvar current-project-file (eval (car (read-from-string (shell-command-to-string (concat project-analyzer-path " "))))))
)))
