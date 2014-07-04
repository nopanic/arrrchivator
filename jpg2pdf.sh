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
#   jpg2pdf [OPTION]... [SOURCE]
#
#     -c
#        no ocr
#
# Output: searchable (multipage) PDF-files
#############################################################
usage() { echo "Usage: $0 [-c] [SOURCE]... -- convert jpg to PDF files (opt: ocr)" 1>&2; exit 1; }

DIR=$1
OCR='/opt/OCRmyPDF/'
NOCR=false

while getopts ":c" opt; do
  case $opt in
    c)
      NOCR=true
      ;;
    *)
      usage
      ;;
  esac
done
shift $(($OPTIND - 1))

for f in $*; do
  echo Working on $f
  if [ -d "$f" ]; then
    if `convert $f/* $f.pdf`; then
      if [ "$NOCR" = false ]; then
        sh $OCR/OCRmyPDF.sh -l "deu" $f.pdf $f.pdf
      fi
      echo Created $f.pdf
    else
      echo ERROR: Creation of $f failed!
    fi
  else
    NAME=`echo $f | cut -d. -f1`
    if `convert $f $NAME.pdf`; then
      if [ "$NOCR" = false ]; then
        echo OCR... NOCR= $NOCR
        sh /opt/OCRmyPDF/OCRmyPDF.sh -l "deu" $NAME.pdf $NAME.pdf
      fi
      echo Created $f.pdf
    else
      echo ERROR: Creation of $f failed!
    fi
  fi
done
