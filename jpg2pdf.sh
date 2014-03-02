#!/bin/bash
# Author: Raffael Link <raffaellink@gmail.com>
#
# jpg2pdf: Import scans by binding them to searchable pdfs
#
# Input: A list of jpg-files and folders. A single
# 	     jpg file is one PDF. jpg-files in a folder are a
#	     multi-page PDF. Multipage-PDF jpgs have to be named
#	     in lexical order.
#
# Output: searchable (multipage) PDF-files
#############################################################

DIR=$1
OCR='/opt/OCRmyPDF/'

for f in $*; do
  echo Working on $f
  if [ -d "$f" ]; then
    echo This is a directory... creating multipage PDF.
    if `convert $f/* $f.pdf`; then
      sh $OCR/OCRmyPDF.sh -l "deu" $f.pdf $f.pdf
      echo Created $f.pdf
    else
      echo ERROR: Creation of $f failed!
    fi
  else
    NAME=`echo $f | cut -d. -f1`
    if `convert $f $NAME.pdf`; then
      sh /opt/OCRmyPDF/OCRmyPDF.sh -l "deu" $NAME.pdf $NAME.pdf
      echo Created $f.pdf
    else
      echo ERROR: Creation of $f failed!
    fi
  fi
done
