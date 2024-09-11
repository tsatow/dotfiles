;; treeバッファに行番号を表示しない
(add-hook 'neotree-mode-hook
          #'(lambda ()
              (display-line-numbers-mode -1)))

(defun neotree-project-dir ()
   "Open NeoTree using the git root."
    (interactive)
    (let ((project-dir (projectile-project-root))
          (file-name (buffer-file-name)))
      (neotree-toggle)
      (if project-dir
          (if (neo-global--window-exists-p)
              (progn
                (neotree-dir project-dir)
                (neotree-find file-name)))
        (message "Could not find git project root."))))

;; Change neotree's font size
;; Tips from https://github.com/jaypei/emacs-neotree/issues/218
(defun neotree-text-scale ()
  "Text scale for neotree."
  (interactive)
  (text-scale-adjust 0)
  (text-scale-decrease 1)
  (message nil))
(add-hook 'neo-after-create-hook
      (lambda (_)
        (call-interactively 'neotree-text-scale)))

;; neotree enter hide
;; Tips from https://github.com/jaypei/emacs-neotree/issues/77
(defun neo-open-file-hide (full-path &optional arg)
  "Open file and hiding neotree.
The description of FULL-PATH & ARG is in `neotree-enter'."
  (neo-global--select-mru-window arg)
  (find-file full-path)
  (neotree-hide))

(defun neotree-enter-hide (&optional arg)
  "Neo-open-file-hide if file, Neo-open-dir if dir.
The description of ARG is in `neo-buffer--execute'."
  (interactive "P")
  (neo-buffer--execute arg 'neo-open-file-hide 'neo-open-dir))

(defun conf-neotree ()
  "configure neotree."
  (interactive)
  (setq neo-smart-open t)
  (setq neo-show-hidden-files t)
  (setq neo-create-file-auto-open t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  ; (bind-key "RET" 'neotree-enter-hide neotree-mode-map) ; Enterでファイルを開いてもhideしない
  (bind-key "a" 'neotree-hidden-file-toggle neotree-mode-map)
  (bind-key "<left>" 'neotree-select-up-node neotree-mode-map))

;; default
;;  C-c C-n 作成
;;  C-c C-d 削除
;;  C-c C-r リネーム
;;  C-c C-p コピー
;; concise
;;  C ルートディレクトリ変更
;;  c 作成
;;  + 作成
;;  d 削除
;;  r リネーム
;;  e エンター
;; https://tam5917.hatenablog.com/entry/2024/07/07/154024
(setq neo-keymap-style 'concise)

;; よく使うディレクトリへのショートカット
(defun open-dotfiles-dir ()
  (interactive)
  (neotree-dir "~/src/github.com/tsatow/dotfiles"))
(defun open-reading-dir ()
  (interactive)
  (neotree-dir "~/src/github.com/tsatow/reading"))
(defun open-memo-dir ()
  (interactive)
  (neotree-dir "~/memo"))
open-memo-dir


(provide 'conf-neotree)
