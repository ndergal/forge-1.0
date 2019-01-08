#!/bin/bash

if [ "$(id -u)" != "0" ] ; then #if the user is not root
	echo "you should be root to use this script"
	exit 1
fi

############################################################ checking option #####################################################################
function usage(){
	printf "Script usage : \n\n"
	printf "\t--help or -h : Show this message.\n\n"
	printf "\tIt is possible to set environment variables to customize the installation.\n"
	printf "\tBy default those environment variables are :\n\n"
	printf "\t\t log_in = valilab \n"
        printf "\t\t password = rootroot \n"
        printf "\t\t name = admin \n"
        printf "\t\t lastname = forge \n"
        printf "\t\t address = admin@ign-forge.fr \n"
        printf "\t\t proxy = http://10.0.4.2:3128/ \n\n"
}

OPT=`getopt -o h --long help -- "$@"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

eval set -- "$OPT"

while true ; do
	case "$1" in
		-h|--help) usage ; exit 0 ;;
		--) shift ; break ;;
	esac
done

###################################### Setting information about user if not set in environment variable #########################################
if [ -z "$log_in" ] ; then
	echo "set log_in by default"
	log_in="valilab"
	export log_in
fi

if [ -z "$password" ] ; then
	echo "set password by default"
	password="rootroot"
	export password
fi

if [ -z "$name" ] ; then
	echo "set firstname by default"
	name="admin"
	export name
fi

if [ -z "$lastname" ] ; then
	echo "set lastname by default"
	lastname="forge"
	export lastname
fi

if [ -z "$address" ] ; then
	echo "set mail address by default"
	address="admin@ign-forge.fr"
	export address
fi

if [ -z "$proxy" ] ; then
	echo "set proxy by default"
	proxy="http://10.0.4.2:3128/"
	export proxy
fi

echo 
#####################################################################################################


echo $password > dokuwiki/pass.txt
echo $log_in > dokuwiki/log_in.txt
echo $name > dokuwiki/name.txt
echo $address > dokuwiki/address.txt
cat jenkins/scripts.groovy | envsubst > jenkins/user.groovy

SYSCTL=$(whereis systemctl | cut -d":" -f2)

if [ -z "$SYSCTL" ]; then #if SystemCTL is not installed
   if  ! grep -qF "$(cat proxy_registry_without_ctl.conf | envsubst)" /etc/default/docker ;then #if configuration are not written in the config file
	
	echo "$(cat proxy_registry_without_ctl.conf | envsubst)" >> /etc/default/docker
   fi
else    #if SystemCTL is installed
   if ! [ -f /etc/systemd/system/docker.service.d/settings.conf ] ;then #if the configuration file does not exist
	
    	echo "$(cat proxy_registry_with_ctl.conf | envsubst)" >> /etc/systemd/system/docker.service.d/settings.conf
   fi
fi

docker-compose up -d

while true; do
    RES=$(docker exec -ti forge_jenkins_1  java -jar war/WEB-INF/jenkins-cli.jar -s http://localhost:8080/ groovy user.groovy)
    if [ -z "$RES" ] ; then
	break
    fi
    sleep 1
done

exit 0
