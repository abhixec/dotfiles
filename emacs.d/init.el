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
   '("d548ac4bb4c8c0ba8f22476f5afcea11b7f1754065eefb118e1324f8a74883fb" "b46ee2c193e350d07529fcd50948ca54ad3b38446dcbd9b28d0378792db5c088" "4aa183d57d30044180d5be743c9bd5bf1dde686859b1ba607b2eea26fe63f491" default))
 '(markdown-command "/usr/local/bin/pandoc")
 '(org-agenda-files (quote ("~/.notes/scratch" "~/.notes/tasks.org")))
 '(package-selected-packages
   '(easy-hugo flucui-themes mmm-mode pdf-tools night-owl-theme dracula-theme nord-theme yafolding json-mode magit org-web-tools desktop-registry try ledger-mode org-journal easy-kill markdown-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Setting up language for org-babel
(org-babel-do-load-languages
 'org-babel-load-languages '((python . t)(emacs-lisp . nil)))

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

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

(defun btoday ()
  "Insert string form today's date"
  (interactive)
  (insert (format-time-string "%B %e, %Y")))
(defun hugodate ()
  (interactive)
         (insert (format-time-string "%Y-%m-%dT%T")))
(setq abbrev-file-name
      "~/.emacs.d/abbreviations")

;;Remove the useless toolbar
(tool-bar-mode -1)

;; Remove C-z behavior for XMonad
(global-unset-key (kbd "C-z"))

;; Enable line wrapping
(global-visual-line-mode 1)

;; Desktop Mode
(desktop-save-mode 1)

;;Setting the selection region
(set-face-attribute 'region nil :background "#666" :foreground "#ffffff")

;; Enable IDO Mode
(setq ido-enable-flex-matching 1)
(setq ido-everywhere t)
(ido-mode 1)

;; Setting the keybind for global org commmands
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-capture-templates
      '(("t" "Todo" entry (file_headline "~/.org/gtd.org" "Tasks")
	 "* TODO %? %T %i")
	("c" "checklist" checkitem (file+headline "~/.org/tasklist.org" "List")
	 )
	("j" "Journal" entry (file+datetree "~/.org/journal.org")
	 "* %?\nEntered on %U\n %i\n %a")))


(defun hakyll-headers() 
  "Return a draft org mode header string for a new article as FILE."
  (interactive)
  (insert (let ((datetimezone
          (format-time-string "%Y-%m-%dT%T")
          ))
     (concat
     "---" 
     "\ntitle: " (message "%s" (read-string "Title"))
     "\ndate: " (format-time-string "%B %e, %Y")
     "\nauthor: abhinav" 
     "\ntags: " (message "%s" (read-string "Tags"))
     "\ndescription: " (message "%s" (read-string "Description"))
     "\ncategories: " (message "%s" (read-string "Category"))
     "\n"
     "---")))
  )
