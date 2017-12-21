FROM php:7.2-apache

# System Dependencies.
RUN apt update && \
    apt upgrade -y && \
	apt install -y unzip

# Copy grav to docker
COPY grav-v1.3.8.zip /tmp/
RUN cd /tmp && \
    unzip /tmp/grav-v1.3.8.zip -d /var/www/ && \
    rm -R /var/www/html && \
    mv /var/www/grav /var/www/html

# Install the PHP extensions we need
RUN apt install -y libpng-dev libicu-dev
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install gd
RUN docker-php-ext-install intl
RUN docker-php-ext-install zip

# Activate mod_rewrite
RUN a2enmod rewrite
RUN service apache2 restart

# Install admin plugin
WORKDIR /var/www/html
RUN bin/gpm selfupgrade
RUN bin/gpm install admin

# Correct permissions
RUN chown -R www-data /var/www/html