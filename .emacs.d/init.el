(setq load-path
      (append
       (list
        (expand-file-name "~/.emacs.d/elisp/"))
       load-path))

(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(prefer-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; auto-install
(require 'auto-install)
(setq auto-install-directory "~/.emacs.d/elisp/") ;Emacs Lispをインストールするディレクトリの指定
(auto-install-update-emacswiki-package-name t)
(auto-install-compatibility-setup) ;install-elisp.elとコマンド名を同期

;;(setq find-dired-find-program "c:\\cygwin\\bin\\find.exe")
;;(setq find-program "c:\\cygwin\\bin\\find.exe")

;; PHP debugger
;;(autoload 'geben "geben" "DBGp protocol front-end" t)
;; (add-to-list 'load-path "/opt/local/share/emacs/site-lisp/geben") ; Geben directory
;;(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/geben") ; Geben directory
;;(require 'geben)


;; anything
(require 'anything-startup)
;;(require 'anything)

;; (global-set-key (kbd "C-x b") 'anything)
(global-set-key (kbd "C-x a") 'anything)

(require 'anything-config)
(add-to-list 'anything-sources 'anything-c-source-emacs-commands)

;; auto-complete
(require 'auto-complete)
(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq ac-auto-start t)

;; php-mode
(require 'php-mode)
(autoload 'php-mode "php-mode" "Major mode for editing php code." t)


(setq php-mode-force-pear t) ;PEAR規約のインデント設定にする
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode)) ;*.phpのファイルのときにphp-modeを自動起動する

;; php-mode-hook
(add-hook 'php-mode-hook
          (lambda ()
            (require 'php-completion)
            (php-completion-mode t)
            (define-key php-mode-map (kbd "C-o") 'phpcmp-complete) ;php-completionの補完実行キーバインドの設定
            (make-local-variable 'ac-sources)
            (setq ac-sources '(
                               ac-source-words-in-same-mode-buffers
                               ac-source-php-completion
                               ac-source-filename
                               ))))


;;flymake
;; (require 'flymake)

;; (add-hook 'php-mode-hook
;;           '(lambda ()
;;              (flymake-mode t)))

;; Subversionプロントエンドpsvnの設定
(when (executable-find "svn")
  (setq svn-status-verbose nil)
  (autoload 'svn-status "psvn" "Run `svn status'." t))

;;--------------------------------------------------------------------------------
;; tabbar
;; (install-elisp "http://www.emacswiki.org/emacs/download/tabbar.el")
;;--------------------------------------------------------------------------------
(require 'tabbar)
(tabbar-mode 1)
;; タブ移動キーバインド設定
(global-set-key "\M-]" 'tabbar-forward)
(global-set-key "\M-[" 'tabbar-backward)
;;(global-set-key "\C-]" 'tabbar-forward)
;;(global-set-key "\C-[" 'tabbar-backward)

;; 左に表示されるボタンを無効化
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))

;; グループ化しない
(setq tabbar-buffer-groups-function nil)

;; タブ同士の間隔
(setq tabbar-separator '(0.8))
;; 外観変更
(set-face-attribute
 'tabbar-default nil
 :family (face-attribute 'default :family)
 :background (face-attribute 'mode-line-inactive :background)
 :height 0.9)
(set-face-attribute
 'tabbar-unselected nil
;; :background "gray90"
;; :foreground "black"
:background (face-attribute 'mode-line-inactive :background)
:foreground (face-attribute 'mode-line-inactive :foreground)
 :box nil)
(set-face-attribute
 'tabbar-selected nil
; :background "white"
; :background "skyblue"
 :background "pink"
 :foreground "black"
 :box nil)

;; タブscroll タブに表示させるファイル名の長さ設定
(setq tabbar-auto-scroll-flag t)
;;(setq tabbar-auto-scroll-flag nil)
(defvar my-tabbar-buffer-tab-label-limit 8
  "Limit width of each labels displayed on the tab bar.")


(defvar my-tabbar-displayed-buffers
  '("*scratch*" "*Messages*" "*Backtrace*" "*Colors*" "*Faces*" "*vc-")
  "*Regexps matches buffer names always included tabs.")

(defun my-tabbar-buffer-list ()
  "Return the list of buffers to show in tabs.
Exclude buffers whose name starts with a space or an asterisk.
The current buffer and buffers matches `my-tabbar-displayed-buffers'
are always included."
  (let* ((hides (list ?\  ?\*))
         (re (regexp-opt my-tabbar-displayed-buffers))
         (cur-buf (current-buffer))
         (tabs (delq nil
                     (mapcar (lambda (buf)
                               (let ((name (buffer-name buf)))
                                 (when (or (string-match re name)
                                           (not (memq (aref name 0) hides)))
                                   buf)))
                             (buffer-list)))))
    ;; Always include the current buffer.
    (if (memq cur-buf tabs)
        tabs
      (cons cur-buf tabs))))

(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)


;; ツールバー非表示
(tool-bar-mode nil)

;; メニューバーを非表示
(menu-bar-mode nil)

;; タイトルバーにファイルのフルパス表示
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))

;; 行番号表示
;;(global-linum-mode nil)

;; 括弧の範囲内を強調表示
(show-paren-mode t)
(setq show-paren-delay 0)
;;(setq show-paren-style 'expression)
(setq show-paren-style 'parenthesis)

;; 行末の空白を強調表示
(setq-default show-trailing-whitespace t)
;;(set-face-background 'trailing-whitespace "#b14770")

;; yes or noをy or n
(fset 'yes-or-no-p 'y-or-n-p)

;; タブ幅
;;(custom-set-variables '(tab-width 4))

;; 最近使ったファイルをメニューに表示
(recentf-mode t)

;;; キーバインド設定 C-x r: rgrep
(global-set-key (kbd "C-x r") 'rgrep)
;;; キーバインド設定 C-x s: shell
;; (global-set-key (kbd "C-x s") 'shell)
;;; キーバインド設定 C-t: 0other-window ウィンドウ移動
(global-set-key (kbd "C-t") 'other-window)
;;; cua-mode(M-x cua-mode M-x cua-set-rectangle-mark)
(cua-mode t)
(setq cua-enable-cua-keys nil)



;; ;; 色設定
;; (set-face-attribute ; バー自体の色
;;   'tabbar-default nil
;;    :background "white"
;;    :family "Inconsolata"
;;    :height 1.0)
;; (set-face-attribute ; アクティブなタブ
;;   'tabbar-selected nil
;;    :background "black"
;;    :foreground "white"
;;    :weight 'bold
;;    :box nil)
;; (set-face-attribute ; 非アクティブなタブ
;;   'tabbar-unselected nil
;;    :background "white"
;;    :foreground "black"
;;    :box nil)

;; ;;flymake
;; (defun flymake-php-init ()
;;   (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                      'flymake-create-temp-inplace))
;;          (local-file (file-relative-name
;;                       temp-file
;;                       (file-name-directory buffer-file-name))))
;;     (list "php" (list "-l" local-file))))
;; (push '(".+\\.php$" flymake-php-init) flymake-allowed-file-name-masks)
;; (push '("(Parse|Fatal) error: (.*) in (.*) on line ([0-9]+)" 3 4 nil 2) flymake-err-line-patterns)

;; (add-hook 'php-mode-hook (flymake-mode t))



;; ;;Highright
;; (defface hlline-face
;;   '((((class color)
;;       (background dark))
;;      (:background "dark slate gray"))
;;     (((class color)
;;       (background light))
;;      (:background  "#98FB98"))
;;     (t
;;      ()))
;;   "*Face used by hl-line.")
;; (setq hl-line-face 'hlline-face)
;; (global-hl-line-mode)

;; ;;対応するカッコを強調表示
;; (show-paren-mode t)
;; ;;時間表示
;; (display-time)


;; (require 'flymake)

;; (defun flymake-php-init ()
;;   "Use php to check the syntax of the current file."
;;   (let* ((temp (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))
;; 	  (local (file-relative-name temp (file-name-directory buffer-file-name))))
;;     (list "php" (list "-f" local "-l"))))

;; (add-to-list 'flymake-err-line-patterns
;;   '("\\(Parse\\|Fatal\\) error: +\\(.*?\\) in \\(.*?\\) on line \\([0-9]+\\)$" 3 4 nil 2))

;; (add-to-list 'flymake-allowed-file-name-masks '("\\.php$" flymake-php-init))

;; ;; Drupal-type extensions
;; (add-to-list 'flymake-allowed-file-name-masks '("\\.module$" flymake-php-init))
;; (add-to-list 'flymake-allowed-file-name-masks '("\\.install$" flymake-php-init))
;; (add-to-list 'flymake-allowed-file-name-masks '("\\.inc$" flymake-php-init))
;; (add-to-list 'flymake-allowed-file-name-masks '("\\.engine$" flymake-php-init))

;; (add-hook 'php-mode-hook (lambda () (flymake-mode 1)))
;; (define-key php-mode-map '[M-S-up] 'flymake-goto-prev-error)
;; (define-key php-mode-map '[M-S-down] 'flymake-goto-next-error)


;; ;;flymake (Emacs22から標準添付されている)
;; (when (require (quote flymake) nil t)
;;   (global-set-key "\C-cd" (quote flymake-display-err-menu-for-current-line))
;;   ;; PHP用設定
;;   (When (not (fboundp (quote flymake-php-init)))
;;     ;; flymake-php-initが未定義のバージョンだったら、自分で定義する
;;     (defun flymake-php-init ()
;;       (let* ((temp-file   (flymake-init-create-temp-buffer-copy
;;                            (quote flymake-create-temp-inplace)))
;;              (local-file  (file-relative-name
;;                            temp-file
;;                            (file-name-directory buffer-file-name))))
;;         (list "php" (list "-f" local-file "-l"))))
;;     (setq flymake-allowed-file-name-masks
;;           (append
;;            flymake-allowed-file-name-masks
;;            (quote (("\.php[345]?$" flymake-php-init)))))
;;     (setq flymake-err-line-patterns
;;           (cons
;;            (quote ("\(\(?:Parse error\|Fatal error\|Warning\): .*\) in \(.*\) on line \([0-9]+\)" 2 3 nil 1))
;;            flymake-err-line-patterns)))
;;   ;; JavaScript用設定
;;   (when (not (fboundp (quote flymake-javascript-init)))
;;     ;; flymake-javascript-initが未定義のバージョンだったら、自分で定義する
;;     (defun flymake-javascript-init ()
;;       (let* ((temp-file (flymake-init-create-temp-buffer-copy
;;                          (quote flymake-create-temp-inplace)))
;;              (local-file (file-relative-name
;;                           temp-file
;;                           (file-name-directory buffer-file-name))))
;;         ;;(list "js" (list "-s" local-file))
;;         (list "jsl" (list "-process" local-file))
;;         ))
;;     (setq flymake-allowed-file-name-masks
;;           (append
;;            flymake-allowed-file-name-masks
;;            (quote (("\.json$" flymake-javascript-init)
;;                    ("\.js$" flymake-javascript-init)))))
;;     (setq flymake-err-line-patterns
;;           (cons
;;            (quote ("\(.+\)(\([0-9]+\)): \(?:lint \)?\(\(?:warning\|SyntaxError\):.+\)" 1 2 nil 3))
;;            flymake-err-line-patterns)))
;;   (add-hook (quote php-mode-hook)
;;             (quote (lambda() (flymake-mode t))))
;;   (add-hook (quote javascript-mode-hook)
;;             (quote (lambda() (flymake-mode t)))))





;; php-modeのインデント設定
;; (defun php-indent-hook ()
;;   (setq indent-tabs-mode nil)
;;   (setq c-basic-offset 10)
;;   ;; (c-set-offset 'case-label '+) ; switch文のcaseラベル
;;   (c-set-offset 'arglist-intro '+) ; 配列の最初の要素が改行した場合
;;   (c-set-offset 'arglist-close 0)) ; 配列の閉じ括弧

;; (add-hook 'php-mode-hook 'php-indent-hook)

;;php-modeのタブ設定
;; (add-hook 'php-mode-user-hook
;; '(lambda ()
;; (setq tab-width 14)
;; (setq c-basic-offset 14)
;; (setq indent-tabs-mode nil)))

;;; grep-edit.el
(require 'grep-edit)

;; (defun set-read-only-color ()
;;   (if (eq buffer-read-only t)
;;       (set-buffer-colors #(0 #xcccccc))
;;     (set-buffer-colors nil)
;;     )
;;   )
;; (add-hook '*find-file-hooks* 'set-read-only-color)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (deeper-blue)))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(w3m-antenna-sites (quote (("http://www.yahoo.co.jp/" "Yahoo! JAPAN" nil) ("http://www.livedoor.com/" "livedoor" nil)))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:family #("ＭＳ ゴシック" 0 7 (charset cp932-2-byte)) :foundry "outline" :slant normal :weight normal :height 90 :width normal)))))

;; Close all buffers
(require 'cl)
(defun close-all-buffers ()
  (interactive)
  (loop for buffer being the buffers
     do (kill-buffer buffer)))

;; window max size in starting emacs
(add-hook 'window-setup-hook
        #'(lambda () (w32-send-sys-command ?\xF030)))

;; ;; ^M はコピペできないので、C-q M で入力して下さい
;; (defun my-delete-M (start end)
;;   (interactive "r")
;;   (save-restriction
;;     (narrow-to-region start end)
;;     (goto-char (point-min))
;;     (while (re-search-forward "^M$" nil t) (replace-match "" nil t))))

;; Selection of TODO in ORG-MODE
(require 'org)
(setq org-use-fast-todo-selection t)
(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s)" "WAITING(w)"  "SOMEDAY(d)" "|" "DONE(x)" "CANCEL(c)")
	(sequence "APPT(a)" "|" "DONE(x)" "CANCEL(c)")))
;; ORG-Remember mode in ORG-MODE
;;(setq org-startup-truncated nil)
(setq org-startup-truncated t)
(setq org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(org-remember-insinuate)
(setq org-directory "~/work/memo/")
;(setq org-default-notes-file (concat org-directory "agenda.org"))
(setq org-default-notes-file (concat org-directory "remember.org"))
(setq org-remember-templates
      '(("Todo" ?t "** TODO %?\n   %i\n   %a\n   %t" nil "Inbox")
        ("Bug" ?b "** TODO %?   :bug:\n   %i\n   %a\n   %t" nil "Inbox")
        ("Idea" ?i "** %?\n   %i\n   %a\n   %t" nil "New Ideas")
        ))

;;schedule of ORG-MODE
;;(require 'org)
;;(setq org-default-notes-file "~/work/memo/memo3.org")
;;(setq org-agenda-files (list org-default-notes-file))
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c r") 'remember)

;;php-mode to add extention
(add-to-list 'auto-mode-alist '("\\.class\\'" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . php-mode))

(modify-coding-system-alist 'file "*.class" 'utf-8)
(modify-coding-system-alist 'file "*.php" 'utf-8)
(modify-coding-system-alist 'file "*" 'utf-8)

;;(setq auto-coding-functions t)

(require 'w3m-load)

;;; 画像ファイルを表示
(auto-image-file-mode t)

(setq user-mail-address "hiro3946@gmail.com")
(setq user-full-name "hiro toku")
(setq smtpmail-smtp-server "hiro")
(setq mail-user-agent 'message-user-agent)
(setq message-send-mail-function 'message-smtpmail-send-it)

;;; Mew初期設定
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)
(setq mew-fcc "+outbox") ; 送信メールを保存
(setq exec-path (cons "/usr/bin" exec-path))

;; Optional setup (Read Mail menu):
(setq read-mail-command 'mew)

;; Optional setup (e.g. C-xm for sending a message):
(autoload 'mew-user-agent-compose "mew" nil t)
(if (boundp 'mail-user-agent)
    (setq mail-user-agent 'mew-user-agent))
(if (fboundp 'define-mail-user-agent)
    (define-mail-user-agent
      'mew-user-agent
      'mew-user-agent-compose
      'mew-draft-send-message
      'mew-draft-kill
      'mew-send-hook))
(put 'dired-find-alternate-file 'disabled nil)

;;; w3m-weather 設定
(autoload 'w3m-weather "w3m-weather" "Display weather report." t)
(setq w3m-weather-default-area "東京都・東京")
;;江戸川区詳細設定
;; (setq w3m-weather-default-area "江戸川区")

;; (eval-after-load "w3m-weather"
;;   '(setq w3m-weather-completion-table
;;          (nconc
;;           '(("江戸川区" "edogawaku"
;;              "http://weather.yahoo.co.jp/weather/jp/13/4410/13123.html")
;;             ("edogawaku" "江戸川区")
;;             ("篠崎町" "shinozaki"
;;              "http://weather.yahoo.co.jp/weather/jp/13/4410/13123/1330061.html")
;;             ("shinozaki" "篠崎町")
;;             ("sinozaki" "篠崎町")
;;             ("目黒区" "meguroku"
;;              "http://weather.yahoo.co.jp/weather/jp/13/4410/13110.html")
;;             ("meguroku" "目黒区")
;;             ("下目黒" "shimomeguro"
;;              "http://weather.yahoo.co.jp/weather/jp/13/4410/13110/1530064.html")
;;             ("shimomeguro" "下目黒")
;;             ("simomeguro" "下目黒")
;;             ("東京" "tokyo"
;;              "http://weather.yahoo.co.jp/weather/jp/13/4410.html")
;;             ("tokyo" "東京")
;;             ("toukyou" "東京"))
;;           w3m-weather-completion-table)))

;;; html-mode設定
;; (add-hook ‘html-mode-hook (lambda () (zencoding-mode 1)))

;; (autoload 'html-mode "html-mode" "HTML major mode." t)
;; (or (assoc "\\.html$" auto-mode-alist)
;;   (setq auto-mode-alist (cons '("\\.html$" . html-mode)
;;                               auto-mode-alist)))

;;;
;;; Put the following code in your .emacs file:
;;;
;; (autoload 'html-mode "html" "HTML major mode." t)
;; (or (assoc "¥¥.html$" auto-mode-alist)
;;     (setq auto-mode-alist (cons '("¥¥.html$" . html-mode)
;;                                     auto-mode-alist)))

(require 'web-mode)

;;; emacs 23以下の互換
(when (< emacs-major-version 24)
  (defalias 'prog-mode 'fundamental-mode))

;;; 適用する拡張子
(add-to-list 'auto-mode-alist '("\\.phtml$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x$"   . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb$"       . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$"     . web-mode))
(add-to-list 'auto-mode-alist '("\\.ctp?$"      . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl?$"      . web-mode))

;;; インデント数
(defun web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-html-offset   2)
  (setq web-mode-css-offset    2)
  (setq web-mode-script-offset 2)
  (setq web-mode-php-offset    2)
  (setq web-mode-java-offset   2)
  (setq web-mode-asp-offset    2))
(add-hook 'web-mode-hook 'web-mode-hook)


;; ;;汎用機の SPF (mule みたいなやつ) には
;; ;;画面を 2 分割したときの 上下を入れ替える swap screen
;; ;;というのが PF 何番かにわりあてられていました。
;; (defun swap-screen()
;;   "Swap two screen,leaving cursor at current window."
;;   (interactive)
;;   (let ((thiswin (selected-window))
;;         (nextbuf (window-buffer (next-window))))
;;     (set-window-buffer (next-window) (window-buffer))
;;     (set-window-buffer thiswin nextbuf)))
;; (defun swap-screen-with-cursor()
;;   "Swap two screen,with cursor in same buffer."
;;   (interactive)
;;   (let ((thiswin (selected-window))
;;         (thisbuf (window-buffer)))
;;     (other-window 1)
;;     (set-window-buffer thiswin (window-buffer))
;;     (set-window-buffer (selected-window) thisbuf)))
;; (global-set-key [f2] 'swap-screen)
;; (global-set-key [S-f2] 'swap-screen-with-cursor)

;; 正規表現置換（C-M-%）のショートカットキー（M-5）割り当て
(global-set-key "\M-5" 'query-replace-regexp)
;; 矩形編集のショートカットキー（M-c）割り当て
(global-set-key "\M-c" 'cua-set-rectangle-mark)
;; 行末の全角空白削除のショートカットキー（M-）割り当て<-保留中（割り当てキーを探索中）
;;(global-set-key "\M-" 'delete-trailing-whitespace)
;; Remember mode（M-remember）のショートカットキー（C-c r）割り当て
;;(global-set-key "\C-c r" 'remember-mode)
;;(define-key global-map "\C-c r" 'remember-mode)

(add-to-list 'default-frame-alist '(font . "ricty-11"))