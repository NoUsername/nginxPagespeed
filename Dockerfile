FROM        debian:wheezy

# basic build image
ADD			installDeps.sh /opt/installDeps.sh
RUN         apt-get update && bash /opt/installDeps.sh

# build and install
ADD			install.sh /opt/install.sh
ADD			cleanup.sh /opt/cleanup.sh
RUN			bash /opt/install.sh
RUN			printf "\n\ndaemon off;\n" >> /etc/nginx/nginx.conf
ADD			pagespeedBaseConf.conf /etc/nginx/pageSpeed
ADD			pagespeedBaseConf.conf /opt/

ENTRYPOINT	/usr/sbin/nginx
EXPOSE      80
