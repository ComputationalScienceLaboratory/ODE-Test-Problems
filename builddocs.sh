#! /bin/sh

octave docsrc/autopopproblems.m

sphinx-build -M html "docsrc" "docs"

mv docs/html/* docs/
