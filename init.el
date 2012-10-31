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
  (when (not (package-installed-p p))
    (package-install p)))

;;Remove annoying stuff from starter kit
;;line highlight
(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)
;;give me back scroll and menu bars
(defun replace-scroll-and-menu-bars ()
  "Replace the scroll and menu bars (if in windowed emacs)"
  (if (window-system)
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

;;For El-Get

(setq exec-path
          (append  '("/usr/local/bin"
                     "/Library/Frameworks/Python.framework/Versions/2.7/bin"
                     "/opt/local/bin"
                     "/opt/local/sbin"
                     ) exec-path
                       ))

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(el-get 'sync) ;;Should update currently installed packages

(setq el-get-user-package-directory "~/.emacs.d/el-get-init")

;;El-Get some stuff

(defvar el-get-packages
  '(haskell-mode
    doxymacs
    rainbow-mode
    buffer-move
    auto-complete
    fill-column-indicator))

(el-get 'sync el-get-packages)


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

;; Scroll to end of window before error
(setq scroll-error-top-bottom t)

;; Ido-ubiquitous broken in M-x man, disable it
(add-to-list 'ido-ubiquitous-command-exceptions 'man)
(ido-ubiquitous-disable-in man)

;; Buffer movement by arrow keys
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)

;;Magit
(global-set-key (kbd "C-x g") 'magit-status)

;;Winner mode allows undoing window configuration changes
(winner-mode 1)

;;Automatically revert file if it changed on disk and we have no unsaved changes
(global-auto-revert-mode 1)

;;Default fill to 80 columns
(setq-default fill-column 80)

