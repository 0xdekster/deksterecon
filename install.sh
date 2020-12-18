echo "Installing required tools for SecNote"


echo "Installing Go"
wget https://golang.org/dl/go1.15.6.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
echo "done"

echo "Installing PIP"
apt-get update && apt-get install -y python3-pip
pip3 install chardet
pip3 install urllib3
pip3 install certifi
apt-get install libpcap-dev
echo "done"

echo "Installing Httprobe"
go get -u github.com/tomnomnom/httprobe
echo "done"

echo "Installing Waybackurls"
go get github.com/tomnomnom/waybackurls
echo "done"

echo "Installing Anew"
go get -u github.com/tomnomnom/anew
echo "done"

echo "Installing Naabu"
go get -u -v github.com/projectdiscovery/naabu/v2/cmd/naabu
echo "done"

echo "Installing Subfinder"
git clone https://github.com/projectdiscovery/subfinder.git
cd subfinder/v2/cmd/subfinder
go build .
mv subfinder /usr/local/bin/
cd ../../../../
echo "done"

echo "Installing MassDNS"
git clone https://github.com/blechschmidt/massdns.git
cd massdns
make
cd ..
mv massdns/bin/massdns /usr/local/bin/
echo "done"

echo "Installing Shuffledns"
go get -u -v github.com/projectdiscovery/shuffledns/cmd/shuffledns
echo "done"

echo "Installing Gau"
go get -u -v github.com/lc/gau
echo "done"

echo "Installing Httpx"
go get -u -v github.com/projectdiscovery/httpx/cmd/httpx
echo "done"

echo "Installing Findomain"
wget https://github.com/Edu4rdSHL/findomain/releases/latest/download/findomain-linux
chmod +x findomain-linux
echo "done"

echo "Installing Aquatone"
wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip
unzip aquatone_linux_amd64_1.7.0.zip
mv aquatone /usr/local/bin
sudo apt install -y chromium-browser
echo "done"

echo "Installing Dirsearch"
git clone https://github.com/maurosoria/dirsearch.git
cd dirsearch/
pip3 install -r requirements.txt
cd ..
echo "done"

echo "Installing Amass"
go get -v github.com/OWASP/Amass/v3/...
cd /root/go/src/github.com/OWASP/Amass
go install ./...
cd /deksterecon/
echo "done"
