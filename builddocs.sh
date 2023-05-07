#! /bin/sh

octave docsrc/autopopproblems.m


rm -r docs/

sphinx-build -M html "docsrc" "docs"

mv docs/html/* docs/

touch docs/.nojekyll
