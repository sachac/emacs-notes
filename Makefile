EMACS ?= emacs
EVAL  := $(EMACS) -Q --batch --eval
BATCH := $(EMACS) -Q --batch

all: site

clean:
	find . -name \*.html -exec rm {} \;
	rm -f *~

site:
	$(BATCH) -l build-site.el --visit index.org --eval '(sacha/emacs-notes-org-publish-project "sacha/emacs-notes")'

site-force:
	$(BATCH) -l build-site.el --visit index.org --eval '(sacha/emacs-notes-org-publish-project "sacha/emacs-notes" t)'

cleansite: clean site

.PHONY: site
