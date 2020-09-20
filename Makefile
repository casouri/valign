test:
	emacs -Q -l ./valign.el --eval \
'(progn (find-file "./test.org") (valign-mode) (variable-pitch-mode))'

bar:
	emacs -Q -l ./valign.el --eval \
'(progn (find-file "./test.org") (setq valign-fancy-bar t) (valign-mode) (variable-pitch-mode))'

indent:
	emacs -Q -l ./valign.el --eval \
'(progn (setq org-startup-indented t) (find-file "./test.org") (valign-mode) (variable-pitch-mode) (goto-char (point-max)))'

mono:
	emacs -Q -l ./valign.el --eval \
'(progn (find-file "./test.org") (valign-mode))'
