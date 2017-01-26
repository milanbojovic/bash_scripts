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
	    disks="$(iostat -d | grep -vE "Linux|Device|^$")"
	    cnt=0;

	    echo "$disks" | while IFS= read -r disk
	    do
		((cnt=cnt+1))
		if [ $cnt -ne 1 ]; then
		    printf ",\n"
		fi
		echo "$disk" | awk '{printf "{ \"NAME\" : \"%s\", \"TRANS PER SECOND/IOPS\" : %d, \"KB_READ/S\" : %d, \"KB_WRTN/S\" : %d, \"KB_READ\" : %d, \"KB_WRTN\" : %d }", $1, $2, $3, $4, $5, $6}'
	    done
	    printf "\n]"
	};

printf "{\n"

memUsage;
cpuUsage;
swapUsage;
diskSizeUsage;
diskIOUsage;

printf "\n};"
