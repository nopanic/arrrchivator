#!/bin/bash
# Author: Raffael Link <raffaellink@gmail.com>
#
# archivatepdf: individually name pdfs
# 
# There are two running numbers. The first is for PDFs which are kept
# as paper. The second is for PDFs without an analog copy. The
# highest current numbers are kept in a configuration file.
# 
# Naming confention:
# 
# The first letters distinguishes between digital (D) and analag (A)
# files.
# The name can be followed by a comment/title, which starts with an
# underscore. It is important to note, that digital and analog running
# numbers are not dependent. This is to keep analog numbers small and
# easy to apply on die analog copies.
#
# Example:
# IMG_01123.PDF -> A23.pdf
# IMG_01124.PDF -> D215.pdf
# IMG_1230.PDF -> D216_Kommentar.pdf
#
# Input: archivatepdf [OPTION]... [SOURCE-PDF]...
#
#   -d
#       all digital copies
#   -a
#       all analog copies
#   -c
#       add comments for each file
#   -s
#       show pdfs with mupdf
# 
# Output: named PDF
######################################################################
INI=archivatepdf.ini

usage() { echo "Usage: $0 [-d|-a] [-c] [-s] [PDF-SOURCE]... -- script to index pdfs." 1>&2; exit 1; }

MODE=interactive
COMMENT=false
SHOW=false
while getopts ":dachs" opt; do
    case $opt in
        d)
            MODE=digital
            ;;
        a)
            MODE=analog
            ;;
        c)
            COMMENT=true
            ;;
        s)
            SHOW=true
            ;;
        *)
            usage
            ;;
    esac
done
shift $(($OPTIND - 1))

if [ -e $INI ]; then
    ID_digital=$(awk -F "= " '/ID_digital/ {print $2}' $INI)
    ID_analog=$(awk -F "= " '/ID_analog/ {print $2}' $INI)
else
    echo "ERROR: Cannot find ini-file: $INI" 1>&2;
    exit 1;
fi

for file in $*; do

    if [ $file == $INI ]; then
        continue
    fi

    echo "Processing $file"

    if $SHOW; then
        mupdf $file 2>/dev/null &
        mupdf_pid=$!
    fi
    
    analog="n"
    if [ $MODE == "interactive" ]; then
        read -s -n 1 -p "Keep an analog copy? (y/n) " analog
        echo
    fi
    
    if [ $analog == "y" ] || [ $MODE == "analog" ]; then
        ((ID_analog++))
        filename="A$ID_analog";
    else
        ((ID_digital++))
        filename="D$ID_digital";
    fi

    if $COMMENT; then
        read -p "Please add a comment/title for this file: " comment
        echo 
        [[ $comment ]] && filename+="_"${comment}
    fi
    filename+=".pdf"
    
    mv $file $filename
    
    if $SHOW && kill -0 $mupdf_pid >/dev/null 2>&1; then
        kill $mupdf_pid
        wait $mupdf_pid 2>/dev/null
    fi
    
    echo "Renamed file to: $filename"
    echo "---------------------------"
    echo
done

echo "ID_digital = $ID_digital">$INI
echo "ID_analog  = $ID_analog">>$INI

exit 0;
