FROM ubuntu:16.04
MAINTAINER Nguyen Canh Linh "canhlinh.lienson@gmail.com"
RUN mkdir /docker/build -p
WORKDIR /docker/build

# Keep upstart from complaining
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl

# Update
RUN apt-get update
RUN apt-get -y upgrade

# Basic Requirements
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y install supervisor wget nginx mysql-server mysql-client php-fpm php-mysql php-mbstring

# logging
RUN apt-get -y install python-pip
RUN pip install supervisor-stdout

# Mysql config
RUN rm -rf /var/lib/mysql/*
RUN chown -R mysql:mysql /var/lib/mysql/

# Nginx config
RUN mkdir -p /etc/nginx/sites-available
RUN mkdir -p /etc/nginx/sites-enabled
RUN mkdir -p /etc/nginx/ssl
RUN rm -Rf /var/www/*
RUN mkdir /var/www/html/ -p
RUN rm -rf /etc/nginx/sites-enabled/*
ADD conf/nginx-site.conf /etc/nginx/sites-enabled/nginx-site.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf

# Install phpMyAdmin
RUN mkdir /run/php
RUN chown www-data:www-data /run/php
RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz -O phpmyadmin.tar.gz
RUN tar -xzf phpmyadmin.tar.gz -C /var/www/html/ --strip-components=1
RUN rm -rf /var/www/html/js/jquery/src/ /var/www/html/examples /var/www/html/po/
RUN chown www-data:www-data /var/www/html/ -R

# Supervisor Config
RUN mkdir -p /var/log/supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Initialization Startup Script
ADD ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

EXPOSE 3306
EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
