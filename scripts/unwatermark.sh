#!/usr/bin/env bash

# check for prerequisites
for reqcmd in exiftool qpdf pdftk uNoWatermark.py
do
	command -v $reqcmd >/dev/null 2>&1 || { echo >&2 "I'm afraid this script won't be of much use to you if you don't have $reqcmd."; exit 1; }
done

while IFS= read -r -d '' item
do

	# get temporary filenames
	base=$(basename "$item")
	dir=$(dirname "$item")
	uncompressed=$dir/$RANDOM-$base
	unstripped=$dir/$RANDOM-$base
	unlinearized=$dir/$RANDOM-$base

	# uncompress pdf
	pdftk "$item" output "$uncompressed" uncompress

	# strip watermark
	uNoWatermark.py -f "$uncompressed" --no-backup -v

	# recompress pdf
	pdftk "$uncompressed" output "$item" compress

	# strip metadata
	cp -p "$item" "$unstripped"
	exiftool -all:all="" "$unstripped" -o "$unlinearized"
	qpdf --linearize "$unlinearized" "$item"

	# clean up
	rm -v "$uncompressed"
	rm -v "$unstripped"
	rm -v "$unlinearized"

done < <(find . -name '*.pdf' -print0)