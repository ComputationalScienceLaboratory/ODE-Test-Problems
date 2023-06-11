SPHINXOPTS ?= -b dirhtml
SOURCEDIR = .
BUILDDIR = build
PROBLEMSDIR = problems

.PHONY: html problems install serve clean

html: problems
	sphinx-build "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS)

problems:
	python3 generate_problem_rst.py

install:
	pip3 install -r requirements.txt

serve:
	sphinx-autobuild "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) --watch "../toolbox" --watch "../*.md" \
	--pre-build "make problems" --re-ignore "$(PROBLEMSDIR)/*"

clean:
	rm -rf $(BUILDDIR) $(PROBLEMSDIR)
