EMACS ?= emacs
EVAL  := $(EMACS) -Q --batch --eval
BATCH := $(EMACS) -Q --batch

all: site how-to-read-emacs-lisp

clean:
	find . -name \*.html -exec rm {} \;
	rm -f *~

site:
	$(BATCH) -l build-site.el --visit index.org --eval '(sacha/emacs-notes-org-publish-project "sacha/emacs-notes")' --kill

site-force:
	$(BATCH) -l build-site.el --visit index.org --eval '(sacha/emacs-notes-org-publish-project "sacha/emacs-notes" t)' --kill

cleansite: clean site

how-to-read-emacs-lisp.html: how-to-read-emacs-lisp.org
	$(BATCH) -l build-site.el how-to-read-emacs-lisp.org -f sacha/emacs-notes-org-publish-current-file

how-to-read-emacs-lisp.epub: how-to-read-emacs-lisp.html
	perl -p -n -e 's|http://emacslife.com/how-to-read-emacs-lisp.html#|#|g' how-to-read-emacs-lisp.html > tmp.html
	ebook-convert tmp.html how-to-read-emacs-lisp.epub --authors "Sacha Chua" --language "English" --no-default-epub-cover
	rm tmp.html

how-to-read-emacs-lisp.mobi: how-to-read-emacs-lisp.html
	perl -p -n -e 's|http://emacslife.com/how-to-read-emacs-lisp.html#|#|g' how-to-read-emacs-lisp.html > tmp.html
	ebook-convert tmp.html how-to-read-emacs-lisp.mobi --authors "Sacha Chua" --language "English"
	rm tmp.html

how-to-read-emacs-lisp.zip: how-to-read-emacs-lisp.html
	perl -p -n -e 's|http://emacslife.com/how-to-read-emacs-lisp.html#|#|g' how-to-read-emacs-lisp.html > tmp.html
	mv tmp.html how-to-read-emacs-lisp.html
	zip -r how-to-read-emacs-lisp.zip how-to-read-emacs-lisp.html css js images

how-to-read-emacs-lisp: how-to-read-emacs-lisp.mobi how-to-read-emacs-lisp.epub how-to-read-emacs-lisp.zip

.PHONY: site
