;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Bootstrap package system
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Startup performance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq gc-cons-threshold (* 50 1000 1000))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; UI sanity
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Evil (vim emulation)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "<wheel-up>")   #'evil-scroll-up)
  (define-key evil-normal-state-map (kbd "<wheel-down>") #'evil-scroll-down))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-terminal-cursor-changer
  :after evil
  :config
  (evil-terminal-cursor-changer-activate))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completion stack
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)))

(use-package marginalia
  :init (marginalia-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Consult
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("M-y"   . consult-yank-pop)
         ("C-s"   . consult-line)
	 ("C-c r" . consult-ripgrep)
	 ("C-c i" . consult-imenu)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Corfu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  :config
  (define-key corfu-map (kbd "TAB") #'corfu-next)
  (define-key corfu-map (kbd "<backtab>") #'corfu-previous))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Discoverability
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package which-key
  :defer 1
  :config (which-key-mode)
  :custom (which-key-idle-delay 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Git workflow
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package magit
  :commands magit-status
  :bind ("C-x g" . magit-status))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tree-sitter setup (automatic grammar install)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq treesit-language-source-alist
      '((typescript "https://github.com/tree-sitter/tree-sitter-typescript" "typescript/src")
        (tsx        "https://github.com/tree-sitter/tree-sitter-typescript" "tsx/src")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript")))

(defun my/ensure-treesit-grammars ()
  (dolist (lang '(typescript tsx javascript))
    (unless (treesit-language-available-p lang)
      (ignore-errors
        (treesit-install-language-grammar lang)))))

(add-hook 'emacs-startup-hook #'my/ensure-treesit-grammars)

;; File associations
(add-to-list 'auto-mode-alist '("\\.ts\\'"  . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package lsp-mode
  :commands lsp
  :hook ((typescript-ts-mode . lsp)
         (tsx-ts-mode        . lsp))
  :init
  (setq lsp-keymap-prefix "C-c l"
	lsp-enable-symbol-highlighting t
	lsp-headerline-breadcrumb-enable t))

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Inline diagnostics (modern default)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq flymake-show-diagnostics-at-end-of-line t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Formatting (optional prettier)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package prettier
  :hook ((typescript-ts-mode . prettier-mode)
         (tsx-ts-mode        . prettier-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Doom modeline
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer my/leader
    :states '(normal visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC")

  ;; Leader bindings
  (my/leader
    "SPC" '(execute-extended-command :wk "execute command")

    "b"  '(:ignore t :wk "buffers")
    "bb" '(consult-buffer :wk "switch buffer")

    "e"  '(:ignore t :wk "eval")
    "ec" '((lambda () (interactive) (load-file user-init-file)) :wk "reload config")
    "es" '(eval-last-sexp :wk "eval last sexp")

    "f"  '(:ignore t :wk "files")
    "fc" '((lambda () (interactive) (find-file user-init-file)) :wk "edit init.el")
    "ff" '(find-file :wk "find file")

    "g"  '(:ignore t :wk "git")
    "gs" '(magit-status :wk "status")

    "h"  '(:ignore t :wk "help")
    "hf" '(describe-function :wk "describe function")
    "hk" '(describe-key :wk "describe key")
    "ho" '(describe-symbol :wk "describe symbol")
    "hv" '(describe-variable :wk "describe variable")

    "l"  '(:ignore t :wk "lsp")
    "lr" '(lsp-rename :wk "rename")
    "la" '(lsp-execute-code-action :wk "code action")

    "s"  '(:ignore t :wk "search")
    "s/" '(consult-line :wk "search line")
    "sg" '(consult-ripgrep :wk "ripgrep")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Doom modeline
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package doom-modeline
  :init
  (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 25))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package doom-themes
  :config
  (load-theme 'doom-monokai-pro t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Startup behavior
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message nil)

(setq completion-ignore-case t
      read-file-name-completion-ignore-case t)

(use-package undo-fu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Restore sane GC after init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(consult corfu doom-modeline doom-themes evil-collection evil-mouse
	     evil-terminal-cursor-changer general lsp-ui magit
	     marginalia orderless prettier undo-fu vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
