#!/bin/bash

rm -rf proj/misc.dir/*.jpg
cp -vrp patch/fs/* proj/

find "patch/patches/" -type f -name '*.patch' -print0 | sort -z | xargs -t -n 1 -0 patch -p0 --no-backup-if-mismatch -r - -i

tempfile=$(mktemp)

patches=$(find "patch/patches/" -type f -name '*.bbe' -print0 | sort -z)
for patch in $patches; do
 echo Patch: $patch
 file=$(head -n 1 $patch|cut -d# -f2)
 echo Patching: $file
 cp $file $tempfile
 bbe -f $patch -o $file $tempfile
done

rm $tempfile
