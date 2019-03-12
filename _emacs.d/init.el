;; init.el --- Emacs startup configuration

;;; Commentary:
;;; Well, Emacs config, u know?

;;; Code:
(package-initialize)

;; Start fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Set theme early if already installed
(if (package-installed-p 'flatland-theme)
  (load-theme 'flatland t))

;; Setup package management
(require 'package)
(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("elpy" . "https://jorgenschaefer.github.io/packages/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Install and enable theme if not already installed
(unless (package-installed-p 'flatland-theme)
  (package-refresh-contents)
  (package-install 'flatland-theme)
  (load-theme 'flatland t))

;; Base settings
(setq-default left-fringe-width nil)
(setq-default indicate-empty-lines t)
(setq-default indent-tabs-mode nil)

(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq inhibit-startup-echo-area-message t)
(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(setq vc-follow-symlinks t)
(setq large-file-warning-threshold nil)
(setq split-width-threshold nil)
(setq custom-safe-themes t)
(setq tab-width 4)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq ring-bell-function 'ignore)

(column-number-mode t)
(global-linum-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(show-paren-mode 1)

(when (boundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; Auto update packages
(use-package auto-package-update
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t
        auto-package-update-interval 7)
  (auto-package-update-maybe))

;; Jump between windows with Shift-Arrows
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Show bad whitespaces
(require 'whitespace)
(global-whitespace-mode)
(progn
  (setq whitespace-display-mappings '(
    (space-mark 32 [183] [46])
    (newline-mark 10 [182 10])
    (tab-mark ?\t [?» ?\t] [?\\ ?\t]))))

;; General
(use-package general
  :ensure t)

;; Set PATH from shell
(use-package exec-path-from-shell
  :ensure t
  :init
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; evil mode
(use-package evil
  :ensure t
  :init
  (setq evil-search-module 'evil-search)
  (setq evil-ex-complete-emacs-commands nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-shift-round nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode))

;; Powerline
(use-package powerline
  :ensure t
  :config
  (powerline-default-theme))

(use-package spaceline
  :ensure t
  :requires powerline
  :config
  (spaceline-spacemacs-theme))

;; which-key
(use-package which-key
  :ensure t
  :diminish ""
  :config
  (which-key-mode t))

;; ivy/cousel
(use-package counsel
  :ensure t)

(use-package ivy
  :ensure t
  :requires counsel
  :general
  ("C-s" 'swiper)
  ("M-x" 'counsel-M-x)
  ("C-x C-f" 'counsel-find-file)
  (:keymaps 'minibuffer-local-map
            "C-r" 'counsel-minibuffer-history)
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

;; org mode
(use-package org
  :ensure t
  :general
  ("\C-cl" 'org-store-link)
  ("\C-ca" 'org-agenda)
  ("\C-cc" 'org-capture)
  ("\C-cb" 'org-switchb)
  :mode (("\\.org$" . org-mode))
  :ensure org-plus-contrib
  :config
  (custom-set-variables
    '(org-directory "~/Notes")
    '(org-agenda-files (list org-directory))))

(use-package org-bullets
  :ensure t
  :after org
  :hook (org-mode . org-bullets-mode))

;; projectile
(use-package projectile
  :ensure t
  :general
  (:keymaps 'projectile-mode-map
           (kbd "s-p") 'projectile-command-map
           (kbd "C-c p") 'projectile-command-map)
  :config
  (projectile-mode +1))

;; Dashboard
(use-package dashboard
  :ensure t
  :diminish dashboard-mode
  :config
  (setq dashboard-banner-logo-title
    (replace-regexp-in-string
      "\n" " "
      (shell-command-to-string "fortune -as -n80")))
  (setq dashboard-items '((recents   . 5)
                          (bookmarks . 5)
                          (projects  . 5)
                          (agenda    . 5)
                          (registers . 5)))
  (dashboard-setup-startup-hook))

;; Autocompletion
(use-package company
  :ensure t)

;; FlyCheck
(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode t))

;; TypeScript
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save-mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(use-package tide
  :ensure t
  :config
  (setq company-tooltip-align-annotations t)
  (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook #'setup-tide-mode))

;; Custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files (list org-directory))
 '(org-directory "~/Notes")
 '(package-selected-packages
   (quote
    (powerline org-plus-contrib flatland-theme use-package)))
 '(tabbar-separator (quote (0.2))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; init.el ends here
