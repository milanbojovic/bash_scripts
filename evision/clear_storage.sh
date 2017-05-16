#!/bin/bash

echo "Clean storage script started"
dbDir="$TF_HOME/storage/databases/cortex/data"

if [ -e "$dbDir/current.xml" ]; then
	rm -f $dbDir/current.xml
fi

if [ -e "$dbDir/current.buffer" ]; then
    rm -f $dbDir/current.buffer
fi

if [ -e "$dbDir/initial.xml" ]; then
	cp $dbDir/initial.xml $dbDir/current.xml
fi

if [ "$?" -eq "0" ]; then
	echo "Done."
else
	echo "Something went wrong."
fi




