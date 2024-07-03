(eval-and-compile
  (customize-set-variable
   'package-archives '(("org"   . "https://orgmode.org/elpa/")
                       ("melpa" . "https://melpa.org/packages/")
                       ("gnu"   . "https://elpa.gnu.org/packages/")))
  (package-initialize)
  (unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

  ;; Leaf keywords
  (leaf leaf-keywords
    :doc "Use leaf as a package manager"
    :url "https://github.com/conao3/leaf.el"
    :ensure t
    :init
    (leaf el-get
      :ensure t
      :custom
      (el-get-notify-type       . 'message)
      (el-get-git-shallow-clone . t))
    (leaf hydra :ensure t)
    :config
    (leaf-keywords-init)))

;; use-packageのパッケージ自動更新
;; 古いパッケージリストを元に取得しようとしてしまいファイルが見つからずfailすることが頻発しているため
(use-package auto-package-update
   :ensure t
   :config
   (setq auto-package-update-delete-old-versions t
         auto-package-update-interval 4)
   (auto-package-update-maybe))

;;;; ロードパスの追加
(setq load-path
  (append '("~/.emacs.d/themes" "~/.emacs.d/utils" "~/.emacs.d/packages") load-path))

;;;; 画面の表示設定
;;; スタートメッセージを表示しない
(setq inhibit-startup-message t)

;;; スクロールバーを非表示
(scroll-bar-mode -1)

;;; ツールバーを非表示
(tool-bar-mode -1)

;;; メニューバーを非表示
(menu-bar-mode -1)

;;; emacs-mac特有の設定例
;;; https://qiita.com/takaxp/items/6ec37f9717e362bef35f
(when (memq window-system '(mac ns))
  (setq initial-frame-alist
        (append
         '((ns-transparent-titlebar . t) ;; タイトルバーを透過
           (vertical-scroll-bars . nil) ;; スクロールバーを消す
           (ns-appearance . dark) ;; 26.1 {light, dark}
           (internal-border-width . 0))))) ;; 余白を消す
(setq default-frame-alist initial-frame-alist)

;;; デフォルトで文字折り返しなし
;;; see https://www.glamenv-septzen.net/view/358
(setq-default truncate-partial-width-windows t)
(setq-default truncate-lines t)

;;; 行番号表示
(global-display-line-numbers-mode)

;;; 現在行に色をつける
(global-hl-line-mode 1)
;; VSCodeのtomorrow-night-blueテーマでの<div class="current-line">のスタイルから拝借
(set-face-background 'hl-line "#00346e")

;;; 時間を表示
(display-time)

;;; 起動時のサイズを最大化
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
; (toggle-frame-maximized)
; (toggle-frame-fullscreen)

;;;; 操作の設定
;;; Macの場合にMetaキーを⌘にする
(when (eq system-type 'darwin)
  (setq ns-command-modifier (quote meta)))

;;; C-hをBackspaceに割り当て
(keyboard-translate ?\C-h ?\C-?)

;;; helpをC-?に割り当て
(global-set-key (kbd "C-?") 'help-for-help)

;;; バッファ末尾に余計な改行コードを防ぐための設定
(setq next-line-add-newlines nil)

;;; UTF-8を基本とする
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;;; タブ幅の設定。ただしタブか半角スペースかはプロジェクトに任せる。
(setq-default tab-width 2 indent-tabs-mode t)

;;; インデントにタブ文字を使用しない
(setq-default indent-tabs-mode nil)

;;; テキストを折り返しの切り替え設定
(global-set-key (kbd "C-c t") 'toggle-truncate-lines)

;;; ミニバッファで入力する際に自動的にASCIIにする
;; 注意: Emacs Mac Port 用設定
(when (fboundp 'mac-auto-ascii-mode)
  (mac-auto-ascii-mode 1))

;;; 質問をy/nで回答する
(fset 'yes-or-no-p 'y-or-n-p)

;;;; パッケージの初期化
(require 'init-packages)

;;;; utilityの初期化
(require 'init-utils)
