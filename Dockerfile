FROM php:5.6-apache
MAINTAINER Nir Galon <nir.galon@gizra.com>

# Setup environment.
ENV DEBIAN_FRONTEND noninteractive

RUN a2enmod rewrite

# Install the PHP extensions we need
RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev libpq-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd mbstring pdo pdo_mysql pdo_pgsql zip

# Installtion.
RUN apt-get update -y && apt-get install -y \
    software-properties-common \
    git \
    wget \
    zip \
		vim \
		ruby-dev \
		rubygems \
    php5-curl \
    php5-cli \
		default-jdk \
    php5-mysql

RUN apt-get install -y mysql-server \
    mysql-client

# Install Composer.
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# Install Node.js for npm modules.
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs

# Install Drush
RUN export PATH="$HOME/.composer/vendor/bin:$PATH" \
    && composer global require drush/drush:7.*

## Frontend tools

# Bower
RUN npm install -g bower

# Gulp
RUN npm install -g gulp

# Elm-Test
RUN npm install -g elm-test@0.18.2

# sysconfcpus
RUN git clone https://github.com/obmarg/libsysconfcpus.git &&
  cd libsysconfcpus &&
  ./configure --prefix=/usr &&
  make -j8 && make install

# WDIO
RUN npm install -g webdriverio@4.6.2 wdio-mocha-framework@0.5.8 wdio-selenium-standalone-service@0.0.7  wdio-spec-reporter@0.0.5

# Install solar
RUN cd /var/www \
  && git clone https://github.com/RoySegall/solr-script.git \
  && cd solr-script \
  && bash solr.sh -b -s https://www.dropbox.com/s/75kcni45bsenzzs/solr-4.7.2.zip
