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
# 
# Output: named PDF
######################################################################

usage() { echo "Usage: $0 [-d|-a] [-c] [PDF-SOURCE]... -- script to individually name pdfs echo." 1>&2; exit 1; }

MODE=interacitve
COMMENT=false
while getopts ":dach" opt; do
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
        *)
            usage
            ;;
    esac
done
shift $(($OPTIND - 1))


