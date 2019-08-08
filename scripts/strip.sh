#!/usr/bin/env bash

# check for prerequisites
for reqcmd in exiftool
do
	command -v $reqcmd >/dev/null 2>&1 || { echo >&2 "I'm afraid this script won't be of much use to you if you don't have $reqcmd."; exit 1; }
done

for file in "$@"; do
	exiftool -all:all= "$file" >/dev/null 2>&1
	sudo xattr -c -r "$file" 2>/dev/null
	sudo chmod -R -v -N "$file" 2>/dev/null
done
