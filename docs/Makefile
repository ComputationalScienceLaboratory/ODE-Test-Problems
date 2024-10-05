SPHINXOPTS ?= --builder dirhtml --fail-on-warning
SOURCEDIR = .
BUILDDIR = build
PROBLEMSDIR = problems

.PHONY: html problems install serve lint clean

html: problems
	sphinx-build $(SOURCEDIR) $(BUILDDIR) $(SPHINXOPTS)

problems:
	python3 generate_problem_rst.py

install:
	python3 -m pip install -r requirements.txt

serve:
	sphinx-autobuild $(SOURCEDIR) $(BUILDDIR) $(SPHINXOPTS) --watch ../toolbox --pre-build "make problems" \
	--ignore $(PROBLEMSDIR)

lint:
	pycodestyle .. && codespell ..

clean:
	rm -rf $(BUILDDIR) $(PROBLEMSDIR)
