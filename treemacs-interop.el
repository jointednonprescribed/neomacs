
(with-eval-after-load 'treemacs
  (define-key treemacs-mode-map [mouse-1] #'treemacs-single-click-expand-action))

;; TREEMACS KEYBINDS
(defvar-keymap treemacs-keymap
  "M-0"   #'treemacs-select-window
  "M-1"   #'treemacs-delete-other-windows
  "SPC"   #'treemacs-select-directory
  "B"     #'treemacs-bookmark
  "C-f"   #'treemacs-find-file
  "M-f"   #'treemacs-find-tag
)
(global-set-key (kbd "C-t") treemacs-keymap)
(global-set-key (kbd "C-b") 'treemacs)

;;(defun neomacs/switch-workspace ()
;;  (interactive)
;;  "Switches the current workspace based using treemacs-switch-workspace."

;;  (treemacs-do-switch-workspace)
;;)
;;(global-unset-key (kbd "C-c C-w s"))
;;(global-set-key (kbd "C-p") 'neomacs/switch-workspace)
;;(define-key key-translation-map (kbd "C-c C-w s") (kbd "C-p"))
(global-unset-key (kbd "C-p"))
(define-key global-map (kbd "C-p") 'treemacs-switch-workspace)

(defconst neomacs/treemacs-interop/user-path (expand-file-name "~/"))

(defun neomacs/compress-user-expansions (pathname)
    (when (string-prefix-p user-path pathname)
      (setq pathname (format "~/%s" (substring pathname (length user-path))))
      )
    (identity pathname)
)

(defun neomacs/get-find-file-dir ()
  (let ((path (treemacs-project->path (nth 0 (treemacs-workspace->projects (treemacs-current-workspace))))))
    (identity path)
    )
)

(defun neomacs/find-file ()
  (interactive)
  (let (input-path compressed-workspace-path (default-workspace-dir (neomacs/get-find-file-dir)) (user-path (expand-file-name "~/")))
    (when (not (string-suffix-p "/" default-workspace-dir))
      (setq default-workspace-dir (concat default-workspace-dir "/"))
      )
    (setq compressed-workspace-path (neomacs/compress-user-expansions default-workspace-dir))
    (setq input-path (read-file-name "Find file: " compressed-workspace-path nil nil nil nil))
    (if (or (string= input-path "") (null input-path))
	(find-file default-workspace-dir)
	(find-file (expand-file-name input-path default-workspace-dir))
	)
    )
)
