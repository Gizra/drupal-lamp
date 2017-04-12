# Gizra LAMP Docker

[![](https://images.microbadger.com/badges/image/gizra/drupal-lamp.svg)](https://hub.docker.com/r/gizra/drupal-lamp/)

This is a base LAMP docker file.
The docker container is based on PHP 7.1-apache, and have:
* Drupal
* Apache2
* MySQL
* git
* Composer
* NodeJS
* zip
* vim
* Java jdk
* ruby and rubygems
* wget
* Solr

The container is configured all those stuff together.

Files:

* `your-Dockerfile` - An example file for you `Dockerfile` file.
* `run.sh` - An example for your `run.sh` file, that your `Dockerfile` will execute.
* `000-default.conf` - A must have file in your root project, for apache configuration.
