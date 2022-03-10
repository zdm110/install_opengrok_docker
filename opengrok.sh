#!/bin/bash

GROKPATH=~/workd/opengrok
CONTAINER_NAME=opengrok-sunny
PORT=8888
REINDEX="0"

function pr_info()
{
	echo -e "\033[32m" $1 "\033[0m"
}

# install docker community edition and pull opengrok official image
function install()
{
	#sudo apt install -y curl
	#sudo apt remove docker docker-engine docker.io containerd runc
	#curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	#sudo apt-key fingerprint 0EBFCD88
	#sudo add-apt-repository \
	#   "deb [arch=amd64] https://download.docker.com/linux/debian \
	#   $(lsb_release -cs) \
	#   stable"
	#sudo apt update
	#sudo apt-get install -y docker-ce docker-ce-cli containerd.io
	docker pull oakchen/opengrok
	mkdir -p $GROKPATH/etc
	mkdir -p $GROKPATH/data
	mkdir -p $GROKPATH/src
	pr_info "\nDone!"
}

function run()
{
	echo "check exist docker opengrok..."
	docker stop $CONTAINER_NAME
	docker rm $CONTAINER_NAME

	echo "run docker image oakchen/opengrok:latest"
	docker run -d --restart=always \
	    --name $CONTAINER_NAME \
	    -p 8888:8080 \
	    -v $GROKPATH/src:/opengrok/src \
	    -v $GROKPATH/data:/opengrok/data \
	    -e NOMIRROR=1 \
	    -e SYNC_PERIOD_MINUTES=0 \
	    oakchen/opengrok:latest
	pr_info "\n oakchen/opengrok running."	
}

# Reindex When you add some new Project 
function reindex()
{
	#docker exec $CONTAINER_NAME /scripts/index.sh
	pr_info "\nNot work now, use run instead!"
}

function stop()
{
	docker stop $CONTAINER_NAME
	docker rm $CONTAINER_NAME
}

function clean()
{
	echo "delete existing data and etc..."
	sudo rm -rf $GROKPATH/etc/*
	sudo rm -rf $GROKPATH/data/*
}

function usage()
{
	echo -e "\033[31m" "\nusage:" "\t./opengropk.sh [install|run|reindex|usage]"
	echo -e "\tinstall\t install docker community edition and opengrok official image"
	echo -e "\trun\trun opengrok at specific port"
	echo -e "\treindex\treindex when you add some new project in \${GROKPATH}/src directory"
	echo -e "\033[0m"
}

if [ $# -eq 0 ]; then 
	usage
fi

case $1 in
	"install")
		install	
		;;
	"run")
		run
		;;
	"stop")
		stop
		;;
	"clean")
		clean
		;;
	"reindex")
		reindex
		;;
	*)
		usage
		;;
esac
