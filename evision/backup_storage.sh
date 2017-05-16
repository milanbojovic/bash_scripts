#!/bin/bash

TRIBEFIRE_HOME=$($TF_HOME)
SRC_DIR="storage"
DEST_DIR="storage_backups"

#Create destination dir if missing
if [ ! -d "$TRIBEFIRE_HOME/$DEST_DIR" ]; then
	mkdir "$TRIBEFIRE_HOME/$DEST_DIR"
fi

tar -cvpzf "/home/evision/Dropbox/Evision/Dropbox/milan_bojovic_storage_backups/storage_backup_`date +%Y_%m_%d_%H_%M_%S`.tar.gz" "$TRIBEFIRE_HOME/$SRC_DIR/"
