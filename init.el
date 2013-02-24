;;For Starter Kit
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(starter-kit starter-kit-lisp starter-kit-bindings
                      zenburn-theme)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (unless (package-installed-p p)
    (package-install p)))

;;Remove annoying stuff from starter kit
;;line highlight
(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)
;;give me back scroll and menu bars
(defun replace-scroll-and-menu-bars ()
  "Replace the scroll and menu bars (if in windowed emacs)"
  (when (window-system)
      (let ((width (frame-width)))
        (menu-bar-mode)
        (set-frame-width (selected-frame) (+ width 1))
        (scroll-bar-mode)
        (set-frame-width (selected-frame) width))))
(replace-scroll-and-menu-bars)
;;But now we need to turn it off for clients that connect
(defun no-menu-bar-in-terminal (frame)
  "Remove menu bar mode when this frame is a terminal client"
  (unless (window-system)
    (message "Menu bars!")))
;;    (modify-frame-parameters frame '((menu-bar-lines . 0)))
;; (add-hook 'after-make-frame-functions 'no-menu-bar-in-terminal)

(server-start)

;;Give me Zenburn!

(load-theme 'zenburn t)

;; Mac path stuff
(when (memq window-system '(mac ns))
  (progn
    (message "Setting up Mac path")
    (unless (package-installed-p 'exec-path-from-shell)
      (package-install 'exec-path-from-shell))
    (exec-path-from-shell-initialize)
    (exec-path-from-shell-copy-env "CAML_LD_LIBRARY_PATH"))
  )



;;For El-Get
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(setq el-get-user-package-directory "~/.emacs.d/el-get-init")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(setq el-get-status-file "~/.emacs.d/el-get-status.el")

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-custom-recipes/")

(el-get 'sync)


;;Line numbers
(global-linum-mode 1)

(unless (string-match "apple-darwin" system-configuration)
  ;; on mac, there's always a menu bar drown, don't have it empty
  (menu-bar-mode -1))

(defface org-block-begin-line
  '((t (:background "#303030")))
  "Face used for the line delimiting the begin of source blocks.")

(defface org-block-background
  '((t (:background "#303030")))
  "Face used for the source block background.")

(defface org-block-end-line
  '((t (:background "#303030")))
  "Face used for the line delimiting the end of source blocks.")

;; fontify code in code blocks
(setq org-src-fontify-natively t)

;;Smex... For better M-x completions
(require 'smex)
(setq smex-history-length 100)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; Newline and indent everywhere
(global-set-key (kbd "RET") 'newline-and-indent)

;;Better buffer mode
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Scroll to end of window before error
(setq scroll-error-top-bottom t)

;; Ido-ubiquitous broken in M-x man, disable it
(add-to-list 'ido-ubiquitous-command-exceptions 'man)
(add-to-list 'ido-ubiquitous-command-exceptions 'w3m-goto-url)

;;ignore .DS_Store in ido
(add-to-list 'ido-ignore-files "\\.DS_Store")

;; Buffer movement by arrow keys
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;;Magit
(global-set-key (kbd "C-x g") 'magit-status)

;;Winner mode allows undoing window configuration changes
;;Use C-c <left>/<right>
(winner-mode 1)

;;Automatically revert file if it changed on disk and we have no unsaved changes
(global-auto-revert-mode 1)

;;Default fill to 80 columns
(setq-default fill-column 79)

(defun delete-whitespace-before-save ()
  "Used for prog mode to add a hook for deleting trailing whitespace on save"
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
)

(add-hook 'prog-mode-hook 'auto-fill-mode)
(add-hook 'prog-mode-hook 'fci-mode)
(add-hook 'prog-mode-hook 'delete-whitespace-before-save)

;;Have customize save changes to customize.el
(setq custom-file "~/.emacs.d/customize.el")
(load custom-file)

(yas-global-mode 1)

;;Auto complete stuff
(require 'pos-tip)
(require 'auto-complete-config)
(ac-config-default)
;;Needed for compatibility with flyspell
(ac-flyspell-workaround)
(setq ac-auto-start 3)
(setq ac-auto-show-menu t)
(setq ac-quick-help-delay .3)
(ac-set-trigger-key "TAB")
;; Make \C-n and \C-p work in autocompletion menu
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)
;; Let's have snippets in the auto-complete dropdown
(setq-default ac-sources '(ac-source-yasnippet
                           ac-source-abbrev
                           ac-source-words-in-buffer
                           ac-source-words-in-same-mode-buffers
                           ac-source-files-in-current-dir
                           ))

;;Flymake
;;(add-hook 'find-file-hook 'flymake-find-file-hook)

;;OPA
(autoload 'opa-classic-mode "/Library/Application Support/Emacs/site-lisp/opa-mode/opa-mode.el" "Opa CLASSIC editing mode." t)
(autoload 'opa-js-mode "/Library/Application Support/Emacs/site-lisp/opa-mode/opa-js-mode.el" "Opa JS editing mode." t)
(add-to-list 'auto-mode-alist '("\.opa$" . opa-js-mode))
(add-to-list 'auto-mode-alist '("\.js\.opa$" . opa-js-mode))
(add-to-list 'auto-mode-alist '("\.classic\.opa$" . opa-classic-mode))

(defun enable_flyspell ()
    (ispell-change-dictionary "american")
    (flyspell-prog-mode)
    )

;; Enable spell-checking on Opa comments and strings
(add-hook 'opa-mode-hook 'enable_flyspell)

(add-hook 'css-mode-hook 'rainbow-mode)

;;Start with empty scratch
(setq initial-scratch-message "")

;;Clipboard and kill ring integration
;;Currently seemst to break kill ring in certain circumstances (org-export)
;;(setq save-interprogram-paste-before-kill t)

;;Python stuff

;;Fix for Python hanging on Mac
;;https://github.com/fgallina/python.el/issues/117
;;Should make it into trunk python.el eventually

(defun python-shell-send-and-show-buffer (&optional arg)
  "Send the entire buffer to inferior Python process and show the Python buffer"
  (interactive "P")
  (if arg (python-shell-send-buffer arg) (python-shell-send-buffer))
  (python-shell-show-shell)
  )

(defun python-shell-show-shell ()
  "Show inferior Python process buffer."
  (interactive)
  (display-buffer (process-buffer (python-shell-get-or-create-process)) t))

(defun python-custom-setup ()
  "Setup Python mode how I like it"
  (local-set-key "\C-c\C-c" 'python-shell-send-and-show-buffer)

  (when (load "flymake" t)
    (defun flymake-pylint-init ()
      (let* ((temp-file (flymake-init-create-temp-buffer-copy
                         'flymake-create-temp-inplace))
             (local-file (file-relative-name
                          temp-file
                          (file-name-directory buffer-file-name))))
        (list "flake8" (list local-file))))

    (add-to-list 'flymake-allowed-file-name-masks
                 '("\\.py\\'" flymake-pylint-init))
    (local-unset-key "\M-g\M-n")
    (local-unset-key "\M-g\M-p")
    (local-set-key "\M-g\M-n" 'flymake-goto-next-error)
    (local-set-key "\M-g\M-p" 'flymake-goto-prev-error)
    (flymake-mode 1))

  (add-hook 'before-save-hook 'delete-trailing-whitespace)

  ;; pylookup documentation lookup
  (local-set-key "\C-ch" 'pylookup-lookup)

  ;; Jedi autocompletion
  (setq jedi:setup-keys t)
  (jedi:setup)
  )

(add-hook 'python-mode-hook 'python-custom-setup)

;;Expand region... This is super sweet!
(global-set-key (kbd "C-=") 'er/expand-region)

;;Go to matching parentheses
; From http://www.emacswiki.org/emacs/ParenthesisMatching#toc4
(defun goto-match-paren (arg)
  "Go to the matching parenthesis if on parenthesis AND last command is a movement command, otherwise insert %.
vi style of % jumping to matching brace."
  (interactive "p")
  (message "%s" last-command)
  (if (not (memq last-command '(
                                set-mark
                                cua-set-mark
                                goto-match-paren
                                down-list
                                up-list
                                end-of-defun
                                beginning-of-defun
                                backward-sexp
                                forward-sexp
                                backward-up-list
                                forward-paragraph
                                backward-paragraph
                                end-of-buffer
                                beginning-of-buffer
                                backward-word
                                forward-word
                                mwheel-scroll
                                backward-word
                                forward-word
                                mouse-start-secondary
                                mouse-yank-secondary
                                mouse-secondary-save-then-kill
                                move-end-of-line
                                move-beginning-of-line
                                backward-char
                                forward-char
                                scroll-up
                                scroll-down
                                scroll-left
                                scroll-right
                                mouse-set-point
                                next-buffer
                                previous-buffer
				previous-line
				next-line
                                )
                 ))
      (self-insert-command (or arg 1))
    (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
          ((looking-at "\\s\)") (forward-char 1) (backward-list 1))
          (t (self-insert-command (or arg 1))))))
(global-set-key (kbd "%") 'goto-match-paren)

;;Pending delete allows you to overwrite whatever's in the region
(add-hook 'prog-mode-hook 'delete-selection-mode)

;;Get rid of quick text size changes
(global-unset-key (kbd "C-+"))
(global-unset-key (kbd "C--"))

;;Immediately show the C- and M- stuff that's happening
(setq echo-keystrokes 0.1)

;;Subword mode for navigating camelCase words
(global-subword-mode 1)

;;For smooth-scrolling
(setq smooth-scroll-margin 5)

;;Haskell setup

(defun haskell-custom-setup ()
  (progn
;;    (define-key haskell-mode-map (kbd "C-x C-s") 'haskell-mode-save-buffer)
    (setq haskell-indent-offset 2)
    (ghc-init)
    (flymake-mode 1)

    ;; (defun haskell-mode-stylish-buffer-custom ()
    ;;   "Apply stylish-haskell to the current buffer."
    ;;   (interactive)
    ;;   (let ((column (current-column))
    ;;         (line (line-number-at-pos))
    ;;         (buffer (current-buffer))
    ;;         (file (buffer-file-name))
    ;;         (end (buffer-size)))
    ;;     (save-buffer) ;;First save so we don't lose the changes
    ;;     ;; (shell-command ;;Now run stylish with our custom config
    ;;     ;;  (concat
    ;;     ;;   "stylish-haskell -c ~/.emacs.d/stylish-haskell-config.yaml " file)
    ;;     ;;  buffer
    ;;     ;;  "*stylish_haskell_error*")
    ;;     ;; (mark-whole-buffer)
    ;;     ;; (haskell-indent-align-guards-and-rhs 0 end) ;;Align function stuff
    ;;     ;; (goto-line line)
    ;;     ;; (goto-char (+ column (point)))
    ;;     ))
    ;; (defadvice haskell-mode-save-buffer (before
    ;;                                      haskell-mode-stylish-before-save
    ;;                                      activate)
    ;;   (haskell-mode-stylish-buffer-custom))
    ))
;;(remove-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'haskell-custom-setup)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;;(setq haskell-stylish-on-save t)

(global-set-key "\C-xar" 'align-regexp)

;; active Babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (emacs-lisp . t)
   ))

;; Ocaml utop (better REPL)
(autoload 'utop-setup-ocaml-buffer "utop" "Toplevel for OCaml" t)
(add-hook 'tuareg-mode-hook 'utop-setup-ocaml-buffer)
