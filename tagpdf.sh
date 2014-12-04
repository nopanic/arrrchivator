#!/bin/sh

files=`find $* -maxdepth 1 -print0 | xargs -0 -eof tmsu tags | grep ": \$" | tr -d ':'`

for file in $files; do

  mupdf $file 2>/dev/null &
  mupdf_pid=$!

  read -p "Tags: " tags
  tmsu tag $file $tags

  kill $mupdf_pid
  wait $mupdf_pid 2>/dev/null

done


# pdftotext *.pdf - | tr [:space:] '\n' | grep -v -E '[0-9]' | grep -Eo '[a-zA-Z]+' | grep -e '[^\ ]\{3,\}' | grep -ivwFf top10000de.txt | sort | uniq -ci | sort -rn | head -n 40 | column
