
(defun bool-to-string (obj)
  (if obj
      (identity "True")
      (identity "False")
  )
)

(defun indent-lines (text &optional indent-depth start-line end-line include-empty-lines)
  "Indent all lines in a string 'text' to a depth of 'indent-depth' starting on line 'start-line', and ending on line 'end-line'.
  If `indent-depth' is nil, omitted, or not a number, it is defaulted to 1, if `start-line' and 'end-line' are ommitted. nil, or
  not a number, the entire text is idented accordingly, if just 'end-line' is omitted, nil, or not a number, all lines in the text
  starting at 'start-line' are indented accordingly. The parameter 'include-empty-lines' is interpretted in a boolean fashion to
  denote whether to indent empty lines accordingly as well, or should be ignored, defaults to false (nil), including if omitted."
  (let (
	(final-text "")
	(lines (if include-empty-lines (split-string text "\n") (split-string text "\n+" t)))
	)
    (dolist (line lines)
      
      )
    )
)
