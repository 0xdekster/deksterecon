#!/bin/bash

python3 dirsearch/dirsearch.py -l /var/www/html/$1-$3/$1-subdomains.txt -e php,html,json,aspx -w ./dirsearch/db/dicc.txt --random-agents -b -t 100 -x 301,302,400,403,400,429,307,305 --plain-text-report=/var/www/html/$1-$3/$1-dirsearch.txt
