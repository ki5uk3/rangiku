#!/bin/bash
#USE ./rangiku.sh [DOMAIN]
cd ~/
mkdir rangiku
cd rangiku
mkdir domains
mkdir ~/rangiku/domains/$1
cd ~/rangiku/domains/$1
tput setaf 6; echo "____________RUNNING FINDOMAIN__________"
tput sgr0
findomain-linux -t $1 -o
tput setaf 6; echo "____________RUNNING KNOCKPY__________"
tput sgr0
knockpy -c $1 ; cat *.csv|awk '{gsub("," , "  ");print$4;print$3}'|grep $1 |tee -a knock.txt
tput setaf 6; echo "____________RUNNING ASSETFINDER__________"
tput sgr0
assetfinder --subs-only $1 |sort -u|awk '{gsub("*." , "");print}'|tee -a asset.txt
tput setaf 6; echo "____________RUNNING AMASS__________"
tput sgr0
amass enum -passive -d $1 -silent -o ~/rangiku/domains/$1/amass.txt
tput setaf 6; echo "____________RUNNING SUBFINDER____________"
tput sgr0
subfinder -d $1 -t 100 -timeout 15 -o ~/rangiku/domains/$1/subfinder.txt
tput setaf 6; echo "____________SORTING DOMAINS____________"
tput sgr0
cat ~/rangiku/domains/$1/*.txt|sort -u|uniq -u > ~/rangiku/domains/$1/uniq.txt
tput setaf 6; echo Hi "found $(wc -l uniq.txt)"
tput sgr0
tput setaf 6; echo "_____________RUNNING HTTPROBE____________"
tput sgr0
cat uniq.txt|httprobe -c 50 |tee -a probe.txt
tput setaf 6; echo "found $(wc -l probe.txt)"
tput setaf 6; echo "___________Running Nuclei____________"
tput sgr0
nyc -c 200 -t "/home/ubuntu/go/bin/cves/*.yaml" -l probe.txt -o nycOPT.txt
cat probe.txt|awk '{gsub("http://" , "");gsub("https://" , "");print}'|sort -u|uniq -u > fornmap.txt
tput setaf 6; echo "_____________RUNNING NMAP____________"
echo total "domains $(wc -l fornmap.txt)"
tput sgr0
nmap -T 5 -iL fornmap.txt -Pn --script=http-enum --script=http-title -p80,443,8005,4443,4080,8080,8081,9300,9200,22,21,2222 --open|tee -a ~/rangiku/domains/$1/nmapreport.txt
tput setaf 2; echo "________________JOB DONE :)________________"
tput sgr0