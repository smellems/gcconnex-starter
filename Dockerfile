FROM ubuntu:16.04

# Install dependencies
RUN apt-get update
RUN apt-get install -y git apache2 php7.0 libapache2-mod-php7.0 php7.0-mysql php7.0-gd php7.0-curl php7.0-xml php7.0-mbstring

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Modify Apache config for Elgg
RUN echo '<Directory /var/www/html>\nOptions Indexes FollowSymLinks MultiViews\nAllowOverride All\nOrder allow,deny\nallow from all\n</Directory>\n' | sed '/^<VirtualHost \*:80>/r /dev/stdin' /etc/apache2/sites-available/000-default.conf > /etc/apache2/sites-available/tmp
RUN mv /etc/apache2/sites-available/tmp /etc/apache2/sites-available/000-default.conf

# Modify Apache config to output access and error log to stdio
# So we can see the output using `docker-compose logs` or directly with `docker-compose up`)
RUN sed -i '/ErrorLog ${APACHE_LOG_DIR}\/error.log/c\ErrorLog \/dev\/stderr' /etc/apache2/apache2.conf
RUN sed -i '/ErrorLog ${APACHE_LOG_DIR}\/error.log/c\ErrorLog \/dev\/stderr' /etc/apache2/sites-available/000-default.conf

# Uncomment to also see access log (rebuild with docker-compose up --build)
# RUN sed -i '/CustomLog ${APACHE_LOG_DIR}\/access.log combined/c\CustomLog \/dev\/stdout combined' /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

# Start Apache in foreground mode
CMD chown www-data /data && /usr/sbin/apache2ctl -D FOREGROUND
