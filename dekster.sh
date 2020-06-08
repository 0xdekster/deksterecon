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

echo $1 | assetfinder --subs-only | grep -E "$1$" | anew | httprobe --prefer-https > $1.hosts.txt | /root/./findomain-linux -t $1 | anew | httprobe --prefer-https > $1.hosts.txt
cat $1.hosts.txt | /root/./aquatone -out /var/www/html/$1/$1-aqua-out
nuclei -l $1.hosts.txt -t /root/nuclei-templates/*/*.yaml -o /var/www/html/$1/nuclei-$1.txt;
sed -e 's|^[^/]*//||' -e 's|/.*$||' $1.hosts.txt | naabu -Pn | tee -a /var/www/html/$1/ports-$1.txt;
subjack -w $1.hosts.txt -t 100 -timeout 30 -o /var/www/html/$1/subjack-$1.txt -ssl -c /root/subjack/fingerprints.json
for url in `cat $1.hosts.txt`; do gau $url | grep "\.js" | anew /var/www/html/$1/js-$1.txt; done
for end in `cat /var/www/html/$1/js-$1.txt`; do python3 /root/LinkFinder/linkfinder.py -i $end -o cli | anew /var/www/html/$1/endpoints-$1.txt; done
for url in `cat $1.hosts.txt`; do gau $url | dalfox url $url --silence -w 80 -o /var/www/html/$1/xss-$1.txt; done
for host in `cat $1.hosts.txt`; do ffuf -u $host/FUZZ  -w /root/dirsearch/db/dicc.txt -s -mc 200 -o /var/www/html/$1/ffuf-$1.json; done
