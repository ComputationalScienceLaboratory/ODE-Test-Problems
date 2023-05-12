.PHONY: html install serve clean

html: clean
	mkdir -p build/problems
	python3 auto_pop_problems.py
	sphinx-build . build/html

install:
	pip3 install -r requirements.txt

serve: html
	python3 -m http.server -d build/html

clean:
	rm -rf build
