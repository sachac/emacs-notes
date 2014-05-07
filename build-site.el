;; build site
(package-initialize)
(require 'ox-publish)
(require 'htmlize)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)
	 (ditaa . t) 
	 (R . t)))

(setq-default buffer-file-coding-system 'utf-8)

(defvar sacha/emacs-notes-html-head
"<link rel=\"stylesheet\" type=\"text/css\" href=\"./css/foundation.min.css\"></link>
<link rel=\"stylesheet\" type=\"text/css\" href=\"./css/org-export.css\"></link>
<link rel=\"stylesheet\" type=\"text/css\" href=\"./css/style.css\"></link>
<link rel=\"stylesheet\" type=\"text/css\" href=\"./css/emacs-notes.css\"></link>
<script src=\"./js/jquery.min.js\"></script>
<script src=\"./js/emacs-notes.js\"></script>")

(defvar sacha/emacs-notes-postamble "<div class=\"back-to-top\"><a href=\"#top\">Back to top</a> | <a href=\"mailto:sacha@sachachua.com\">E-mail me</a></div>")

(defvar sacha/emacs-notes-directory (file-name-directory (or load-file-name buffer-file-name))
	"Location of files.")

(defun sacha/emacs-notes-org-publish-project (project &optional force async)
  "Override some variables."
  (interactive
   (list
    (assoc (org-icompleting-read
	    "Publish project: "
	    org-publish-project-alist nil t)
	   org-publish-project-alist)
    current-prefix-arg))
  (let ((buffer-file-coding-system 'utf-8)
	(select-safe-coding-system-accept-default-p t)
	org-confirm-babel-evaluate
	make-backup-files
	org-html-validation-link)
    (org-publish-project project force async)))

(defun sacha/emacs-notes-org-html-publish-to-html (plist filename pub-dir)
	"Publish without saving backup files."
	(let ((buffer-file-coding-system 'utf-8)
				(select-safe-coding-system-accept-default-p t)
				org-confirm-babel-evaluate
				make-backup-files org-html-validation-link)
		(condition-case nil
				(org-html-publish-to-html plist filename pub-dir)
			(error (message "Error publishing %s" filename)))))

(unless (assoc "emacs-notes-base" org-publish-project-alist)
	(add-to-list 'org-publish-project-alist
							 `("emacs-notes-base"
								 :base-directory ,sacha/emacs-notes-directory
								 :base-extension "org"
								 :exclude "tasks.org"       ; regexp
								 :publishing-directory ,sacha/emacs-notes-directory
								 :publishing-function sacha/emacs-notes-org-html-publish-to-html
								 :html-head-include-default-style nil
								 :html-head-include-scripts nil
								 :html-head ,sacha/emacs-notes-html-head
								 :auto-sitemap t                  ; Generate sitemap.org automagically...
								 :sitemap-filename "sitemap.org"  ; Call it sitemap.org (it's the default)...
								 :sitemap-title "Sitemap"         ; With title 'Sitemap'.
								 :makeindex t
								 :with-timestamp t
								 :section-numbers nil
								 :html-preamble "" 
								 :html-postamble ,sacha/emacs-notes-postamble
								 :htmlized-source t
								 )))
(unless (assoc "emacs-notes-blog-posts" org-publish-project-alist)
(add-to-list 'org-publish-project-alist
      `("emacs-notes-blog-posts"
         :base-directory ,(expand-file-name "blog-posts" sacha/emacs-notes-directory)
         :base-extension "org"
         :exclude "tasks.org"       ; regexp
         :publishing-directory ,(expand-file-name "blog-posts" sacha/emacs-notes-directory)
         :publishing-function sacha/emacs-notes-org-html-publish-to-html
         :html-head-include-default-style nil
         :html-head-include-scripts nil
         :html-head ,(replace-regexp-in-string "\\./" "../" sacha/emacs-notes-html-head)
         :auto-sitemap t                  ; Generate sitemap.org automagically...
         :sitemap-filename "sitemap.org"  ; Call it sitemap.org (it's the default)...
         :sitemap-title "Sitemap"         ; With title 'Sitemap'.
				 :section-numbers nil
				 :html-preamble ""
				 :html-postamble ,sacha/emacs-notes-postamble
         :makeindex t
         :with-timestamp t
         :htmlized-source)))
(unless (assoc "sacha/emacs-notes" org-publish-project-alist)
				(add-to-list 'org-publish-project-alist '("sacha/emacs-notes"
																									:components ("emacs-notes-base" "emacs-notes-blog-posts"))))

