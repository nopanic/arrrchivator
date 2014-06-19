pdftotext *.pdf - | tr [:space:] '\n' | grep -v -E '[0-9]' | grep -Eo '[a-zA-Z]+' | grep -e '[^\ ]\{3,\}' | grep -ivwFf top10000de.txt | sort | uniq -ci | sort -rn | head -n 40 | column
