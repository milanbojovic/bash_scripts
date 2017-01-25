#!/bin/bash

#Variables
es='elasticsearch-5.0.1'
ls='logstash-5.0.1'
kibana='kibana-5.0.1'

dstEs='elastic'
dstLs='logstash'
dstKibana='kibana'

#Save Current working dir address
pushd .
cd ~/install/ELK

printf "\nDownload script started\n\n"

#Files for Linux
printf "\nDownloading Elastic search archive\n\n"
wget https://artifacts.elastic.co/downloads/elasticsearch/"${es}".tar.gz

printf "\nDownloading Logstash  archive\n\n"
wget https://artifacts.elastic.co/downloads/logstash/"${ls}".tar.gz

printf "\nDownloading Kibana search archive\n\n"
wget https://artifacts.elastic.co/downloads/kibana/"${kibana}"-linux-x86_64.tar.gz

tar -xvzf "${es}".tar.gz
tar -xvzf "${ls}".tar.gz
tar -xvzf "${kibana}"-linux-x86_64.tar.gz

mv "${es}" "${dstEs}"
mv "${ls}" "${dstLs}"
mv "${kibana}"-linux-x86_64 "${dstKibana}"

rm "${es}".tar.gz "${ls}".tar.gz "${kibana}"-linux-x86_64.tar.gz

#Restore old working dir
popd


printf "\nDownload script finished\n\n"
