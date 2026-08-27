
(load-file (expand-file-name "s.el/s.el" (file-name-directory load-file-name)))

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))

(use-package dash)

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
   ;; (setq treemacs-buffer-name-function            #'treemacs-default-buffer-name
   ;;       treemacs-buffer-name-prefix              " *Treemacs-Buffer-"
   ;;       treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
   ;;       treemacs-deferred-git-apply-delay        0.5
   ;;       treemacs-directory-name-transformer      #'identity
   ;;       treemacs-display-in-side-window          t
   ;;       treemacs-eldoc-display                   'simple
   ;;       treemacs-file-event-delay                2000
   ;;       treemacs-file-extension-regex            treemacs-last-period-regex-value
   ;;       treemacs-file-follow-delay               0.2
   ;;       treemacs-file-name-transformer           #'identity
   ;;       treemacs-follow-after-init               t
   ;;       treemacs-expand-after-init               t
   ;;       treemacs-find-workspace-method           'find-for-file-or-pick-first
   ;;       treemacs-git-command-pipe                ""
   ;;       treemacs-goto-tag-strategy               'refetch-index
   ;;       treemacs-header-scroll-indicators        '(nil . "^^^^^^")
   ;;       treemacs-hide-dot-git-directory          t
   ;;       treemacs-hide-dot-jj-directory           t
   ;;       treemacs-indentation                     2
   ;;       treemacs-indentation-string              " "
   ;;       treemacs-is-never-other-window           nil
   ;;       treemacs-max-git-entries                 5000
   ;;       treemacs-missing-project-action          'ask
   ;;       treemacs-move-files-by-mouse-dragging    t
   ;;       treemacs-move-forward-on-expand          nil
   ;;       treemacs-no-png-images                   nil
   ;;       treemacs-no-delete-other-windows         t
   ;;       treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
   ;;       treemacs-position                        'left
   ;;       treemacs-read-string-input               'from-child-frame
   ;;       treemacs-recenter-distance               0.1
   ;;       treemacs-recenter-after-file-follow      nil
   ;;       treemacs-recenter-after-tag-follow       nil
   ;;       treemacs-recenter-after-project-jump     'always
   ;;       treemacs-recenter-after-project-expand   'on-distance
   ;;       treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
   ;;       treemacs-project-follow-into-home        nil
;; ;;  ;;;;;;  ;;  ;;   treemacs-show-cursor                     nil
;;;;;;;;;;;;   ;;       treemacs-show-hidden-files               t
   ;;       treemacs-silent-filewatch                nil
   ;;       treemacs-silent-refresh                  nil
   ;;       treemacs-sorting                         'alphabetic-asc
   ;;       treemacs-select-when-already-in-treemacs 'move-back
   ;;       treemacs-space-between-root-nodes        t
   ;;       treemacs-tag-follow-cleanup              t
   ;;       treemacs-tag-follow-delay                1.5
   ;;       treemacs-text-scale                      nil
   ;;       treemacs-user-mode-line-format           nil
   ;;       treemacs-user-header-line-format         nil
   ;;       treemacs-wide-toggle-width               70
   ;;       treemacs-width                           35
   ;;       treemacs-width-increment                 1
   ;;       treemacs-width-is-initially-locked       t
   ;;       treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil))
  :bind
  ;;(:map global-map
  ;;      ("M-0"       . treemacs-select-window)
  ;;      ("C-x t 1"   . treemacs-delete-other-windows)
  ;;      ("C-b"       . treemacs)
  ;;      ("C-t SPC"   . treemacs-select-directory)
  ;;      ("C-t B"     . treemacs-bookmark)
  ;;      ("C-t C-f"   . treemacs-find-file)
  ;;      ("C-t M-f"   . treemacs-find-tag))
  )

(use-package multiple-cursors)

;;(global-unset-key (kbd "M-<down-mouse-1>"))
;;(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

;;(global-set-key (kbd "M-c") 'set-rectangular-region-anchor)
(global-set-key (kbd "M-9") 'mc/edit-lines)

;;(use-package treemacs-evil
;;  :after (treemacs evil)
;;  :ensure t)

;;(use-package treemacs-projectile
;;  :after (treemacs projectile)
;;  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

;;(use-package treemacs-magit
;;  :after (treemacs magit)
;;  :ensure t)

;;(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
;;  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
;;  :ensure t
;;  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))

(treemacs-start-on-boot)
(treemacs)

(load-file (expand-file-name "treemacs-interop.el" (file-name-directory load-file-name)))

(load-file (expand-file-name "funcs/split.el" (file-name-directory load-file-name)))
(load-file (expand-file-name "funcs/util.el" (file-name-directory load-file-name)))
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
(setq-default use-dialog-box nil)
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
(global-unset-key (kbd "C-x C-f"))
(global-set-key (kbd "C-x C-f") file-options-keymap)
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
(global-set-key (kbd "C-o") 'neomacs/find-file) ;; 'neomacs/find-file
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
(defvar-keymap direx-keymap
  ;;; Open Directory
  "j"   #'direx:jump-to-directory
  )
(global-set-key (kbd "C-d") direx-keymap)
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


(message user-emacs-directory)
