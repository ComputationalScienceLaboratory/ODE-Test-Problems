.PHONY: html problems install serve clean

html: problems
	sphinx-build . build/html

problems: clean
	mkdir -p build/problems
	python3 generate_problem_rst.py

install:
	pip3 install -r requirements.txt

serve:
	sphinx-autobuild . build/html --watch ../src --pre-build 'make problems' --re-ignore 'build/*'

clean:
	rm -rf build
