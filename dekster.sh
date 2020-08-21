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

mkdir /var/www/html/$1
shuffledns -r /root/resolvers.txt -d paytm.com -w /root/wordlist/subdomains.txt | anew /var/www/html/$1/$1-subdomains.txt | ./findomain-linux -t paytm.com | anew /var/www/html/$1/$1-subdomains.txt | subfinder -d paytm.com | anew /var/www/html/$1/$1-subdomains.txt | httprobe --prefer-https | anew /var/www/html/$1/$1-subdomains.txt
cat /var/www/html/$1/$1-subdomains.txt | /root/tools/./aquatone -out /var/www/html/$1/$1-aqua-out
sed -e 's|^[^/]*//||' -e 's|/.*$||' /var/www/html/$1/$1-subdomains.txt | naabu -Pn | tee -a /var/www/html/$1/ports-$1.txt
nuclei -l /var/www/html/$1/$1-subdomains.txt -t /root/tools/nuclei-templates/*/*.yaml -o /var/www/html/$1/nuclei-$1.txt
subjack -w /var/www/html/$1/$1-subdomains.txt -t 100 -timeout 30 -o /var/www/html/$1/subjack-$1.txt -ssl -c /root/tools/subjack/fingerprints.json
for url in `cat /var/www/html/$1/$1-subdomains.txt`; do gau $url | grep "\.js" | anew /var/www/html/$1/js-$1.txt; done
python3 /root/dirsearch/dirsearch.py --url-list=/var/www/html/$1/$1-subdomains.txt -e php,html,js,jar -x 301,302,400,403,404,500,405,407,429  --plain-text-report=/var/www/html/$1/$1-dirsearch.txt;
cat /var/www/html/$1/$1-dirsearch.txt | anew /var/www/html/$1/$1-dirsearchPaths.txt;
rm /var/www/html/$1/$1-dirsearch.txt;
