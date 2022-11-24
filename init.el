;;; init.el --- Initialization. -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Brihadeesh
;; This file is NOT part of GNU Emacs.
;; This file is free software.

;; Author: peregrinator <brihadeesh@protonmail.com>
;; URL: https://git.sr.ht/~peregrinator/.emacs.d
;; Package-Requires: ((emacs "28.1"))

;;; Commentary:
;; This file provides the initialization configuration.

;;; Code:

;; Make emacs startup faster
(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)
(defun startup/revert-file-name-handler-alist ()
  "Revert file name handler alist."
  (setq file-name-handler-alist startup/file-name-handler-alist))
(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)

;; For performance
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq process-adaptive-read-buffering nil)

;; Load newer .elc or .el
(setq load-prefer-newer t)


;;; Configure `straight.el'
;; fetch developmental version of `straight.el'
(setq straight-repository-branch "develop"

      ;; redirect all package repos and builddirs elsewhere
      straight-base-dir "~/.cache/")


;; Bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" "~/.cache"))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; Configure straight.el (contd.)
;; make all use-package instances use straight.el
(setq straight-use-package-by-default t

      ;; clone depth (probably to save space)
      straight-vc-git-default-clone-depth 1

      ;; Define when to check for package modifications,
      ;; for improved straight.el startup time.
      straight-check-for-modifications nil

      ;; use elpa
      straight-recipes-gnu-elpa-use-mirror t

      straight-host-usernames
      '((github . "brihadeesh")
	(gitlab . "peregrinator")))

;; Install use-package with straight.el
(straight-use-package 'use-package)


;; install org & org-contrib
(straight-use-package 'org)
;; (require 'org)
(straight-use-package 'org-contrib)


;; Load configuration.org
(when (file-readable-p
	   (concat user-emacs-directory "configuration.org"))
  (org-babel-load-file
   (concat user-emacs-directory "configuration.org")))

;; WHY?
;; Restore original GC values
;; (add-hook 'emacs-startup-hook
;; 		  (lambda ()
;; 			(setq gc-cons-threshold gc-cons-threshold-original)
;; 			(setq gc-cons-percentage gc-cons-percentage-original)))

;;; init.el ends here
