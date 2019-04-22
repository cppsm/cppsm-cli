;;; cppsm --- summary

;;; commentary:

;;; code:

(require 'ansi-color)
(require 'comint)
(require 'subr-x)

(defun cppsm-project-directory-from (candidate)
  "Determine current project directory."
  (if (file-exists-p (concat candidate ".cppsm"))
      candidate
    (let ((parent (file-name-directory (directory-file-name candidate))))
      (unless (equal parent candidate)
        (cppsm-project-directory-from parent)))))

(defconst cppsm-buffer-name "*cppsm*")

(defun cppsm-run-command ())

(defun cppsm-test ()
  "Run `cppsm test` in the current project."
  (interactive)
  (if-let (default-directory (cppsm-project-directory-from default-directory))
      (progn
        (when-let ((buffer (get-buffer cppsm-buffer-name)))
          (kill-buffer buffer))
        (when-let ((process (start-process-shell-command
                             "cppsm-test"
                             (let ((buffer (get-buffer-create cppsm-buffer-name)))
                               (with-current-buffer buffer
                                 (comint-mode))
                               buffer)
                             "cppsm test")))
          (set-process-filter process 'comint-output-filter)
          (set-process-sentinel
           process
           (function (lambda (process event)
                       (message (string-trim event))
                       (when-let ((buffer (get-buffer "*cppsm*")))
                         (with-current-buffer buffer
                           (compilation-mode))))))))
    (message "Couldn't determine cppsm project directory.")))

(provide 'cppsm)
;;; cppsm ends here

(function (lambda () ))
