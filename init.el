;; Customize user interface.
(menu-bar-mode 0)
(when (display-graphic-p)
  (tool-bar-mode 0)
  (scroll-bar-mode 0))
(setq inhibit-startup-screen t)
(setq blink-cursor-mode nil)
(column-number-mode)

;; Dark theme.
(load-theme 'wombat)
(set-face-background 'default "#111")
(set-face-background 'cursor "red2")
(set-face-background 'isearch "#c60")
(set-face-foreground 'isearch "#eee")
(set-face-background 'lazy-highlight "#960")
(set-face-foreground 'lazy-highlight "#ccc")
(set-face-foreground 'font-lock-comment-face "#fc0")
(set-face-background 'trailing-whitespace "#555")

;; Interactively do things.
(ido-mode 1)
(ido-everywhere)
(setq ido-enable-flex-matching t)
(fido-mode)
(setq ido-show-dot-for-dired t)

;; Show stray whitespace.
(setq-default show-trailing-whitespace t)
(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

;; Consider a period followed by a single space to be end of sentence.
(setq sentence-end-double-space nil)

;; Use spaces, not tabs, for indentation.
(setq-default indent-tabs-mode nil)

;; Display the distance between two tab stops as 4 characters wide.
(setq-default tab-width 4)

;; Indentation setting for various languages.
(setq c-basic-offset 4)
(setq js-indent-level 2)
(setq css-indent-offset 2)

;; Highlight matching pairs of parentheses.
(setq show-paren-delay 0)
(show-paren-mode)

;; Write auto-saves and backups to separate directory.
(make-directory "~/.tmp/emacs/auto-save/" t)
(setq auto-save-file-name-transforms '((".*" "~/.tmp/emacs/auto-save/" t)))
(setq backup-directory-alist '(("." . "~/.tmp/emacs/backup/")))

;; Do not move the current file while creating backup.
(setq backup-by-copying t)

;; Disable lockfiles.
(setq create-lockfiles nil)

;; Workaround for https://debbugs.gnu.org/34341 in GNU Emacs <= 26.3.
(when (and (version< emacs-version "26.3") (>= libgnutls-version 30603))
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))

;; Write customizations to a separate file instead of this file.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file t)

;; Enable installation of packages from MELPA.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install packages.
(dolist (package '(markdown-mode magit
                   paredit rainbow-delimiters
                   ;ediprolog ;; elpa version too old, symlink from lisp/ to git
                   pipenv
                   evil evil-surround))
  (unless (package-installed-p package)
    (package-install package)))

(add-to-list 'load-path "~/.emacs.d/lisp")

;; Enable evil
(require 'evil)
(require 'evil-surround)
(evil-mode 1)
(global-evil-surround-mode 1)

;; Customize Prolog.
(require 'ediprolog)
(add-to-list 'auto-mode-alist '("\\.pl$" . prolog-mode))
(setq prolog-electric-if-then-else-flag t)

;; Customize Python.
(setq python-shell-interpreter "python3")
(add-hook 'python-mode-hook #'pipenv-mode)
(setq pipenv-projectile-after-switch-function #'pipenv-projectile-after-switch-extended)

;; Enable Paredit.
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)

;; Enable Rainbow Delimiters.
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'ielm-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-interaction-mode-hook 'rainbow-delimiters-mode)
(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)

;; Customize Rainbow Delimiters.
(require 'rainbow-delimiters)
(set-face-foreground 'rainbow-delimiters-depth-1-face "#c66")  ; red
(set-face-foreground 'rainbow-delimiters-depth-2-face "#6c6")  ; green
(set-face-foreground 'rainbow-delimiters-depth-3-face "#69f")  ; blue
(set-face-foreground 'rainbow-delimiters-depth-4-face "#cc6")  ; yellow
(set-face-foreground 'rainbow-delimiters-depth-5-face "#6cc")  ; cyan
(set-face-foreground 'rainbow-delimiters-depth-6-face "#c6c")  ; magenta
(set-face-foreground 'rainbow-delimiters-depth-7-face "#ccc")  ; light gray
(set-face-foreground 'rainbow-delimiters-depth-8-face "#999")  ; medium gray
(set-face-foreground 'rainbow-delimiters-depth-9-face "#666")  ; dark gray

;; Custom command.
(defun show-current-time ()
  "Show current time."
  (interactive)
  (message (current-time-string)))

(defun prolog-insert-comment-block ()
  "Insert a PceEmacs-style comment block like /* - - ... - - */ "
  (interactive)
  (let ((dashes "-"))
    (dotimes (_ 36) (setq dashes (concat "- " dashes)))
    (insert (format "/* %s\n\n%s */" dashes dashes))
    (forward-line -1)
    (indent-for-tab-command)))

(defun ediprolog-delete-results ()
  (interactive)
  (delete-region
   (move-beginning-of-line nil)
   (save-excursion
     (while (looking-at "^%@") (forward-line 1))
     (point)))
  (forward-line -1)
  (move-end-of-line nil))


;; Custom key sequences.
(global-set-key (kbd "C-c t") 'show-current-time)
(global-set-key (kbd "C-c d") 'delete-trailing-whitespace)
(global-set-key "\C-c\C-e" 'ediprolog-dwim)
(global-set-key [f10] 'ediprolog-dwim)
(global-set-key "\C-cq" 'prolog-insert-comment-block)
(global-set-key "\C-cd" 'ediprolog-delete-results)
(global-set-key "\C-cl" (lambda ()
                          (interactive)
                          (insert ":- use_module(library()).")
                          (forward-char -3)))
(global-set-key (kbd "s-;") (lambda () (interactive) (kill-whole-line -1)))


;; Start server.
(require 'server)
(unless (server-running-p)
  (server-start))


