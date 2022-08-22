# packer_docker

a template docker that runs a ftp server  to demo port and volumes

* SG Langer, August 2022

## Background
* this is just a toy demo to show basic use of Docker with SGL run_docker scripts

## How to use
* git clone in the usual way
* get into repo and do "./run_docker.sh build"
* the above will autostart the built docker
* connect to it with "./run_docker conn"
* see host files in /app and /mnt
* start ftp server with "/usr/sbin/vsftpd "
* show its running with "nmap localhost"
* from another term ftp to ith at port 2221 (on host)


