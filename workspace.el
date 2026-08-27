
(when (not (boundp '_DEF-FUNCS-UTIL-EL_))
  (load-file (expand-file-name "funcs/util.el" (file-name-directory load-file-name))))

(when (not (boundp '_DEF-PROJECTS-EL_))
  (load-file (expand-file-name "projects.el" (file-name-directory load-file-name))))

(defvar _DEF-WORKSPACE-EL_ nil)

(defvar current-workspace-state nil)

(defvar tab-bar-active nil)

(defvar file-explorer-active nil)

(defvar frame-history nil)

(defvar last-editor-history nil)

(defvar last-editor-window nil)

(defun is-editor-window (window)
  (let (mode-result buf)
    ;; If 'window is indeed a window, or is actually a frame 
    (if (or (frame-live-p window) (window-live-p window))
	(progn
          (setq window (frame-selected-window window))
	  (setq buf (window-buffer window))
	  )
    ;; Else, if 'window is actually a buffer
    (if (bufferp window)
	(setq buf window)
        (setq window nil)
        ))

    (if (not (null window))
        (progn
          (with-current-buffer buf
            (setq mode-result (and (or (derived-mode-p 'prog-mode) (derived-mode-p 'text-mode)) (null buffer-read-only)))
	    ;;(princ (format "\n\nBuffer Name: %s, Buffer Is Read-Only? %s\n" (buffer-name buf) (bool-to-string buffer-read-only)) (get-buffer "*scratch*"))
	    ;;(princ (format "Mode Result: %s\n\n" (bool-to-string mode-result)) (get-buffer "*scratch*"))
            )
          ;;(princ (format "\n\nMode Result: %s\n" (bool-to-string mode-result)) (get-buffer "*scratch*"))
          ;;(princ (format "Final Result: %s\n\n" (bool-to-string (and window mode-result))) (get-buffer "*scratch*"))
          (and window mode-result) ;; DEBUG: ADD CONDITION: (not (string= (buffer-name (window-buffer (frame-selected-window window))) "*Messages*"))
          )
        (identity nil)
        )
    )
)

(defun editor-history/window-state-change-listener (window)
  (let ((selected (frame-selected-window window)))
    (if (and (is-editor-window selected) (not (null window)))
        (progn
	  (setq-default last-editor-window selected)
  	  )
  
    (if (not (or (window-live-p last-editor-window) (null last-editor-window)))
        (progn
	  (setq-default last-editor-window nil)
    	  )
      ))
  )
)

;; This function evaluates an object for whether it is a valid workspace object or not.
(defun workspace-state-p (workspace)
  (and
   (= (length workspace) 6)
   (eq (car (nth 0 workspace)) 'type)
   (string= (cdr (nth 0 workspace)) "Workspace")
   (eq (car (nth 1 workspace)) 'window-list)
   (eq (car (nth 2 workspace)) 'window-frame)
   (eq (car (nth 3 workspace)) 'buffer-list)
   (eq (car (nth 4 workspace)) 'tab-bar-mode)
   (eq (car (nth 5 workspace)) 'file-explorer-mode)
   )
)

;; This function get the current workspace state as an S-Expression
(defun get-workspace-state-mx ()
  (let (
	frame-name frame-obj
	(selected (selected-frame))
	(initial-name (frame-parameter selected 'name))
	)

    (setq frame-name (read-from-minibuffer (format "Which frame do you want to save as the workspace (%s): " initial-title) initial-title nil nil (frame-history . 1) nil nil))

    (if (string= frame-name "")
	(setq frame-obj selected)
        (setq frame-obj (seq-find (lambda (frame) (string= (frame-parameter frame 'name) frame-name)) (frame-list)))
        )

    (if (null frame-obj)
	(identity frame-obj)
        (get-workspace-state frame-obj)
      )
))

;; This function get the current workspace state as an S-Expression.
(defun get-workspace-state (&optional frame)
  (when (null frame)
    (setq frame 'visible)
    )
  (let (
	wrkspc
	buflist
	(all-windows (window-list-1 nil "exclude-minibuf" frame))
	(all-buffers (buffer-list))
	)
    (if (> (length (frame-list)) 1)
	(get-workspace-state-mx)

        (progn
          (dolist (buf all-buffers)
            (let ((bufname (buffer-name buf)))
              (when (and
	  	     ;; Buffer is not in the current frame as a window (windows are recorded separately),
		     (null (get-buffer-window-list buf "exclude-minibuf" frame))
		     ;; is not a minibuffer,
		     (not (minibufferp buf))
		     ;; is not an Echo Area,
		     (not (string-prefix-p " *Echo Area " bufname))
		     ;; is not the GNU Emacs Startup screen,
		     (not (string= bufname "*GNU Emacs*"))
		     ;; is not the Completions list,
		     (not (string= bufname "*Completions*"))
		     ;; is not the Buffer List.
		     (not (string= bufname "*Buffer List*"))
		     )
	        (push buf buflist)
	        )
              )
            )

          (push (cons 'file-explorer-mode file-explorer-active) wrkspc)
	  (push (cons 'tab-bar-mode       tab-bar-active)       wrkspc)
          (push (cons 'buffer-list        buflist)              wrkspc)
	  (push (cons 'window-frame       frame)                wrkspc)
          (push (cons 'window-list        all-windows)          wrkspc)
          (push (cons 'type               "Workspace")          wrkspc)

          (identity wrkspc)
	  )
    )
))
;; This function get an empty workspace state.
(defun get-empty-workspace-state ()
  (let (wrkspc)
    (push (cons 'file-explorer-mode nil)                                 wrkspc)
    (push (cons 'tab-menu-mode      nil)                                 wrkspc)
    (push (cons 'buffer-list        nil)                                 wrkspc)
    (push (cons 'window-frame       nil)                                 wrkspc)
    (push (cons 'window-list        (cons (get-buffer "*scratch*") nil)) wrkspc)
    (push (cons 'type               "Workspace")                         wrkspc)

    (identity wrkspc)
    )
)
;; This function saves the current workspace state as the global one to be stored (dumped)
;; into the project directory or .neomacs/last-workspace.
(defun save-workspace-state ()
  (setq-default current-workspace-state (get-workspace-state))
)
;; This function dumps the current workspace state to a file (default is
;; (file-name-concat current-project-path ".neomacs/.workspace") if omitted).
(defun dump-workspace-state (&optional output workspace)
  "Dump the current workspace file to a buffer or as a string object.
  If `workspace' is omitted or nil, it is the current workspace.
  If 'output' is omitted, nil, or the symbol 'as-text, the generated output is returned as text.
  If 'output' is the symbol 'project, the generated output is dumped into the current project's workspace file.
  If 'output' is non-nil it is interpretted as a file stream or buffer, and is passed through to
  the princ function to print the generated output to the specified stream or buffer."

  (if (null workspace)
    (setq workspace (get-workspace-state))
  (when (workspace-state-p workspace)
    (let ((text "{\n\t\"type\": \"Workspace\",\n\t\"window-list\": [\n\t\t") len i obj)
      (setq obj (cdr (nth 1 workspace)))
      (setq len (length obj))
      (setq i   0)
      (dolist (window obj)
	(if (= i 0)
	    (setq text (concat text (window-to-string window)))
	    (setq text (format "%s,\n\n\t%s" text (window-to-string window)))
	    )
	)

      (setq text (format "%s\n\t],\n\t\"window-frame\": %s,\n\t\"buffer-list\": [\n\t\t" text (frame-to-string (cdr (nth 2 workspace)))))

      (setq obj (cdr (nth 3 workspace)))
      (setq len (length obj))
      (setq i   0)
      (dolist (buffer obj)
	(if (= i 0)
	    (setq text (concat text (buffer-to-string buffer)))
	    (setq text (format "%s,\n\n\t%s" text (buffer-to-string buffer)))
	    )
	)

      (setq text (format "%s\n\t],\n\t\"tab-bar-mode\": %s,\n\t\"file-explorer-mode\": %s\n}" text (bool-to-string (cdr (nth 4 workspace))) (bool-to-string (cdr (nth 5 workspace)))))

      (if (or (null output) (eq output 'as-text))
  	  (identity text)
      (if (eq output 'project)
	  (progn
	    ;; Output to project workspace file.
	    (when (not (null current-project-path))
	      (setq obj (expand-file-name ".neomacs/.workspace" current-project-path))
	      (write-region (format "\n%s\n" text) nil obj)
	      )
	    (identity text)
	    )
	  (progn
	    (princ text output)
	    (identity text)
	    )
	  ))
      )
  ))
)

(defun neomacs/debug-last-editor ()
  (interactive)
  "Display the last-used editor window in *Messages*."

  (message "Neomacs: Last Editor - %s" last-editor-window)
)

;; TESTING TO-DOs:
;; 1. Test the buffer lists generated for workspace state.
;; 2. Test the window lists generated for workspace state.
;; 3. Create and test function frame-to-string.
;; 4. Create and test function window-to-string.
;; 5. Create and test function buffer-to-string.
;; 6. Test workspace-state-p.
;; 7. Test dump-workspace-state.
