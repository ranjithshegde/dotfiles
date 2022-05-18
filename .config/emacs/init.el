(package-initialize)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp-tailwindcss latex-pretty-symbols latex-preview-pane latex-unicode-math-mode languagetool latex-math-preview latex-extra magit evil-surround sclang-snippets sclang-extensions htmlize flex-autopair evil-escape evil-collection yasnippet-snippets yasnippet which-key evil-textobj-tree-sitter company flycheck fzf tree-sitter-indent tree-sitter-langs tree-sitter evil-tex evil-commentary org-bullets evil lsp-mode ##)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq evil-want-keybinding nil)

(require 'evil)
(evil-mode 1)

(require 'tree-sitter)
(require 'tree-sitter-langs)
(require 'which-key)

(evil-commentary-mode 1)

(which-key-mode 1)

(yas-global-mode 1)

(global-evil-surround-mode 1)


(evil-collection-init)

(evil-escape-mode)


(add-hook 'after-init-hook 'global-company-mode)

(require 'flex-autopair)
(flex-autopair-mode 1)

(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))
(setq org-latex-listings 'minted)

;; (add-to-list 'org-latex-packages-alist '("" "lstlisting"))
;; (setq org-latex-listings 'lstlisting)

(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-src-fontify-natively t)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (latex . t)))

(require 'sclang)
