
(load-file (expand-file-name "funcs/split.el" (file-name-directory load-file-name)))
(load-file (expand-file-name "funcs/fileopt.el" (file-name-directory load-file-name)))
(load-file (expand-file-name "term.el" (file-name-directory load-file-name)))
;;(load-file (expand-file-name "workspace.el" (file-name-directory load-file-name)))
;;(load-file (expand-file-name "projects.el" (file-name-directory load-file-name)))
;; Move backup files (~<filename>) to .emacs.d/backups.
(setq backup-directory-alist `((".*" ., (expand-file-name "backups" user-emacs-directory))))
;; Redirect auto-save files (#<filename>#) to .emacs.d/autosaves.
(setq auto-save-file-name-transforms `((".*", (expand-file-name "autosaves" user-emacs-directory) t)))
;; Disable lock files entirely.
(setq create-lockfiles nil)
;; The Core Configurations of neomacs
;; Toolbar (default: DISABLED)
(tool-bar-mode -1)
;; Menubar (default: DISABLED)
(menu-bar-mode -1)
;; Scrollbar (default: DISABLED)
(scroll-bar-mode -1)
;; Electric pair (parentheses and brackets will be typed as pairs
;; whenever the opening character of the pair is typed) (default: ENABLED)
(electric-pair-mode 1)
;; Show Parenthesis (parenthesis and brackets are highlighted in pairs
;; to distinguish opening and closing characters from others) (default: ENABLED)
(show-paren-mode 1)
;; Add line numbering globally by default
(global-display-line-numbers-mode)
;; Set global default cursor type to bar mode
(setq-default cursor-type 'bar)
;; This is a common fix for reducing the amount that a buffer is improperly drawn as a result
;; of scrolling.
(add-hook 'isearch-update-post-hook 'redraw-display)
;; KEYBINDS
;; Split-window navigation (up, down, left, right)
(global-set-key (kbd "C-x C-<up>") 'windmove-up)
(global-set-key (kbd "C-x C-<down>") 'windmove-down)
(global-set-key (kbd "C-x C-<right>") 'windmove-right)
(global-set-key (kbd "C-x C-<left>") 'windmove-left)
;; Kill Buffer Rebind (C-x k => C-k)
(global-unset-key (kbd "C-k"))
(global-set-key (kbd "C-k") 'kill-buffer)
(global-unset-key (kbd "C-x k"))
;; FILE OPTIONS KEYBINDS
(defvar-keymap file-options-keymap
  ;;; Delete File and Current Buffer
  "C-<delete>" #'delete-file-and-buffer
  ;;; Delete File and Keep Current Buffer
  "M-<delete>" #'delete-file-keep-buffer
  )
;; Prefix key for FILE OPTIONS KEYBINDS (C-f):
(global-set-key (kbd "C-f") file-options-keymap)
;; COPY/PASTE/CUT
;;; Copy (C-c)
(global-unset-key (kbd "C-c"))
(global-set-key (kbd "C-c") 'kill-ring-save)
(global-unset-key (kbd "M-w"))
;;; Cut (C-S-c)
(global-set-key (kbd "C-S-c") 'kill-region)
(global-unset-key (kbd "C-w"))
;;; Paste (C-v)
(global-set-key (kbd "C-v") 'yank)
(global-unset-key (kbd "C-y"))
;;; Cycle through clipboard after paste 
(global-set-key (kbd "C-S-v") 'yank-pop)
(global-unset-key (kbd "M-y"))
;; SAVE/OPEN/SAVE AS/NEW
;;; Save (C-s)
(global-set-key (kbd "C-s") 'save-buffer)
(global-unset-key (kbd "C-x C-s"))
;;; Save As (C-S-s)
(global-set-key (kbd "C-S-s") 'write-buffer)
(global-unset-key (kbd "C-x C-w"))
;;; Open (C-o)
(global-set-key (kbd "C-o") 'find-file)
(global-unset-key (kbd "C-x C-f"))
;;; Insert File (emacs default)
;;(global-set-key (kbd "C-x i") 'insert-file)
;;; OPENING OPTIONS KEYBINDS
(defvar-keymap open-options-keymap
  ;;; Open Directory
  "d"   #'dired
  ;;; List Open Buffers
  "l"   #'list-buffers
  ;;; Switch to an Open Buffer
  "SPC" #'switch-to-buffer
  )
;; Prefix key for OPENING OPTIONS KEYBINDS (C-x C-o):
(global-set-key (kbd "C-x C-o") open-options-keymap)
;;; Quit and Save (Rebind to C-q from C-x C-c)
(global-set-key (kbd "C-q") 'save-buffers-kill-emacs)
(global-unset-key (kbd "C-x C-c"))
;; WINDOW OPTIONS KEYBINDS
(defvar-keymap window-options-keymap
  ;;; Close Current Window (Leave Buffer Open)
  "C-c" #'delete-window
  ;;; Close All Other Windows (Leave Buffers Open)
  "C-k" #'delete-other-windows
  ;;; Split Vertically
  "C-<up>" #'split-window-up-and-select
  "C-<down>" #'split-window-down-and-select
  "C-S-<up>" #'split-window-up
  "C-S-<down>" #'split-window-down
  ;;; Split Horizontally
  "C-<left>" #'split-window-left-and-select
  "C-<right>" #'split-window-right-and-select
  "C-S-<left>" #'split-window-left
  "C-S-<right>" #'split-window-right
  ;;; Switch Windows
  "C-SPC" #'other-window
  )
;; Prefix key for WINDOW OPTIONS KEYBINDS (C-w):
(global-set-key (kbd "C-w") window-options-keymap)
;; UNDO
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z") 'undo)
(global-unset-key (kbd "C-_"))
(global-unset-key (kbd "C-/"))
;; REDO
(global-set-key (kbd "C-y") 'redo)
;; Open Terminal in current directory
(global-set-key (kbd "C-\\") 'open-terminal-here)
;; Open Terminal in the home directory
(global-set-key (kbd "C-`") 'open-terminal-home)

(load-file (expand-file-name "workspace.el" (file-name-directory load-file-name)))

;;(add-hook 'window-state-change-functions 'editor-history/window-state-change-listener)

(defun workspace/test1 ()
  (interactive)
  (if (is-editor-window (selected-window))
      (message "Is An Editor Window!")
      (message "Is Not An Editor Window!")
      )
)
(defun workspace/test2 ()
  (interactive)
  (dolist (editor last-editor-history)
    (message "Editor: %s" (buffer-name (window-buffer editor)))
    (sit-for 1.0)
  )
)
