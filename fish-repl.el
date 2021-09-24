;;; fish-repl.el --- summary -*- lexical-binding: t -*-

;; Author: takeo obara
;; Maintainer: takeo obara
;; Version: 1.0.0
;; Homepage: https://github.com/takeokunn/fish-repl.el

;; This file is not part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.

;;; Code:

(require 'comint)
(require 'f)

(defconst fish-repl-repl-number "1.0.0"
  "fish repl version number.")

(defgroup fish-repl ()
  "fish repl"
  :tag "Fish"
  :prefix "fish-repl-"
  :group 'fish-repl
  :link '(url-link :tag "repo" "https://github.com/takeokunn/fish-repl.el"))

(define-derived-mode fish-repl-mode comint-mode "Fish shell REPL"
  "Major-mode for fish REPL.")

(defvar fish-repl-mode-map
  (let ((map (make-sparse-keymap)))
    map))

(defvar fish-repl-mode-hook
  nil
  "List of functions to be executed on entry to `fish-repl-mode'.")

(defcustom fish-repl-exec-command '("fish" "--init-command" "function fish_prompt; printf '> '; end")
    "Fish repl exec command"
    :group 'fish-repl
    :tag "fish repl execution command"
    :type '())

(defvar fish-repl-comint-buffer-process
  nil
  "A list (buffer-name process) is arguments for `make-comint'.")
(make-variable-buffer-local 'fish-repl-comint-buffer-process)

(defun fish-repl--detect-buffer ()
  "Return tuple list, comint buffer name and program."
  (or fish-repl-comint-buffer-process
      '("fish-repl" "fish-repl")))

(defun fish-repl--make-process ()
  (apply 'make-comint-in-buffer
         (car (fish-repl--detect-buffer))
         (cadr (fish-repl--detect-buffer))
         (car fish-repl-exec-command)
         nil
         (cdr fish-repl-exec-command)))

;;;###autoload
(defun fish-repl ()
  (interactive)
  (let* ((buf-name "fish-repl")
         (my-dir (read-directory-name "DIRECTORY: "))
         (default-directory my-dir))
    (switch-to-buffer (fish-repl--make-process))
    (fish-repl-mode)
    (run-hooks 'fish-repl-hook)))
(put 'fish-repl 'interactive-only 'fish-repl-run)

;;;###autoload
(defun fish-repl-run (buf-name process)
  (let ((fish-repl-comint-buffer-process (list buf-name process)))
    (call-interactively 'fish-repl)))

;;;###autoload
(defun fish-repl-send-line ()
  (let ((str (thing-at-point 'line 'no-properties)))
    (comint-send-string (cadr (fish-repl--detect-buffer)) str)))

(provide 'fish-repl)

;;; fish-repl.el ends here
