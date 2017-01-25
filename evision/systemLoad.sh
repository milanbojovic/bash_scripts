#!/bin/bash

	cpuUsage(){
		top -bn1 | grep load | awk '{printf "\"CPU\" : { \"percentage\" : %.2f },\n", $(NF-2)}'
	};

	memUsage(){
		free -m | awk 'NR==2{printf "\"RAM\" : { \"USED\" : %s, \"TOTAL\" : %s, \"PERCENTAGE\" : %.2f},\n", $3/1024,$2/1024,$3*100/$2 }'
	};

	diskSizeUsage(){
		df | awk '$NF=="/"{printf "\"HDD\" : { \"USED\" : \"%s\", \"TOTAL\" : \"%s\", \"PERCENTAGE\" : %.2f},\n", $3/1024/1024,$2/1024/1024,$5}'
	};

	swapUsage(){
		free -m | awk 'NR==3{printf "\"SWAP\" : { \"USED\" : %s, \"TOTAL\" : %s, \"PERCENTAGE\" : %.2f},\n", $3/1024,$2/1024,$5}'
	};

	diskIOUsage(){
	    printf "\"devices\" : [\n"
             for i in "$(iostat -d | grep -vE "Linux|Device|^$")"; do
	 	echo "$i" | awk '{printf "{ \"NAME\" : \"%s\", \"TRANS PER SECOND/IOPS\" : %d, \"KB_READ/S\" : %d, \"KB_WRTN/S\" : %d, \"KB_READ\" : %d, \"KB_WRTN\" : %d },\n", $1, $2, $3, $4, $5, $6}';
	     done
	    printf "\n]"
	};

printf "\nDownload script started\n\n"

printf "{\n"
memUsage;

cpuUsage;

swapUsage;

diskSizeUsage;

diskIOUsage;

printf "\n};"



printf "\nDownload script finished\n\n"
