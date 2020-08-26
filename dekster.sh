#!/bin/bash

echo "$(tput setaf 2)Running Automation to gather data on" $1

mkdir /var/www/html/$1-$3

shuffledns -r /resolvers.txt -d $1 -w /subdomains.txt | anew /var/www/html/$1-$3/$1-subs.txt | /root/./findomain-linux -t $1 | anew /var/www/html/$1-$3/$1-subs.txt | subfinder -d $1 | anew /var/www/html/$1-$3/$1-subs.txt | shuffledns -r /resolvers.txt | anew /var/www/html/$1-$3/$1-subs.txt

if[$2 == port_scan]
then
sed -e 's|^[^/]*//||' -e 's|/.*$||' /var/www/html/$1-$3/$1-subdomains.txt | naabu -Pn | tee -a /var/www/html/$1-$3/ports-$1.txt
exit 0;
fi

if[$2 == screenshots]
then
cat /var/www/html/$1-$3/$1-subdomains.txt | /root/tools/./aquatone -out /var/www/html/$1-$3/$1-aqua-out
exit 0;
fi

sed -e 's|^[^/]*//||' -e 's|/.*$||' /var/www/html/$1-$3/$1-subs.txt | httprobe | anew /var/www/html/$1-$3/$1-subdomains.txt
rm /var/www/html/$1-$3/$1-subs.txt
cat /var/www/html/$1-$3/$1-subdomains.txt | httpx -status-code -title -json -o /var/www/html/$1-$3/$1-Httpx-output.json
cat /var/www/html/$1-$3/$1-subdomains.txt | /root/tools/./aquatone -out /var/www/html/$1-$3/$1-aqua-out
sed -e 's|^[^/]*//||' -e 's|/.*$||' /var/www/html/$1-$3/$1-subdomains.txt | naabu -Pn | tee -a /var/www/html/$1-$3/ports-$1.txt
subjack -w /var/www/html/$1-$3/$1-subdomains.txt -t 100 -timeout 30 -o /var/www/html/$1-$3/subjack-$1.txt -ssl -c /root/tools/subjack/fingerprints.json
for url in `cat /var/www/html/$1-$3/$1-subdomains.txt`; do gau $url | grep "\.js" | anew /var/www/html/$1-$3/js-$1.txt; done
python3 /root/tools/dirsearch/dirsearch.py --url-list=/var/www/html/$1-$3/$1-subdomains.txt -e php,html,js,jar -b -t 50 -x 301,302,401,503,407,402,400,403,404,500,405,407,429,406,504,503,502,403 --plain-text-report=/var/www/html/$1-$3/$1-dirsearch.txt;
cat /var/www/html/$1-$3/$1-dirsearch.txt | anew /var/www/html/$1-$3/$1-dirsearchPaths.txt;
rm /var/www/html/$1-$3/$1-dirsearch.txt;
