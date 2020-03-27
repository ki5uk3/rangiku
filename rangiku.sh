#!/bin/bash
#USE ./rangiku.sh [DOMAIN]
cd ~/
mkdir rangiku
cd rangiku
mkdir domains
mkdir ~/rangiku/domains/$1
cd ~/rangiku/domains/$1
tput setaf 2; echo "____________RUNNING FINDOMAIN__________"
tput sgr0
findomain-linux -t $1 -o
tput setaf 2; echo "____________RUNNING KNOCKPY__________"
tput sgr0
knockpy -c $1
tput setaf 2; echo "____________RUNNING SUBFINDER____________"
tput sgr0
subfinder -d $1 -t 100 -timeout 15 -o ~/rangiku/domains/$1/subfinder.txt
tput setaf 2; echo "____________SORTING DOMAINS____________"
tput sgr0
cat ~/rangiku/domains/$1/*.txt|sort -u|uniq -u >> ~/rangiku/domains/$1/uniq.txt
tput setaf 2; wc -l uniq.txt
tput sgr0
tput setaf 2; echo "_____________RUNNING HTTPROBE____________"
tput sgr0
cat uniq.txt|httprobe -c 40 > probe.txt
tput setaf 2; wc -l probe.txt
cat probe.txt|awk '{gsub("http://" , "");gsub("https://" , "");print}'|sort -u|uniq -u > fornmap.txt
tput setaf 2; echo "_____________RUNNING NMAP____________"
tput sgr0
nmap -F -iL fornmap.txt -oN ~/rangiku/domains/$1/nmapreport.txt
tput setaf 2; echo "__________RUNNING AQUATONE FOR WEB SCREENSHOTS_________"
tput sgr0
cat fornmap.txt|aquatone
tput setaf 2; echo "__________JOB DONE :)_Go_to ~/rangiku/domains_TO_SEE_RESULT________________"
tput sgr0
