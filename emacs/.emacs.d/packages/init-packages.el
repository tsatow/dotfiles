(use-package color-theme-sanityinc-tomorrow
  :ensure t
  :config
  (load-theme 'sanityinc-tomorrow-blue t))

(use-package open-junk-file
  :ensure t)

(use-package treesit-auto
  :ensure t
  :config
  (setq treesit-auto-install t)
  (global-treesit-auto-mode))

(use-package projectile
  :ensure t
  :diminish
  :custom
  (projectile-switch-project-action 'projectile-dired)
  :config
  (projectile-mode +1)
  (projectile-global-mode)
  (setq projectile-completion-system 'ivy)

  (when (executable-find "ghq")
    (setq projectile-known-projects
          (mapcar
           (lambda (x) (abbreviate-file-name x))
           (split-string (shell-command-to-string "ghq list --full-path")))))
  :bind-keymap
  ("C-c p" . projectile-command-map))

(leaf font-for-gui
  :doc "Use Nerd & Adjust font size"
  :if (window-system)
  :preface
  (defun set-fonts (family)
    (set-fontset-font t 'japanese-jisx0208 (font-spec :family family))
    (set-fontset-font t 'japanese-jisx0212 (font-spec :family family))
    (set-fontset-font t 'jisx0201         (font-spec :family family))
    (set-fontset-font t 'kana             (font-spec :family family))
    (set-fontset-font t 'latin  (font-spec :family family))
    (set-fontset-font t 'greek  (font-spec :family family))
    (set-fontset-font t 'arabic (font-spec :family family))
    (set-fontset-font t 'symbol (font-spec :family family)))
  :custom
  (use-default-font-for-symbols   . nil)
  (inhibit-compacting-font-caches . t)
  (jp-font-family      . "SF Mono Square")
  (default-font-family . "FuraCode Nerd Font")
  :config
  (set-fonts jp-font-family)
  (set-face-attribute 'default nil :family jp-font-family :height 140))

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p)
  :config
  (all-the-icons-install-fonts t))

(use-package neotree
  :ensure t
  :init
  (require 'conf-neotree)
  :requires
  all-the-icons
  :config
  (conf-neotree)
  :bind
  ("C-'" . neotree-toggle)
  ("C-M-'" . neotree-project-dir)
  :bind-keymap
  :custom
  (setq neo-theme 'classic))


(use-package counsel
  :ensure t)

(use-package ivy
  :ensure t
  :bind (("C-c u" . ivy-resume))
  :config
  (ivy-mode)

  ;;(bind-chords
  ;; :map ivy-minibuffer-map
  ;; ("m," . ivy-beginning-of-buffer)
  ;; (",." . ivy-end-of-buffer))

  (setq ivy-use-virtual-buffers t
        ivy-height 13
        ivy-count-format "%d/%d "
        ivy-virtual-abbreviate 'full ; Show the full virtual file paths
        ivy-extra-directories nil ; default value: ("../" "./")
        ivy-wrap t
        ivy-action-wrap t
        ivy-use-selectable-prompt t)

  ;; modify default search behaviour of ivy
  (setq ivy-re-builders-alist
        '((t . ivy--regex-plus)))

  (bind-keys
   :map ivy-occur-grep-mode-map
   ("n" . ivy-occur-next-line)
   ("p" . ivy-occur-previous-line)
   ("b" . backward-char)
   ("f" . forward-char)
   ("v" . ivy-occur-press) ; default f
   ("RET" . ivy-occur-press)))

;; Better experience with icons for ivy
;; https://github.com/seagle0128/all-the-icons-ivy-rich/
(use-package all-the-icons-ivy-rich :defer 1
  :ensure t
  :config
  (all-the-icons-ivy-rich-mode 1)
  (setq all-the-icons-ivy-rich-icon-size 0.8))

;; More friendly interface for ivy
;; https://github.com/Yevgnen/ivy-rich
(use-package ivy-rich
  :ensure t
  :hook (counsel-mode . ivy-rich-mode)
  :config
  (ivy-rich-mode 1)
  ;; For better performance
  ;; Better experience with icons
  (setq ivy-rich-parse-remote-buffer nil))

(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  (global-set-key (kbd "C-M->") 'mc/mark-next-word-like-this)
  (global-set-key (kbd "C-M-<") 'mc/mark-previous-word-like-this)
  (global-set-key (kbd "C-c C-M-<") 'mc/mark-all-word-like-this))

;; markdownコマンドが必須
;; `C-c C-c l`でEmacs内でlive preview
;; `C-c C-c p`でブラウザでlive preview
(use-package markdown-mode
  :ensure t)
(use-package markdown-preview-mode
  :ensure t
  :config
  (setq markdown-preview-stylesheets (list "github.css")))

(use-package yaml-mode
  :ensure t)

(use-package toml-mode
  :ensure t)

(provide 'init-packages)
