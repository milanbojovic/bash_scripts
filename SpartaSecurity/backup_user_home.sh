#!/bin/bash

BACKUP_DIR="/home/$USER"
DEST_DIR="/tmp"
LOG_FILE="$backup.log"
S3_BUCKET="milanbojovic-backup-bucket"

printf "" 															| tee $DEST_DIR/$LOG_FILE
printf "===============================================================" 							| tee -a $DEST_DIR/$LOG_FILE
printf "\nBackup JOB started on: `date +%H:%M_%d.%m.%Y.`\n" 									| tee -a $DEST_DIR/$LOG_FILE
printf "===============================================================\n"							| tee -a $DEST_DIR/$LOG_FILE
printf "\nCompressing directory contents: "$BACKUP_DIR"\n\n" 									| tee -a $DEST_DIR/$LOG_FILE

BACKUP_FILE_NAME="backup_`date +%H:%M_%d.%m.%Y`.tar.gz"
tar -cvpzf "$DEST_DIR/$BACKUP_FILE_NAME" "$BACKUP_DIR" --exclude='.[^/]*'							| tee -a $DEST_DIR/$LOG_FILE

if [ $? -eq 0 ]; then
    printf "\nCompresssion successfull!\n"											| tee -a $DEST_DIR/$LOG_FILE
    printf "\nBackup file created: $BACKUP_FILE_NAME [size: `ls -lh $DEST_DIR/$BACKUP_FILE_NAME | awk '{ print $5 }'`]\n"	| tee -a $DEST_DIR/$LOG_FILE
    printf "\n==============================================================="							| tee -a $DEST_DIR/$LOG_FILE
    printf "\nUploading archive to S3 bucket: [$S3_BUCKET/$HOSTNAME/]\n" 							| tee -a $DEST_DIR/$LOG_FILE
    printf "===============================================================\n"							| tee -a $DEST_DIR/$LOG_FILE

    aws s3 cp $DEST_DIR/$BACKUP_FILE_NAME s3://$S3_BUCKET/$HOSTNAME/								| tee -a $DEST_DIR/$LOG_FILE
    aws s3 cp $DEST_DIR/$LOG_FILE s3://$S3_BUCKET/$HOSTNAME/$DEST_DIR/$BACKUP_FILE_NAME.log					| tee -a $DEST_DIR/$LOG_FILE

    if [ $? -eq 0 ]; then
	printf "\nUpload successfull!\n"											| tee -a $DEST_DIR/$LOG_FILE
    else
	printf "\nUpload failed!\n"												| tee -a $DEST_DIR/$LOG_FILE
    fi
else
    printf "\nCompresssion failed!\n"												| tee -a $DEST_DIR/$LOG_FILE
fi

printf "\n==============================================================="							| tee -a $DEST_DIR/$LOG_FILE
printf "\nBackup JOB finished on: `date +%H:%M_%d.%m.%Y.`\n"									| tee -a $DEST_DIR/$LOG_FILE
printf "===============================================================\n\n"							| tee -a $DEST_DIR/$LOG_FILE
