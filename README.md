# Gizra LAMP Docker
This is a base LAMP docker file.
The docker container is based on PHP 5.6-apache, and have:
* Drupal
* Apache2
* MySQL
* git
* Composer
* etc

The container is configured all those stuff together.

Files:

* `your-Dockerfile` - An example file for you `Dockerfile` file.
* `run.sh` - An example for your `run.sh` file, that your `Dockerfile` will execute.
* `000-default.conf` - A must have file in your root project, for apache configuration.
