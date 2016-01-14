#******	Author ******
#******	Milan Bojovic ******
#****** Endava ******
#!/bin/bash

#Bum catering google sheed cravler 
# This script checks if my money is decuced from my account on daily basis in regular manner (only 250 should be deduced)

#Read local cash balance history
old_balance=`cat ./bum_credit`
echo "Old balance = $old_balance"

#Read current cash balance from web
new_balance=`curl "https://docs.google.com/spreadsheets/d/1nxl17cqeyCsTYNYJ2GmTPlBoWg49YAYhQaFnp359Cuw/pub?gid=79135872&single=true&output=csv" | grep -i "Milan B" | cut -d ',' -f2 | tr -d '\r' `
echo "New balance = $new_balance"

#Create difference variable
let difference=old_balance-new_balance
echo "Difference = $difference"


#Analyze data and create log file
if (( $difference <= 250 )); then
	if (( $difference >= 0 )); then
		echo "`date`, old_balance=$old_balance din, new_balance=$new_balance din, diff=$difference din.  -->  OK" | tee -a ./bum_credit_history
	else
		echo "`date`, old_balance=$old_balance din, new_balance=$new_balance din, diff=$difference din.  -->  OK - !!!CREDIT ADDED!!!" | tee -a ./bum_credit_history
	fi
else 
	echo "`date`, old_balance=$old_balance din, new_balance=$new_balance din, diff=$difference din.  -->  ERROR" | tee -a ./bum_credit_history
fi

#Write new balance to local balance file
echo $new_balance > bum_credit


#Send email !
