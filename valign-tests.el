;;; valign-tests.el --- Render measurement regressions -*- lexical-binding: t; -*-

(require 'ert)
(require 'cl-lib)
(require 'valign)

(defun valign-test--align (text)
  "Align TEXT with deterministic mocked geometry and count pixel calls.
This checks measurement selection, not real GUI font geometry."
  (with-temp-buffer
    (insert text)
    (setq major-mode 'org-mode)
    (goto-char (point-min))
    (let ((calls 0))
      (cl-letf (((symbol-function 'window-text-pixel-size)
                 (lambda (_window from to &rest _)
                   (cl-incf calls)
                   (cons (string-width
                          (buffer-substring-no-properties from to)) 1)))
                ((symbol-function 'line-number-display-width)
                 (lambda (&rest _) 0))
                ((symbol-function 'valign--glyph-width-of)
                 (lambda (&rest _) 1)))
        (valign-table-1))
      (list calls (length (overlays-in (point-min) (point-max)))))))

(ert-deftest valign-test-left-render-skips-unused-width ()
  ;; Four discovery widths (8 calls) plus two row origins; no render widths.
  (should (= 10 (car (valign-test--align "| aaa | bbb |\n| ccc | ddd |\n")))))

(ert-deftest valign-test-right-render-retains-width ()
  ;; Four discovery AND four render widths, plus two row origins.
  (should (= 18 (car (valign-test--align "|  1 |  2 |\n|  3 |  4 |\n")))))

(ert-deftest valign-test-mixed-render-measures-only-right ()
  (should (= 14 (car (valign-test--align "| aaa |  2 |\n| ccc |  4 |\n")))))

(ert-deftest valign-test-left-render-preserves-overlays ()
  (should (> (cadr (valign-test--align "| aaa | bbb |\n| ccc | ddd |\n")) 0)))

(provide 'valign-tests)
;;; valign-tests.el ends here
