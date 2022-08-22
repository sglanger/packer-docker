#!/bin/bash

###############################################
# Author: SG Langer Jan 2016
# Purpose: put all the Docker commands to build/run 
#	ddw-dbase in one easy place
#
##########################################


############## main ###############
# Purpose: Based on command line arg either
#		a) build all Docker from scratch or
#		b) kill running docker or
#		c) start Docker or
#		d) restart
# Caller: user
###############################
clear
host="127.0.0.1"
image="ansible-docker"
instance="ansi"
cwd=$(pwd)
echo $cwd

case "$1" in
	build)
		# first clean up if any running instance
		# Comment out the rmi line if you really don't want to rebuild the docker
		sudo docker stop $instance
		sudo docker rmi -f $image
		sudo docker rm $instance
		sudo docker system prune

		# now build from clean. 
		sudo docker build --rm=true -t $image .
		$0 start
	;;


	conn)
		sudo docker exec -u root -it $instance /bin/bash
	;;

	restart)
		$0 stop
		$0 start
	;;

	status)
		sudo docker ps; echo
		sudo docker images 
	;;

	stop)
		# stops Instance but does not remove Image from DOcker engine 
		sudo docker stop $instance
		sudo docker rm -f $instance
		$0 status
	;;

	start)
		sudo docker rm -f $instance
		# here we launch DOcker w/out the --net="host" tag , but then no ports are exposed including 104
		# so we expose them one at a time with -p switches on the container address
		# host=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $instance)
		# the trick is to know the IP before the docker is created, and yes it is a trick
		#sudo docker run -p 172.17.0.2:22:2022  --name $instance  -d $image
		#sudo docker run --net="host" --name $instance  -d $image   -v /home/dewey:/mnt/dewey
		sudo docker run --rm --name $instance \
			-v $cwd:/mnt \
			-v $cwd/app:/app \
			-p 2221:21 \
			-id   --entrypoint  /docker-entrypoint/service-start.sh $image 
		sleep 3
		$0 status
	;;

	*)
		echo "invalid option"
		echo "valid options: build/start/stop/restart/status/conn"
		exit
	;;
esac
