;; init.el -- emacs configuration

;; INSTALL PACKAGES
;; ---------------------------------------------------------
(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    elpy
    exec-path-from-shell
    flycheck
    material-theme
    py-autopep8
    yaml-mode))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      myPackages)

;; BASIC CUSTOMIZATION
;; ---------------------------------------------------------
(setq inhibit-startup-message t) ;; hide startup msg
(load-theme 'material t)
(global-linum-mode t)

(defvar basicPackages
  '(fill-column-indicator
    neotree
    all-the-icons))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      basicPackages)

;; Font
(set-frame-font "Inconsolata for Powerline 16" nil t)

;; All-The-Icons
(require 'all-the-icons)

;; Neotree
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq neo-window-fixed-size 'nil)
(setq neo-smart-open t)

;; Whitespace Line
(require 'fill-column-indicator)
(setq-default fill-column 80)
(add-hook 'after-change-major-mode-hook 'fci-mode)

;; Python CONFIGURATIONS
;; ---------------------------------------------------------
(elpy-enable)

;; Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Autopep8
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; Exec-path-from-shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-copy-env "PYTHONPATH")
  (exec-path-from-shell-initialize))

(elpy-use-ipython)

;; JAVASCRIPT SETTINGS
;; ---------------------------------------------------------

;; Install JS Packages
(defvar jsPackages
  '(auto-complete
    js2-mode
    js2-refactor
    json-mode
    tern
    tern-auto-complete
    yasnippet))
(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      jsPackages)

;; associating json with js-mode
;;(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
(add-hook 'json-mode-hook #'flycheck-mode)

(add-hook 'js-mode-hook 'js2-minor-mode)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(setq js2-highlight-level 3)

;; yasnippet
;; should be loaded before auto complete so that they can work together
(require 'yasnippet)
(yas-global-mode 1)

;; auto complete mod
;; should be loaded after yasnippet so that they can work together
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))

(defun delete-tern-process ()
  (interactive)
  (delete-process "Tern"))
;; set the trigger key so that it can work together with yasnippet on tab key,
;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;; activate, otherwise, auto-complete will
(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

;;(define-key js-mode-map "{" 'paredit-open-curly)
;;(define-key js-mode-map "}" 'paredit-close-curly-and-newline)

;; SQL SETTINGS
;; ---------------------------------------------------------
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)))

;; SERVERS
(setq sql-connection-alist
      '((vagrant-agency (sql-product 'postgres)
                        (sql-port 5434)
                        (sql-server "localhost")
                        (sql-user "")
                        (sql-database "agency"))
        (vagrant-portals (sql-product 'postgres)
                           (sql-port 5434)
                           (sql-server "localhost")
                           (sql-user "")
                           (sql-password "")
                           (sql-database "portals-replica"))
        (portals-develop (sql-product 'postgres)
                         (sql-port 5432)
                         (sql-server "")
                         (sql-user "")
                         (sql-password "")
                         (sql-database ""))))

(defun sql-portals-develop ()
  (interactive)
  (cai/connect-to-sql 'postgres 'portals-develop))

(defun sql-vagrant-agency ()
  (interactive)
  (cai/connect-to-sql 'postgres 'vagrant-agency))

(defun sql-vagrant-portals ()
  (interactive)
  (cai/connect-to-sql 'postgres 'vagrant-portals))

(defun cai/connect-to-sql (product connection)
  (setq sql-product product)
  (sql-connect connection))

;;(Set sql-postgres-login-params (append sql-postgres-login-params '(port)))

;; LANGUAGE SETTINGS
;; ---------------------------------------------------------
(setq mac-command-modifier 'meta
      mac-option-modifier 'none
      default-input-method "MacOSX")

;; init.el end
;; ----------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (fill-column-indicator elpy material-theme better-defaults))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
