#!/bin/bash

DEST_DIR="/tmp"
LOG_FILE="$DEST_DIR/backup.log"
S3_BUCKET="spartasecurity-backups"

#Function definitions
setBackupDir() {
		#Set BACKUP_DIR
		if [ "$HOSTNAME" == "sparta-01-natasa" ]; then
			BACKUP_DIR="/home/natasakovacevic";
		fi

		if [ "$HOSTNAME" == "sparta-02-deki" ]; then
			BACKUP_DIR="/home/dejanmladenovic";
		fi

		if [ "$HOSTNAME" == "sparta-03-zoka" ]; then
			BACKUP_DIR="/home/koc01";
		fi
};

setBackupDir;

printf "" 															| tee    $LOG_FILE
printf "===============================================================" 							| tee -a $LOG_FILE
printf "\nBackup JOB started on: `date +%H:%M_%d.%m.%Y.`\n" 									| tee -a $LOG_FILE
printf "===============================================================\n"							| tee -a $LOG_FILE
printf "\nCompressing directory contents: "$BACKUP_DIR"\n\n" 									| tee -a $LOG_FILE

BACKUP_FILE_NAME="backup_`date +%H:%M_%d.%m.%Y`.tar.gz"
tar -cvpzf "$DEST_DIR/$BACKUP_FILE_NAME" "$BACKUP_DIR" --exclude='.[^/]*'							| tee -a $LOG_FILE

if [ $? -eq 0 ]; then
    printf "\nCompresssion successfull!\n"											| tee -a $LOG_FILE
    printf "\nBackup file created: $BACKUP_FILE_NAME [size: `ls -lh $DEST_DIR/$BACKUP_FILE_NAME | awk '{ print $5 }'`]\n"	| tee -a $LOG_FILE
    printf "\n==============================================================="							| tee -a $LOG_FILE
    printf "\nUploading archive [$BACKUP_FILE_NAME] to S3 bucket: [$S3_BUCKET/$HOSTNAME/]\n" 					| tee -a $LOG_FILE
    printf "===============================================================\n"							| tee -a $LOG_FILE

    /usr/bin/aws s3 cp $DEST_DIR/$BACKUP_FILE_NAME s3://$S3_BUCKET/$HOSTNAME/							| tee -a $LOG_FILE
    /usr/bin/aws s3 cp $LOG_FILE s3://$S3_BUCKET/$HOSTNAME/${BACKUP_FILE_NAME%.tar.gz}.log					| tee -a $LOG_FILE

    if [ $? -eq 0 ]; then
	printf "\nUpload successfull!\n"											| tee -a $LOG_FILE
    else
	printf "\nUpload failed!\n"												| tee -a $LOG_FILE
    fi
else
    printf "\nCompresssion failed!\n"												| tee -a $LOG_FILE
fi

printf "\n==============================================================="							| tee -a $LOG_FILE
printf "\nBackup JOB finished on: `date +%H:%M_%d.%m.%Y.`\n"									| tee -a $LOG_FILE
printf "===============================================================\n\n"							| tee -a $LOG_FILE

#Moving log file to backup
mv $LOG_FILE $BACKUP_DIR/bash_scripts/backup_logs/${BACKUP_FILE_NAME%.tar.gz}.log

#Turn off pc after backup
#/sbin/shutdown -P now
