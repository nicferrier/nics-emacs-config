;;; Nic's init file

(setq toggle-debug-on-error t)

;;; An attempt to make something that doesn't need so much work moving
;;; between machines

(defconst emacs-repos "~/emacs-packages")

(defmacro save-in-file (filename &rest body)
  "Save the Lisp BODY in the FILENAME."
  (declare (indent defun))
  (let ((buffer (make-symbol "buf")))
    `(let ((,buffer (find-file-noselect ,filename)))
       (with-current-buffer ,buffer
	 (erase-buffer)
	 (mapcar (lambda (f)
		   (print f (current-buffer)))
		 (quote ,body))
	 (save-buffer)))))

(defmacro comment (&rest forms))

;; This is the stuff that will be executed after the loading.
;; Put stuff in here to get it to happen after packages and all that
(save-in-file "~/emacs-packages/.after-init.el"
  (comment "Do not make changes to this file - make changes to init.el instead.")

  ;; after the other stuff has been done this can be called
  (add-to-list 'auto-mode-alist '("Dockerfile" . shell-script-mode))

  (require 'dired-x)
  (setq dired-omit-mode t)
  (setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..*$")
  (add-hook 'dired-mode-hook (lambda () (dired-omit-mode)))

  (setq shell-switcher-mode t)
  (define-key
    shell-switcher-mode-map
    (kbd "C-#") 'shell-switcher-switch-buffer)
  (define-key
    shell-switcher-mode-map
    (kbd "C-x 4 #") 'shell-switcher-switch-buffer-other-window)
  (define-key
    shell-switcher-mode-map
    (kbd "C-M-#") 'shell-switcher-new-shell)

  (setenv "GIT_PAGER" "cat")
  (setenv "PAGER" "cat")

  ;; Maybe this needs to go in JS mode hook
  (modify-syntax-entry ?` "\"" js-mode-syntax-table)

  ;; Frame stuff allows growing or shrinking frames
  (add-hook 'after-init-hook 'frame-font-keychord-init))

;; Add the hook
(add-hook
 'after-init-hook
 (lambda ()
   (condition-case err
       (load-file "~/emacs-packages/.after-init.el")
     (error (message "errors during init")))))


(defconst emacs-load-paths '()
  "Alist of load-paths keyed by repo-name.

The load-path before the repo was loaded.")

(defun list-copy (l) (mapcar 'identity l))

(defun pp-list (l)
  "Pretty print the symbol that you supply."
  (interactive "S")
  (with-current-buffer (get-buffer-create "*pp-lisp*")
    (erase-buffer)
    (pp (eval l) (current-buffer))
    (switch-to-buffer-other-window (current-buffer))))

(defun load-repo (repo-name)
  "Load the specified repo.
Argument REPO-NAME the name of the repository to add."
  (let* ((dir (expand-file-name repo-name emacs-repos))
	 (entries (directory-files dir t ".*\\.el$")))
    (mapc (lambda (entry)
	    (let* ((plain-name (file-name-sans-extension entry))
		   (elc-name (expand-file-name (concat plain-name ".elc"))))
	      (when (and
		     (file-exists-p elc-name)
		     (file-newer-than-file-p entry elc-name))
		(byte-compile-file entry))
	      ;; backup the load-path
	      (unless (assoc repo-name emacs-load-paths)
		(add-to-list
		 'emacs-load-paths
		 (cons repo-name (list-copy load-path))))
	      ;; update the load-path
	      (unless (memq dir load-path)
		(add-to-list 'load-path dir))
              (message "load-repo loading %s (%s - %s)" entry elc-name plain-name)
	      ;; Finally load the file
	      (condition-case err
		  (when (eq nil (string-match-p ".*/test[s]*.el[c]*$" elc-name))
		    ;;(update-file-autoloads entry)
		    (load-file entry))
		(error (message
			"init load-repo failed loading %s in %s with %s"
			(file-name-base entry)
			dir
			err)))))
	  entries)))


;; Now load a bunch of packages

(load-repo "paredit")
(load-repo "go-mode.el")
;;(load-repo "goflymake")
(load-repo "emacs-crystal-mode")
(load-repo "yaml-mode")
(load-repo "markdown-mode")
(load-repo "sql-postgres")
(load-repo "shell-switcher")
(load-repo "nics-crystal")
(load-repo "key-chord")
(load-repo "emacs-framesize")
(load-repo "nics-emacs-java")
(load-repo "nvm-emacs")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(emacs-lisp-mode-hook
   (quote
    (eldoc-mode checkdoc-minor-mode paredit-mode show-paren-mode)))
 '(indent-tabs-mode nil)
 '(menu-bar-mode nil)
 '(tool-bar-mode nil)
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; end init.el
