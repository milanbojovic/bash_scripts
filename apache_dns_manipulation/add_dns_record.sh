#!/bin/bash

#******************************************************************************************************
printf "\n***********************************\n"
printf "\nADD_DNS_RECORD script initiated\n"
printf "\n***********************************\n\n\n"
#******************************************************************************************************

read -r -p "DNS RECORD  - DNS record which will be created? " DNS_RECORD
read -r -p "SERVER IP   - where DNS should point to?        " IP_ADDRESS
read -r -p "SERVER PORT - where DNS should point to?        " PORT

DNS_RECORD=${DNS_RECORD,,} # tolower
IP_ADDRESS=${IP_ADDRESS,,} # tolower
PORT=${PORT,,} # tolower

if [ -z "$DNS_RECORD" ]; then
	echo "DNS RECORD: cannot be empty"
	echo "ERROR - exiting"
	exit 1;
fi


if [ -z "$IP_ADDRESS" ]; then
	echo "SERVER IP: cannot be empty"
	echo "ERROR - exiting"
	exit 1;
fi

if [ -z "$PORT" ]; then
	echo "SERVER PORT: cannot be empty"
	echo "ERROR - exiting"
	exit 1;
fi

printf "\n\nUser provided following data:\n"
printf "\nDNS_RECORD=$DNS_RECORD"
printf "\nIP_ADDRESS=$IP_ADDRESS"
printf "\nPORT=$PORT\n\n"

read -r -p "Do you want to proceed? [Y/n]" CHOICE

if [[ $CHOICE =~ ^(yes|y| ) ]] || [[ -z $CHOICE ]]; then
    echo "ADD_DNS_RECORD script proceeding"

	FILE_1=$DNS_RECORD.conf
	FILE_2=${DNS_RECORD%".com"}-le-ssl.com.conf

	TMP_FILE_1=/tmp/$FILE_1
	TMP_FILE_2=/tmp/$FILE_2

	printf "\nCreating files\n$TMP_FILE_1\n$TMP_FILE_2\n"
	cp templates/template.conf $TMP_FILE_1
	cp templates/template-le-ssl.com.conf $TMP_FILE_2

	printf "\nReplacing placeholders with provided data\n"
	sed -i "s/DNS_PLACEHOLDER/$DNS_RECORD/" $TMP_FILE_1 $TMP_FILE_2
	sed -i "s/IP_PLACEHOLDER/$IP_ADDRESS/" $TMP_FILE_1 $TMP_FILE_2
	sed -i "s/PORT_PLACEHOLDER/$PORT/" $TMP_FILE_1 $TMP_FILE_2

	printf "\nCopying config files to apache sites-available directory\n"
	mv $TMP_FILE_1 /etc/apache2/sites-available/
	mv $TMP_FILE_2 /etc/apache2/sites-available/

	printf "\nEnabling dns records:\n"
	a2ensite $FILE_1 $FILE_2

	printf "\n\nRELOADING APACHE2 WEBSERVER\n"
	systemctl reload apache2
fi

#******************************************************************************************************
printf "\n***********************************\n"
printf "\nADD_DNS_RECORD script finished\n"
printf "\n***********************************\n"
#******************************************************************************************************
