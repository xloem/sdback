#!/usr/bin/env bash

DESTROOT="$HOME/storage/external-1/sdback"

# move out .git folders under home

pushd "$HOME"/..

find -xdev -name .git -type d | while read dir
do
	mkdir -p "${DESTROOT}/$(dirname "$dir")" &&
	mv "$dir" -v "$DESTROOT"/"$dir" &&
	ln -vs "$DESTROOT"/"$dir" "$dir" || exit 1
done
