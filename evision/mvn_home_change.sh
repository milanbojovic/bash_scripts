#! /bin/bash

# for MAVEN_HOME_1 specify 1 as a script parameter - PITS TOOLS
# for MAVEN_HOME_2 specify 2 as a script parameter - DATALAB

# new maven home variable
MAVEN_HOME_1=M2_HOME=/usr/share/maven
MAVEN_HOME_2=M2_HOME=/home/evision/tools/maven
CHOICE=$1

function replaceEnvironmentVar {
	# sed format "substitute@pattern@replacement@" fileNameinWitchToLookFor pattern
	# @because of embeded parametar (default is /) 
	sed -i "s@M2_HOME=.*@$1@" "/home/$USER/.bashrc"
	echo $1
}

if [ "$CHOICE" = '1' ]; then
	echo "New Maven Home is $MAVEN_HOME_1"
	replaceEnvironmentVar $MAVEN_HOME_1
else
	echo "New Maven Home is $MAVEN_HOME_2"
	replaceEnvironmentVar $MAVEN_HOME_2
fi

source "/home/$USER/.bashrc"
