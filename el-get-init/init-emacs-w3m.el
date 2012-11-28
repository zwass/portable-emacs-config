(require 'w3m) ;;Needed for w3m functions used below

;;http://bc.tech.coop/blog/070208.html
(defun w3m-browse-url-other-window (url &optional newwin)
  (interactive
   (browse-url-interactive-arg "w3m URL: "))
  (let ((pop-up-frames nil))
    (switch-to-buffer-other-window
     (w3m-get-buffer-create "*w3m*"))
    (w3m-browse-url url)))

(defun w3m-browse-url-other-window-new-tab (url &optional newwin)
  (interactive
   (browse-url-interactive-arg "w3m URL: "))
  (let ((pop-up-frames nil))
    (switch-to-buffer-other-window
     (w3m-get-buffer-create "*w3m*"))
    (w3m-browse-url url t)))

(defun w3m-browse-url-new-tab (url &optional newwin)
  (interactive
   (browse-url-interactive-arg "w3m URL: "))
  (let ((pop-up-frames nil))
    (w3m-browse-url url t)))

(setq browse-url-browser-function
      '(("hoogle" . w3m-browse-url-other-window-new-tab)
        ("ghc" . w3m-browse-url-other-window-new-tab)
        ("hackage" . w3m-browse-url-other-window-new-tab)
        ("pylookup" . w3m-browse-url-new-tab)
        ("." .  browse-url-default-browser)))

;;http://nflath.com/tag/w3m/
(defun my-w3m-rename-buffer (url)
  "Renames the current buffer to be the current URL"
  (rename-buffer url t))
(add-hook 'w3m-display-hook 'my-w3m-rename-buffer)

(add-hook 'w3m-display-hook
          (lambda (url)
            (let ((buffer-read-only nil))
              (delete-trailing-whitespace))))
