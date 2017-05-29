#!/bin/bash

	printGreen(){
		printf "\n%s\n\n" "`tput smso``tput setf 2` $1 `tput sgr0`" | tee -a $log_file;
		sleep 2;
	};

	printRed(){
		printf "\n%s\n\n" "`tput smso``tput setf 4` $1 `tput sgr0`" | tee -a $log_file;
		sleep 2;
	};

	install(){
		printGreen "Installing $1:" | tee -a $log_file;
		sleep 2;
		apt-get update;
		apt-get install -y $1;
		status=$?;
		if [ $status -eq 0 ]; then
			printGreen "$1 installation completed successfully";
		else
			printRed "$1 installation FAILED" !!!;
		fi
	};

echo '';

log_file=install_script_log;

printGreen "Install script started" "Checking if user has ROOT privileges...";

if [ $UID -eq 0 ]; then

	#Repositories for updating of packages
	printGreen "Downloading GetDeb and PlayDeb";	
	sleep 1;
	wget http://archive.getdeb.net/install_deb/getdeb-repository_0.1-1~getdeb1_all.deb http://archive.getdeb.net/install_deb/playdeb_0.3-1~getdeb1_all.deb;

	printGreen "Installing GetDeb";
	sleep 1;
	dpkg -i getdeb-repository_0.1-1~getdeb1_all.deb;

	pringGreen "Installing PlayDeb";
	sleep 1;
	dpkg -i playdeb_0.3-1~getdeb1_all.deb;

	printGreen "Deleting Downloads";
	rm -f getdeb-repository_0.1-1~getdeb1_all.deb;
	rm -f playdeb_0.3-1~getdeb1_all.deb;
	printGreen "Deleting Downloads GetDeb and PlayDeb - installation compleete";
	sleep 1;

	install apache2;
	install skype;
	install dropbox;
	install tomcat7;

	#Adding GIT repository:
	echo | add-apt-repository ppa:git-core/ppa;
	install git;
	install maven;

	#Adding Gimp repository:
	echo | add-apt-repository ppa:otto-kesselgulasch/gimp;	

	install gimp;
	install gimp-data;
	install gimp-plugin-registry;
	install gimp-data-extras;

	install flashplugin-installer;

	#Adding repository JAVA
	echo | add-apt-repository ppa:webupd8team/java;
	install oracle-java7-installer;
	install eclipse;
	
	#Adding VLC repository:
	echo | add-apt-repository ppa:videolan/stable-daily;
	install vlc;

	printGreen "Installing DVD - encoding support for VLC:";
	sleep 1;
	echo 'deb http://download.videolan.org/pub/debian/stable/ /' | tee -a /etc/apt/sources.list.d/libdvdcss.list;
	echo 'deb-src http://download.videolan.org/pub/debian/stable/ /' | tee -a /etc/apt/sources.list.d/libdvdcss.list;
	wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc | apt-key add -;

	install libxine1-ffmpeg mencoder flac faac faad sox ffmpeg2theora libmpeg2-4 uudeview libmpeg3-1 mpeg3-utils mpegdemux liba52-dev mpeg2dec vorbis-tools id3v2 mpg321 mpg123 libflac++6 totem-mozilla icedax lame libmad0 libjpeg-progs libdvdcss2;
	install ubuntu-wallpapers;
	install ubuntu-restricted-extras;
	

	# For updates of some existing packages
	printGreen "Adding repository for gnome 3 library updates";
	echo | add-apt-repository -y ppa:gnome3-team/gnome3;
	status=$?;
	if [ $status -eq 0 ]; then
		printGreen "Gnome 3 library repo added successfully";
	else
		printRed "Gnome 3 library repo adding FAILED !!!";
	fi

	# suggestion from "howtoubuntu.org"
	printGreen "Adding repository for Oracle Java";

	echo | add-apt-repository -y ppa:webupd8team/y-ppa-managsudo add-apt-repository -y ppa:webupd8team/javaer;
	status=$?;
	if [ $status -eq 0 ]; then
		printGreen "Oracle Java repo added successfully";
	else
		printRed "Oracle Java repo adding FAILED !!!";
	fi

	#Upgrade all packages which can be upgraded
	printGreen "Updating and upgrading packages !!!";
	apt-get update;
	apt-get -y upgrade;


	##Cleanup !!!!!!!!!!!!
	printGreen "Cleaning Up";
	printf "\n%s\n\n" "" | tee -a $log_file;
	sleep 2;
	sudo apt-get -f install;
	sudo apt-get autoremove;
	sudo apt-get -y autoclean;
	sudo apt-get -y clean;

	printGreen "Script finished execution. Have a nice DAY!";
	exit 1;

else
	printRed "Error USER: '$USER' is not root.";

fi

printGreen "Script exiting";
