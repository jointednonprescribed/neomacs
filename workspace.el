
(defvar current-workspace-state nil)

(defvar tab-bar-active nil)

(defvar file-explorer-active nil)

(defvar frame-history nil)

(defvar last-editor-history nil)

(defvar last-editor-window nil)

(defun editor-history-remove (&optional window)
  (let (new-list (i 0))
    (message "Called Remove Function!")
    (message "editor-history-remove Called with operand: %s" window)
    (message "--DUMP---")
    (workspace/dump-editor-cache)
    (message "---END DUMP---")
    (dolist (editor last-editor-history)
      (if (eq window editor) (message "%s excluded (%s)!" editor window))
      (if (window-live-p editor) (message "Window is live: %s!" editor))
      (if (and (window-live-p editor) (not (eq window editor)))
	  (progn
	    (message "Pushed Editor: %s" editor)
	    (push (nth i new-list) editor)
            (setq i (+ i 1))
	    )
	  )
      )
    (setq-default last-editor-history new-list)
    (setq last-editor-history new-list)
    (identity last-editor-history)
    )
)

(defun editor-history-add (window)
  (setq-default last-editor-history (remq window last-editor-history))
  (push window last-editor-history)
  (identity last-editor-history)
)

(defun editor-history-move-to-front (window)
  (let ((removed (remq window last-editor-history)))
    (setq-default last-editor-history removed)
    (setq last-editor-history removed)
    )
  (push window last-editor-history)
  (identity last-editor-history)
)

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

(defun editor-history/window-state-change-listener2 (window)
  (debug)
  (if (and (or (frame-live-p window) (window-live-p window))) ;; DEBUG: ADD CONDITION: (not (string= (buffer-name (window-buffer (frame-selected-window window))) "*Messages*"))
      (setq window (frame-selected-window window))
    )
  (message "Triggered Window State Changed!")
  ;; DEBUG
  (message "---PRE-CONDITION DUMP---")
  (workspace/dump-editor-cache)
  (message "---END PRE-CONDITION DUMP---")
  (if (is-editor-window window)
      (progn
        ;;(message "Buffer Made it to conditional: %s" (buffer-name (window-buffer (frame-selected-window window)))) ;; DEBUG
        (let ((buf (window-buffer window)) (oldbuf (window-old-buffer window)))
          ;; If switched buffers
          (if (and (eq window last-editor-window) (not (eq oldbuf buf)))
	      (progn
	        ;;(message "Triggered on switched buffers") ;; DEBUG
	        (let ((oldbuf-is-ed (is-editor-window oldbuf)) (buf-is-ed (is-editor-window buf)))
	          ;; If switching into a text buffer
	          (if (and (not oldbuf-is-ed) buf-is-ed)
  		      (editor-history-move-to-front window)
		  ;; Else, if switching away from a text buffer
	          (if (and oldbuf-is-ed (not buf-is-ed))
		      (editor-history-remove window)
	              (when (eq last-editor-window window)
		          (setq last-editor-window (nth 0 last-editor-history))
		          )
	  	      ))
	        ))
          ;; Else, if closed window
          ;;(if (null (window-live-p window))
	 ;;     (progn
	 ;;       ;;(message "Triggered on switched windows") ;; DEBUG
  	  ;;      (editor-history-remove window)
	 ;;       (when (eq last-editor-window window)
	;;	    (setq last-editor-window nil)
	  ;;	    )
	  ;;      )
          ;; Else, if changed focus
          (if (not (eq last-editor-window window))
	      (progn
		;; DEBUG
		(message "---PRE-CALL DUMP---")
		(workspace/dump-editor-cache)
		(message "---END PRE-CALL DUMP---")
		;; clears all not-live windows from the list
		(editor-history-remove)
	        ;; (message "Triggered on switched windows") ;; DEBUG
		(if (is-editor-window window)
		    (progn
  	              (editor-history-move-to-front window)
	              (setq-default last-editor-window window)
		      )
		    )
	        )
              ));;)
          )
        )
      )

  (identity nil)
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
(defun editory-history/window-state-change-listener/delegate (window)
  (funcall (symbol-function 'editory-history/window-state-change-listener) window)
)

(add-hook 'window-state-change-functions 'editor-history/window-state-change-listener)

(defun workspace-get-windows (&optional workspace)
  (if (null workspace) (setq workspace current-workspace-state))
  ;; only if it is not still nil, continue
  (if (and (not (null workspace)) (eq 'type (cdr (car workspace))) (string= "Workspace" (car (car workspace))))
      (nth 1 workspace)
      (identity nil)
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
(defun dump-workspace-state (&optional workspace output)
"Dump the current workspace file to a buffer or as a string object.
If 'output' is omitted, nil, or the symbol 'as-text, the generated output is returned as text.
If 'output' is non-nil it is interpretted as a file stream or buffer, and is passed through to
the princ function to print the generated output to the specified stream or buffer."

  (when (null workspace)
    (setq workspace (get-workspace-state))
    )

  (let ((text ""))
    

    (if (or (null output) (eq output 'as-text)))
  )
)

(defun neomacs/debug-last-editor ()
  (interactive)
  "Display the last-used editor window in *Messages*."

  (message "Neomacs: Last Editor - %s" last-editor-window)
)

;;(defun workspace/dump-editor-cache ()
;;  (interactive)
;;
;;  (dolist (editor last-editor-history)
;;    (message "Editor: %s" editor)
;;    )
;;)

;;(defun workspace/clear-editor-cache ()
;;  (interactive)
;;  (setq last-editor-history nil)
;;)

;;(defun test1 ()
;;  (let (new-window)
;;    (setq last-editor-window (selected-window))
;;    (setq new-window (split-window last-editor-window))
;;    (editor-history/window-state-change-listener new-window)
;;  )
;;)

;;(test1)


;;(let ((window (nth 0 (window-list (get-buffer "neomacs.el")))))
;;  (message "NEOMACS BUFFER: %s" window)
;;)
