#! /bin/sh

#octave docsrc/autopopproblems.m

python3 docsrc/auto_pop_problems.py


rm -r docs/

sphinx-build -M html "docsrc" "docs"

mv docs/html/* docs/

touch docs/.nojekyll
