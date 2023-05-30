.PHONY: build install convert clean

build: clean
	
	matlab -r "demo.m"

install:
	pip3 install -r requirements.txt

convert: 
	ffmpeg -i output.avi -c:v libvpx -crf 10 -b:v 1M -c:a libvorbis output.webm

clean:
	rm -rf *.avi