;; -*- mode: elisp -*-

;; Disable the splash screen (to enable it agin, replace the t with 0)
;;(setq inhibit-splash-screen t)

;; Enable transient mark mode

(transient-mark-mode 1)

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(package-initialize)

;;;;Org mode configuration
;; Enable Org mode
(require 'org)
;; Make Org mode work with files ending in .org
;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("0598c6a29e13e7112cfbc2f523e31927ab7dce56ebb2016b567e1eff6dc1fd4f" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "0f63b94e366a6a9cd3ac12b3f5e7b88ba214fd592a99fb5bc55af33fb2280c7f" "3e15b69a7b2572c64f5f04ebf1103deb803ec762f4270f3f1e498fb4b659afd3" "4aa183d57d30044180d5be743c9bd5bf1dde686859b1ba607b2eea26fe63f491" "850213aa3159467c21ee95c55baadd95b91721d21b28d63704824a7d465b3ba8" default)))
 '(markdown-command "/usr/local/bin/pandoc")
 '(org-agenda-files (quote ("~/.notes/scratch" "~/.notes/tasks.org")))
 '(package-selected-packages
   (quote
    (org-roam csv-mode web-mode evil-visual-mark-mode solarized-theme underwater-theme hydandata-light-theme night-owl-theme nord-theme yafolding json-mode magit org-web-tools desktop-registry try ledger-mode pdf-tools org-journal easy-kill markdown-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))

(setq org-default-notes-file (concat org-directory "/tasks.org"))
(define-key global-map "\C-cc" 'org-capture)

;; Taken from Journal.el
(defun now ()
  "Insert string for the current time formatted like '2:34 PM'."
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%D %-I:%M %p")))

(defun today ()
  "Insert string for today's date nicely formatted in American style,
e.g. Sunday, September 17, 2000."
  (interactive)                 ; permit invocation in minibuffer
  (insert (format-time-string "%A, %B %e, %Y")))


(setq abbrev-file-name
      "~/.emacs.d/abbreviations")

;;Remove the useless toolbar
(tool-bar-mode -1)

;; Remove C-z behavior for XMonad
(global-unset-key (kbd "C-z"))

;; Agenda view
(global-set-key "\C-ca" 'org-agenda)

;; Enable line wrapping
(global-visual-line-mode 1)

;; Enable Ido-mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
