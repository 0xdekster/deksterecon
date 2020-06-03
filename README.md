# DEKSTERECON
Web Application recon automation , it aggregates your target results at one place so that the struggle of manually running each tool on single target/url will get removed and it helps to get a broader view of your attack surface.\
It takes a target domain as an input from the user and it gives  - Screenshots, JS, endpoints, subdomains, Valid paths, xss parameters, check for ports , check for Subdomain takeover , etc..

# Installation - 

1- Use this on a VPS having minimum 2GB ram.\
2- Make sure latest GO verison and python3 is installed on your vps.\
3- Install Apache web server - sudo apt install apache2 \
4- git clone https://github.com/0xdekster/deksterecon.git \
5- cd deksterecon\
6- chmod +x install.sh\
7- ./install.sh


# Usage - 

./deksterecon.sh target.com

![Screenshot](/screenshot.png)

# Thanks to the builders to these open-source tools\

1- [Eduard Tolosa](https://github.com/Edu4rdSHL/findomain)\
2- [Tomnomnom](https://github.com/tomnomnom)\
3- [Hahwul](https://github.com/hahwul/dalfox)\
4- [Michen riksen](https://github.com/michenriksen/aquatone)\
5- [Project Discovery](https://github.com/projectdiscovery)\
6- [Corben Leo](https://github.com/projectdiscovery)
