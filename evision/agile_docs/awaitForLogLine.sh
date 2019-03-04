#! /bin/bash

function awaitLineInLog {
        logFile=$1
        awaitString=$2

        tail -f $1 | while read LOGLINE
        do
           [[ "${LOGLINE}" == *"$2"* ]] && pkill -P $$ tail
        done
}

awaitLineInLog "$1" "$2"
 
