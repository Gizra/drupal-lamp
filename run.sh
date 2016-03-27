#!/usr/bin/env bash

# Start mysql, Create esaro db and grunt permissions.
service mysql start
mysql -u root -e "create database esaro";
mysql -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON esaro.* TO 'root'@'localhost' IDENTIFIED BY 'root';";
mysqladmin -u root -proot password ''
/etc/init.d/mysql restart

# Install drush.
curl http://drupalconsole.com/installer -L -o drupal.phar
mv drupal.phar /usr/local/bin/drupal && chmod +x /usr/local/bin/drupal
export PATH="$HOME/.composer/vendor/bin:$PATH"
composer global require drush/drush:7.*

# before_install
cd sites/default
cp default.settings.php settings.php

# Download and install the db
cd /var/www/html/esaro
sites/default/./gdown.pl esaro-11-02-2016-travis.sql.gz 0B9GvPcG7Y-T2MTBPRnFHekNnbWs
drush sql-create --db-url="mysql://root:@127.0.0.1/esaro" -y
gzip -d esaro-11-02-2016-travis.sql.gz
drush sql-cli < esaro-11-02-2016-travis.sql

# Configure apache2
a2enmod actions
a2enmod rewrite
echo "export PATH=/home/vagrant/.phpenv/bin:$PATH" | tee -a /etc/apache2/envvars > /dev/null
echo "$(curl -fsSL https://gist.github.com/roderik/16d751c979fdeb5a14e3/raw/74f4fec92c064c4f683fef28a6098caf0f038de7/gistfile1.txt)" | tee /etc/apache2/conf.d/phpconfig > /dev/null
echo "$(curl -fsSL https://gist.giRrunthub.com/roderik/2eb301570ed4a1f4c33d/raw/8066fda124b6c86f69ad32a010b8c22bbaf868e8/gistfile1.txt)" | sed -e "s,PATH,`pwd`/www,g" | tee /etc/apache2/sites-available/default > /dev/null
service apache2 restart

# Add apache subdomain conf
sh -c "cat 000-default.conf > /etc/apache2/sites-available/000-default.conf"
service apache2 reload

# Install behat
cd behat
curl -sS https://getcomposer.org/installer | php
php composer.phar install
cp behat.local.yml.example behat.local.yml
./bin/behat --tags=~@wip
