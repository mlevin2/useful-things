#!/usr/bin/env bash

# check for prerequisites
for reqcmd in exiftool qpdf pdftk gshred
do
	command -v $reqcmd >/dev/null 2>&1 || { echo >&2 "I'm afraid this script won't be of much use to you if you don't have $reqcmd."; exit 1; }
done

for file in "$@"; do
	base=$(basename "$file")
	dir=$(dirname "$file")
	uncompressed=$dir/$RANDOM-$base
	unstripped=$dir/$RANDOM-$base
	unlinearized=$dir/$RANDOM-$base
	pdftk "$file" output "$uncompressed" uncompress
	pdftk "$uncompressed" output "$file" compress
	cp -p "$file" "$unstripped"
	exiftool -all:all="" "$unstripped" -o "$unlinearized"
	qpdf --linearize "$unlinearized" "$file"
	sudo gshred -f -u -v "$uncompressed"
	sudo gshred -f -u -v "$unstripped"
	sudo gshred -f -u -v "$unlinearized"
	sudo xattr -c -r "$file" 2>/dev/null
	sudo chmod -R -v -N "$file" 2>/dev/null
done
