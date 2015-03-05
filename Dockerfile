FROM        debian:wheezy
ADD			install.sh /opt/install.sh
ADD			cleanup.sh /opt/cleanup.sh
RUN         apt-get update && bash /opt/install.sh
RUN			printf "\n\ndaemon off;\n" >> /etc/nginx/nginx.conf
ADD			pagespeedBaseConf.conf /etc/nginx/pageSpeed
CMD			nginx
EXPOSE      80
