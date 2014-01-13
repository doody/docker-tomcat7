FROM ubuntu:12.04

MAINTAINER Wei-Ming Wu <wnameless@gmail.com>

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update

# Install sshd
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# Set password to 'admin'
RUN printf admin\\nadmin\\n | passwd

# Install libfuse2
RUN apt-get install -y libfuse2
RUN cd /tmp; apt-get download fuse
RUN cd /tmp; dpkg-deb -x fuse_* .
RUN cd /tmp; dpkg-deb -e fuse_*
RUN cd /tmp; rm fuse_*.deb
RUN cd /tmp; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp; dpkg-deb -b . /fuse.deb
RUN cd /tmp; dpkg -i /fuse.deb

# Install Java 7
RUN apt-get install -y openjdk-7-jdk

# Install Tomcat 7
RUN apt-get install -y tomcat7 tomcat7-admin
RUN sed -i "s#</tomcat-users>##g" /etc/tomcat7/tomcat-users.xml; \
	echo '  <role rolename="manager-gui"/>' >>  /etc/tomcat7/tomcat-users.xml; \
	echo '  <role rolename="manager-script"/>' >>  /etc/tomcat7/tomcat-users.xml; \
	echo '  <role rolename="manager-jmx"/>' >>  /etc/tomcat7/tomcat-users.xml; \
	echo '  <role rolename="manager-status"/>' >>  /etc/tomcat7/tomcat-users.xml; \
	echo '  <role rolename="admin-gui"/>' >>  /etc/tomcat7/tomcat-users.xml; \
	echo '  <role rolename="admin-script"/>' >>  /etc/tomcat7/tomcat-users.xml; \
	echo '  <user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status, admin-gui, admin-script"/>' >>  /etc/tomcat7/tomcat-users.xml; \
	echo '</tomcat-users>' >> /etc/tomcat7/tomcat-users.xml

EXPOSE 22
EXPOSE 8080

CMD service tomcat7 start; \
	/usr/sbin/sshd -D
