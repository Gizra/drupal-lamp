#!/usr/bin/env bash

# Start mysql, Create esaro db and grunt permissions.
service mysql start
mysql -u root -e "create database <database_name>";
mysql -u root -e "GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON <database_name>.* TO '<your_username>'@'localhost' IDENTIFIED BY '<your_password>';";
mysqladmin -u <your_username> -proot password '<your_password>'
/etc/init.d/mysql restart

# Install NodeJS for npm packages
cd client
cp client/config.example.json client/config.json
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get install -y nodejs
chown -R root /usr/local/
npm install
npm install -g grunt-cli bower
cd ..

# Configure apache2
a2enmod actions
a2enmod rewrite
echo "export PATH=/home/vagrant/.phpenv/bin:$PATH" | tee -a /etc/apache2/envvars > /dev/null
echo "$(curl -fsSL https://gist.giRrunthub.com/roderik/2eb301570ed4a1f4c33d/raw/8066fda124b6c86f69ad32a010b8c22bbaf868e8/gistfile1.txt)" | sed -e "s,PATH,`pwd`/www,g" | tee /etc/apache2/sites-available/default > /dev/null
service apache2 restart

# Add apache conf
cp docker_files/default.apache2.conf /etc/apache2/apache2.conf
sh -c "cat 000-default.conf > /etc/apache2/sites-available/000-default.conf"
service apache2 reload

# Drupal installation.
cd /var/www/html/skeleton/
cp default.config.sh config.sh
./install -y

# Install behat
cd behat
curl -sS https://getcomposer.org/installer | php
php composer.phar install
cp behat.local.yml.example behat.local.yml
./bin/behat --tags=~@wip
