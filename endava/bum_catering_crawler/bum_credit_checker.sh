#!/bin/bash

#Bum catering google sheed cravler 
# This script checks if my money is decuced from my account on daily basis in regular manner (only 250 should be deduced)

script_dir=/home/milanbojovic/bash_scripts/endava/bum_catering_crawler/

#Read local cash balance history
old_balance=`cat "$script_dir"bum_credit`
echo "Old balance = $old_balance"

#Read current cash balance from web
new_balance=`curl "https://docs.google.com/spreadsheets/d/1nxl17cqeyCsTYNYJ2GmTPlBoWg49YAYhQaFnp359Cuw/pub?gid=79135872&single=true&output=csv" | grep -i "Milan B" | cut -d ',' -f2 | tr -d '\r' `
echo "New balance = $new_balance"

#Create difference variable
difference=$((old_balance - new_balance))
echo "Difference = $difference"

output_line_base="`date`, old_balance=$old_balance din, new_balance=$new_balance din, diff= $difference din.  --> "

#Analyze data and create log file
if [ $difference -lt 250 ]
then
	if [ $difference -ge 0 ]
	then
		output_line_full="$output_line_base OK"
		echo "$output_line_full" | tee -a "$script_dir"bum_credit_history
	else
		output_line_full="$output_line_base OK - !!!CREDIT ADDED!!!"
		echo "$output_line_full" | tee -a "$script_dir"bum_credit_history
	fi
else 
	output_line_full="$output_line_base ERROR"
	echo "$output_line_full" | tee -a "$script_dir"bum_credit_history
fi

#Write new balance to local balance file
echo $new_balance > "$script_dir"bum_credit

#Send email !
/usr/bin/mail -s "BUM INFO" milan.bojovic@endava.com << EOF

===========================================================================================
					DAILY BALANCE:
===========================================================================================
$output_line_full
===========================================================================================

EOF
