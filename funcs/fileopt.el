

(defun delete-file-and-buffer ()
  (interactive)
  (let ((filename buffer-file-name))
    (kill-current-buffer)
    (delete-file filename)
    ))

(defun delete-file-keep-buffer ()
  (interactive)
  (delete-file buffer-file-name)
  )
