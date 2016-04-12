FROM php:5.6-apache
MAINTAINER Nir Galon <nir.galon@gizra.com>

# Setup environment.
ENV DEBIAN_FRONTEND noninteractive

RUN a2enmod rewrite

# Drupal stuff.
RUN apt-get update -y && apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring zip pdo pdo_mysql pdo_pgsql zip

# Installtion.
RUN apt-get update -y && apt-get install -y \
    software-properties-common \
    git \
    wget \
    curl \
    zip \
		openjdk-7-jdk \
		ruby-dev \
		rubygems \
    php5-curl \
    php5-cli \
    php5-mysql

RUN apt-get install -y mysql-server \
    mysql-client

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Setup Apache2.
# listen on the same port as the one we forwarded.
RUN sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
RUN sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www/' /etc/apache2/sites-available/000-default.conf
RUN echo "Listen 8080" >> /etc/apache2/ports.conf
RUN sed -i 's/VirtualHost \*:80/VirtualHost \*:\*/' /etc/apache2/sites-available/000-default.conf

# Setup MySQL, bind on all addresses.
RUN sed -i -e 's/^#bind-address\s*=\s*127.0.0.1/bind-address = 127.0.0.1/' /etc/mysql/my.cnf

# Install Drush
RUN wget http://files.drush.org/drush.phar
RUN mv drush.phar /usr/local/bin/drush && chmod +x /usr/local/bin/drush

# Install solar
RUN cd /var/www/html \
  && git clone https://github.com/RoySegall/solr-script.git \
  && cd /var/www/html/solr-script \
  && bash solr.sh -b
