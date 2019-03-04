#! /bin/bash

TRIBEFIRE_URL=http://localhost:8080
TF_USER=cortex
TF_PASS=cortex
LOG_FILE="./initialization.log"

function awaitLineInLog {
	logFile=$1
	awaitString=$2

	tail -f $1 | while read LOGLINE
	do
	   [[ "${LOGLINE}" == *"$2"* ]] && pkill -P $$ tail
	done
}

#Authenticate
printf "" 																	| tee    $LOG_FILE
printf "===============================================================" 									| tee -a $LOG_FILE
printf "\nInit script started: `date +%H:%M_%d.%m.%Y.` by user: [`/usr/bin/whoami`]\n"                    					| tee -a $LOG_FILE
printf "===============================================================\n"									| tee -a $LOG_FILE
printf "\nFetching TF session: \n\n" 														| tee -a $LOG_FILE

#SESSION=$(curl -X POST -F "user=TF_USER" -F "password=$TF_PASS" $TRIBEFIRE_URL/tribefire-services/rest/authenticate | tr -d '"')		| tee -a $LOG_FILE
SESSION=$(curl -X POST -F "user=$TF_USER" -F "password=$TF_PASS" $TRIBEFIRE_URL/tribefire-services/rest/authenticate | tr -d '"')
echo "session: " $SESSION															


printf "\n==============================================================="									| tee -a $LOG_FILE
printf "\nDetecting cartridges: \n" 														| tee -a $LOG_FILE
printf "===============================================================\n"									| tee -a $LOG_FILE

curl -X POST -F "sessionId=$SESSION" -F 'accessId=cortex' -F 'name=DetectNew' $TRIBEFIRE_URL/tribefire-services/rest/action			| tee -a $LOG_FILE

printf "\n==============================================================="									| tee -a $LOG_FILE
printf "\nInvoking initialization action: \n"													| tee -a $LOG_FILE
printf "===============================================================\n"									| tee -a $LOG_FILE

curl -X POST $TRIBEFIRE_URL/tribefire-agiledocs-cartridge/initpage?action=init-tf								| tee -a $LOG_FILE

printf "\nInitialization completed:\n"	 													| tee -a $LOG_FILE
printf "===============================================================\n"									| tee -a $LOG_FILE
sleep 1;

printf "\n==============================================================="									| tee -a $LOG_FILE
printf "\nRebooting Tribefire\n"														| tee -a $LOG_FILE
printf "===============================================================\n"									| tee -a $LOG_FILE
printf "\nInvoking shutdown action: \n"														| tee -a $LOG_FILE
printf "===============================================================\n"									| tee -a $LOG_FILE

sh /tmp/tfinstall/tribefire/host/bin/shutdown.sh												| tee -a $LOG_FILE
awaitLineInLog "/tmp/tfinstall/tribefire/host/logs/catalina.out" "INFO    AjpProtocol                       'Destroying ProtocolHandler [";
printf "\nShutdown completed: \n"														| tee -a $LOG_FILE
printf "===============================================================\n"									| tee -a $LOG_FILE
sleep 2;

printf "\nInvoking startup action: \n"														| tee -a $LOG_FILE
printf "===============================================================\n"									| tee -a $LOG_FILE

sh /tmp/tfinstall/tribefire/host/bin/startup.sh													| tee -a $LOG_FILE
awaitLineInLog "/tmp/tfinstall/tribefire/host/logs/catalina.out" "Server startup in";
printf "\nStartup completed: \n"														| tee -a $LOG_FILE
printf "===============================================================\n"									| tee -a $LOG_FILE
sleep 2;

printf "\n==============================================================="									| tee -a $LOG_FILE
printf "\nInvoking configuration action:\n" 													| tee -a $LOG_FILE
printf "===============================================================\n"									| tee -a $LOG_FILE

curl $TRIBEFIRE_URL/tribefire-agiledocs-cartridge/initpage?action=conf-tf									| tee -a $LOG_FILE

printf "\n==============================================================="									| tee -a $LOG_FILE
printf "\nConfiguration completed\n" 														| tee -a $LOG_FILE
printf "===============================================================\n"									| tee -a $LOG_FILE

printf "\n==============================================================="							| tee -a $LOG_FILE
printf "\nInit script finished on: `date +%H:%M_%d.%m.%Y.`\n"									| tee -a $LOG_FILE
printf "===============================================================\n\n"							| tee -a $LOG_FILE

echo "Script execution finished !"

