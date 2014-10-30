#!/bin/bash
JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
MOZILLA_HOME=~/.mozilla
mkdir $MOZILLA_HOME/plugins
ln -s $JAVA_HOME/jre/lib/amd64/libnpjp2.so $MOZILLA_HOME/plugins
