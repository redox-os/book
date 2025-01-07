#!/usr/bin/env bash

cd src
files="$(echo *.md)"

unused=0

for file in $files
do
    if [ $file == SUMMARY.md ]
    then
        continue
    fi
    if ! grep $file --silent SUMMARY.md
    then
        echo  "$file is not in SUMMARY.md"
        unused=1
    fi
done

if [ $unused == 0 ]
then
    echo "Success: No unused pages."
else
    echo "ERROR: There are unused pages. Add them to SUMMARY.md or remove them."
fi

exit $unused