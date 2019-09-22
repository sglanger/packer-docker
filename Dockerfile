FROM centos:centos7

MAINTAINER Steve Langer <sglanger@fastmail.COM>
###############################################################
# ansible-docker
# this is a conversion of DB's Vagrant for EWOCS to a Docker
#
# External files: "ADD" lines below and
#		run_ddw_db.sh
########################################################


# setup paths 
ADD service-start.sh /docker-entrypoint/service-start.sh
RUN chmod -R 777 /docker-entrypoint

# install standard tools
RUN yum  install -y  nano
ENV TERM xterm
RUN yum install -y bash
RUN yum install -y net-tools
RUN yum install -y install nmap
#RUN yum install -y install openssh
RUN yum install -y epel-release
RUN yum install -y ansible

#####  setup the ansible stuff
ADD dewey_demo/playbook /root/playbook
ADD dewey_demo/scripts /root/scripts
ADD dewey_demo/*json /root/
ADD dewey_demo/kick* /root/


########### expose ports used by this docker
# DICOM rcvr
#EXPOSE 11113

# vaadin port
#EXPOSE 9000

# ssh
#EXPOSE 22

# STEP 22: Add VOLUMEs to allow commnunication between this and base_plugin
#VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]


# STEP 23: Set the default command to run when workflow engine
CMD [ " /docker-entrypoint/service-start.sh "]
#cmd [ "/bin/bash "] 



