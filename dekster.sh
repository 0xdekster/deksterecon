#!/bin/bash

cat << "EOF"

██████╗ ███████╗██╗  ██╗███████╗████████╗███████╗██████╗ ███████╗ ██████╗ ██████╗ ███╗   ██╗
██╔══██╗██╔════╝██║ ██╔╝██╔════╝╚══██╔══╝██╔════╝██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║
██║  ██║█████╗  █████╔╝ ███████╗   ██║   █████╗  ██████╔╝█████╗  ██║     ██║   ██║██╔██╗ ██║
██║  ██║██╔══╝  ██╔═██╗ ╚════██║   ██║   ██╔══╝  ██╔══██╗██╔══╝  ██║     ██║   ██║██║╚██╗██║
██████╔╝███████╗██║  ██╗███████║   ██║   ███████╗██║  ██║███████╗╚██████╗╚██████╔╝██║ ╚████║
╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝
EOF

printf "\n"
echo "$(tput setaf 2)Running Automation to gather data on" $1

echo $1 | assetfinder -subs-only | grep -E "$1$" | httprobe > $1.hosts.txt | /root/./findomain-linux -t $1 | anew | httprobe > $1.hosts.txt
cat $1.hosts.txt | aquatone -out /var/www/html/deksterecon/$1/$1-aqua-out
nuclei -l $1.hosts.txt -t /root/nuclei-templates/*/*.yaml -o /var/www/html/deksterecon/$1/nuclei-$1.txt
for url in `cat $1.hosts.txt`; do gau $url | grep "\.js" | anew /var/www/html/deksterecon/$1/js-$1.txt; done
for end in `cat /var/www/html/deksterecon/$1/js-$1.txt`; do python3 /root/LinkFinder/linkfinder.py -i $end -o cli | anew /var/www/html/deksterecon/$1/endpoints-$1.txt; done
subjack -w $1.hosts.txt -t 100 -timeout 30 -o /var/www/html/deksterecon/$1/subjack-$1.txt -ssl -c /root/subjack/fingerprints.json
naabu -hL $1.hosts.txt -o /var/www/html/deksterecon/$1/ports-$1.txt
python3 /root/dirsearch/dirsearch.py --url-list=$1.hosts.txt -e php,html,zip,js,jar,jsp -x 301,401,302,400,403,402,500,529,429,405,407,503 --threads=50 anew --simple-report=/var/www/html/deksterecon/$1/dirsearch-$1.txt
