#!/bin/sh

DST_DIR=data

## replace internal field separators
IFS_BK="$IFS"
IFS=$'\n'

for fpath in `find . -type d -name "$DST_DIR" -prune -o -type f -name "*.txt" -print`; do
    filename=`echo $fpath | awk -F/ '{print $NF}'`

    if [ ! -f "$DST_DIR/$filename" ] ; then
	echo "$fpath > $DST_DIR/$filename"
	cp $fpath "$DST_DIR/$filename"
    fi
done

## restore internal field separators
ISF="$IFS_BK"
