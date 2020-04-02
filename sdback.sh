#!/usr/bin/env bash

DESTROOT="$HOME/storage/external-1/sdback"
for DIR in "$@"
do
popd
SRCDIR="$(readlink -m "${DIR%/}")/"

# move out .git folders under home

pushd "$HOME"/..
SRCROOT="$(readlink -m ".")"
SRCDIR="${SRCDIR#$SRCROOT/}"
echo SRCDIR="$SRCDIR"

if [ "$SRCDIR" = "" ]
then

find -xdev -name .git -type d | while read dir
do
	mkdir -vp "${DESTROOT}/$(dirname "$dir")" &&
	mv "$dir" "$DESTROOT"/"$dir" &&
	ln -vs "$DESTROOT"/"$dir" "$dir" || exit 1
done

else
	if [ "$(find "$SRCDIR" -type l -quit)" != "" ]; then echo fail "$SRCDIR" symlink; continue; fi
	if [ "$(find "$SRCDIR" -type f -executable -quit)" != "" ]; then echo fail "$SRCDIR" executable; continue; fi
	if [ "$(find "$SRCDIR" -name '*:*' -quit)" != "" ]; then echo fail "$SRCDIR" contains : in filename; continue; fi
	mkdir -p "${DESTROOT}/$SRCDIR" &&
	cp -a "$SRCDIR"/. "$DESTROOT"/"$SRCDIR"/. &&
	rm -rf "$SRCDIR" &&
	ln -vs "$DESTROOT"/"$SRCDIR" "${SRCDIR%/}" || exit 1
fi


done
