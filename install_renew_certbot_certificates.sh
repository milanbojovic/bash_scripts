#!/bin/bash

# Example running command:
#/root/install_renew_certbot_certificates.sh /home/ec2-user/firejournal/adx/firejournal/tribefire/host core-dev.agiledox.click support.agile-documents@braintribe.com /home/ec2-user/firejournal/adx/jdk/jdk1.8.0_171_linux/jre/bin
# Crontab entry: 
#* * * jan,mar,may,jul,sep,nov *  /root/install_renew_certbot_certificates.sh /home/ec2-user/firejournal/adx/firejournal/tribefire/host core-dev.agiledox.click support.agile-documents@braintribe.com /home/ec2-user/firejournal/adx/jdk/jdk1.8.0_171_linux/jre/bin

#Modify following lines and make sure to execute your script as root
#TF_DIR=/home/ec2-user/firejournal/adx/firejournal/tribefire/host
#DNS=firejournal.agiledox.click
#myemail=milan.bojovic@braintribe.com
#keytooldir=/home/ec2-user/firejournal/adx/jdk/jdk1.8.0_171_linux/jre/bin #java keytool located in jre/bin
TF_DIR=$1
DNS=$2
myemail=$3
keytooldir=$4
#******************************************************************************************************
#   FUNCTION NAME: validatePreconditions
#   DESCRIPTION:   Function validates if program passed as argument is installed on system
#   SYNOPSIS:      validatePreconditions "program1" "program2" "program2"
#   EXAMPLE USAGE: validatePreconditions "zip" "unix2dos" "cp"
#******************************************************************************************************

validatePreconditions() {
    for program in "$@"
    do
        if [[ $program == "fontconfig" ]] ; then
            if [[ `ldconfig -p | grep fontconfig | wc -l` == "0" ]] ; then
                printf "\nPreconditions check failed: Program: $program not installed.\n"
                exit 2;
            else
                printf "\n\tprogram $program installed\n"
            fi
        else
            if ! hash $program 2>/dev/null; then
                printf "\nPreconditions check failed: Program: $program not installed.\n"
                exit 2;
            else
                printf "\n\tprogram $program installed\n"
            fi
        fi
    done
};

validatePreconditions "cd" "git" "iptables" "rm" "cp" "chown"

cd /tmp
git clone https://github.com/certbot/certbot

CB_DIR=/tmp/certbot
certdir=/etc/letsencrypt/live/$DNS #just replace the domain name after /live/
mydomain=$DNS #put your domain name here
networkdevice=eth0 #your network device  (run ifconfig to get the name)
keystoredir=$TF_DIR/conf/cortex.jks #located in home dir of user that you Tomcat is running under - just replace jira with your user you use for Tomcat, see ps -ef to get user name if you do not know

#the script itself:
cd $CB_DIR

iptables -I INPUT -p tcp -m tcp --dport 9999 -j ACCEPT
iptables -t nat -I PREROUTING -i $networkdevice -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 9999

./certbot-auto certonly --standalone --test-cert --break-my-certs -d $mydomain --standalone-supported-challenges http-01 --http-01-port 9999 --renew-by-default --email $myemail --agree-tos
#./certbot-auto certonly --standalone -d $mydomain --standalone-supported-challenges http-01 --http-01-port 9999 --renew-by-default --email $myemail --agree-tos

iptables -t nat -D PREROUTING -i $networkdevice -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 9999
iptables -D INPUT -p tcp -m tcp --dport 9999 -j ACCEPT

#Generate keystore
rm $TF_DIR/conf/cortex.jks
$keytooldir/keytool -genkey -v -keystore $TF_DIR/conf/cortex.jks -dname "cn=Milan Bojovic, ou=Agile Documents, o=Braintribe, l=Belgrade, st=Serbia c=RS" -storepass cortex -alias tomcat -keypass cortex
$keytooldir/keytool -delete -alias tomcat -storepass cortex -keystore $keystoredir

openssl pkcs12 -export -in $certdir/fullchain.pem -inkey $certdir/privkey.pem -out $certdir/cert_and_key.p12 -name tomcat -CAfile $certdir/chain.pem -caname root -password pass:cortex

$keytooldir/keytool -importkeystore -srcstorepass cortex -deststorepass cortex -destkeypass cortex -srckeystore $certdir/cert_and_key.p12 -srcstoretype PKCS12 -alias tomcat -keystore $keystoredir
$keytooldir/keytool -import -trustcacerts -alias root -deststorepass cortex -file $certdir/chain.pem -noprompt -keystore $keystoredir

#Copy keys to target dir

cp $certdir/cert.pem $TF_DIR/conf/
cp $certdir/privkey.pem $TF_DIR/conf/key.pem
sudo chown ec2-user:ec2-user $TF_DIR/conf/cortex.jks
