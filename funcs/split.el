
(defun split-window-left ()
  "Split the current window to the left."
  (interactive)

  (split-window nil nil 'left nil)
)

(defun split-window-right ()
  "Split the current window to the right."
  (interactive)

  (split-window nil nil t nil)
)

(defun split-window-up ()
  "Split the current window upwards."
  (interactive)

  (split-window nil nil 'above nil)
)

(defun split-window-down ()
  "Split the current window downwards."
  (interactive)

  (split-window nil nil nil nil)
)

(defun split-window-left-and-select ()
  "Split the current window to the left."
  (interactive)

  (split-window nil nil 'left nil)
  (windmove-left)
)

(defun split-window-right-and-select ()
  "Split the current window to the right."
  (interactive)

  (split-window nil nil t nil)
  (windmove-right)
)

(defun split-window-up-and-select ()
  "Split the current window upwards."
  (interactive)

  (split-window nil nil 'above nil)
  (windmove-up)
)

(defun split-window-down-and-select ()
  "Split the current window downwards."
  (interactive)

  (split-window nil nil nil nil)
  (windmove-down)
)
