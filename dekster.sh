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
/root/./findomain-linux -t $1 | httprobe --prefer-https | anew /var/www/html/$1/$1-subdomains.txt
cat /var/www/html/$1/$1-subdomains.txt | /root/./aquatone -out /var/www/html/$1/$1-aqua-out
nuclei -l /var/www/html/$1/$1-subdomains.txt -t /root/nuclei-templates/*/*.yaml -o /var/www/html/$1/nuclei-$1.txt;
sed -e 's|^[^/]*//||' -e 's|/.*$||' /var/www/html/$1/$1-subdomains.txt | naabu -Pn | tee -a /var/www/html/$1/ports-$1.txt;
subjack -w /var/www/html/$1/$1-subdomains.txt -t 100 -timeout 30 -o /var/www/html/$1/subjack-$1.txt -ssl -c /root/subjack/fingerprints.json
for url in `cat /var/www/html/$1/$1-subdomains.txt`; do gau $url | grep "\.js" | anew /var/www/html/$1/js-$1.txt; done
for end in `cat /var/www/html/$1/js-$1.txt`; do python3 /root/LinkFinder/linkfinder.py -i $end -o cli | anew /var/www/html/$1/endpoints-$1.txt; done
for url in `cat /var/www/html/$1/$1-subdomains.txt`; do gau $url | dalfox url $url --silence -w 80 -o /var/www/html/$1/xss-$1.txt; done
python3 /root/dirsearch/dirsearch.py --url-list=/var/www/html/$1/$1-subdomains.txt -e php,html,js,jar -x 301,302,400,403,404,500,405,407,429  --plain-text-report=/var/www/html/$1/$1-dirsearch.txt;
cat /var/www/html/$1/$1-dirsearch.txt | anew /var/www/html/$1/$1-dirsearchPaths.txt;
rm /var/www/html/$1/$1-dirsearch.txt;
