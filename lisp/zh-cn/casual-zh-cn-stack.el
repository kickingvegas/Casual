;;; casual-zh-cn-stack.el --- Casual Stack Menu            -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Charles Choi

;; Author: Charles Choi <kickingvegas@gmail.com>
;; Keywords: tools

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:
(require 'calc)
(require 'calc-yank)
(require 'calc-undo)
(require 'transient)

(defun casual-customize-kill-line-numbering ()
  "Customize Calc kill line numbering behavior.
Customize the variable `calc-kill-line-numbering'.
Set `calc-kill-line-numbering' to nil to exclude line numbering
from `kill-ring' operations."
  (interactive)
  (customize-variable 'calc-kill-line-numbering))

(transient-define-prefix casual-zh-cn-stack-display-menu ()
  "Casual stack display menu."
  ["对齐"
   :class transient-row
   ("l" "左对齐" calc-left-justify :transient t)
   ("c" "居中" calc-center-justify :transient t)
   ("r" "右对齐" calc-right-justify :transient t)]

  [["截断"
    ("." "当前位置" calc-truncate-stack :transient t)
    ("p" "向上截断" calc-truncate-up :transient t)
    ("n" "向下截断" calc-truncate-down :transient t)]

   ["其他"
    ("R" "刷新" calc-refresh :transient t)
    ("l" "自定义行号格式"
     casual-customize-kill-line-numbering :transient nil)]]
  [""
   :class transient-row
   ("C-g" "‹返回" ignore :transient transient--do-return)
   ("q" "关闭" ignore :transient transient--do-exit)
   ("s" "保存设置" calc-save-modes :transient t)])



;; Wrapped Functions
(defun casual--stack-roll-all ()
  "Roll down stack accounting for all elements currently on the stack.

* References
- info node `(calc) Stack Manipulation'
- `calc-roll-down'"
  (interactive)
  (calc-roll-down (calc-stack-size)))

(defun casual--stack-clear ()
  "Clear entire stack."
  (interactive)
  (calc-pop-stack (calc-stack-size)))

(defun casual--stack-swap ()
  "Exchange the top two elements of the stack.
\nGiven the values a in (2:) and b in (1:), performing this command will
exchange their places resulting with b in (2:) and a in (1:).
\nStack Arguments:
2: a
1: b

This function is a wrapper over `calc-roll-down'.

* References
- info node `(calc) Stack Manipulation'
- `calc-roll-down'"
  (interactive)
  (call-interactively #'calc-roll-down))

(defun casual--stack-drop ()
  "Remove the top element of the stack.
\nStack Arguments:
1: n

This function is a wrapper over `calc-pop'.

* References
- info node `(calc) Stack Manipulation'
- `calc-pop'"
  (interactive)
  (call-interactively #'calc-pop))

(defun casual--stack-last ()
  "Push the last arguments popped by the previous command back onto the stack.
\nThis function is a wrapper over `calc-last-args'.

* References
- info node `(calc) Keep Arguments'
- `calc-last-args'"
  (interactive)
  (call-interactively #'calc-last-args))


(defun casual-calc-copy-as-kill ()
  "Copy top of stack (1:) to the clip-ring (aka `kill-ring').
\nBy default, Calc will include the stack line number to clip-ring operations.
To _not_ do this, set `calc-kill-line-numbering' to nil.
\nStack Arguments:
1: n

This function wraps over `calc-copy-as-kill'.

* References
- info node `(calc) Killing from Stack'
- `calc-copy-as-kill'"
  (interactive)
  (call-interactively #'calc-copy-as-kill))

(provide 'casual-zh-cn-stack)
;;; casual-zh-cn-stack.el ends here
