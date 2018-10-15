FROM ubuntu:18.04

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    apache2 \
    libapache2-mod-php7.2 \
    php7.2 \
    php7.2-json \
    php7.2-gd \
    php7.2-mbstring \
    php7.2-mysql \    
    php7.2-xml \  
&& a2enmod rewrite \
&& mkdir /data \
&& chown www-data:www-data /data \
&& echo '<Directory /var/www/html>\nOptions Indexes FollowSymLinks MultiViews\nAllowOverride All\nOrder allow,deny\nallow from all\n</Directory>\n' | sed -i '/^<VirtualHost \*:80>/r /dev/stdin' /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

CMD apache2ctl -D FOREGROUND

# docker build -t gcconnex-apache-php .
# docker run --name gcconnex-mysql -e MYSQL_ROOT_PASSWORD=my-secret-pw -e MYSQL_DATABASE=gcconnex-db -e MYSQL_USER=gcconnex-user -e MYSQL_PASSWORD=password -d mysql
# docker run --name gcconnex -p 8080:80 -v `pwd`:/var/www/html --link gcconnex-mysql:mysql -d gcconnex-apache-php
