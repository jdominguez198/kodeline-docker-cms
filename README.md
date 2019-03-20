# kodeline-docker-cms

Docker compose based in [Bitnami](https://github.com/bitnami/)'s images to use my own stack for Prestashop and Wordpress development.  
It is based on the images:
- [bitnami-docker-apache](https://github.com/bitnami/bitnami-docker-apache)
- [bitnami-docker-php-fpm](https://github.com/bitnami/bitnami-docker-php-fpm)
 
 
Also, is added a node container to allow using Gulp + BrowserSync with my own image of [front-tools](https://github.com/jdominguez198/kodeline-toolset)

## How to use

There is two configuration files:
- configs/gulp/tools-config.json: Paths and ports for gulp + browsersync
- .env: Paths and ports for website

You have an example file for both configuration files under its folders.

## Changelog

### v1.1.0

> Add CLI to setup config & start/stop stack

### v1.0.0

> First working version.

## TODO

> Try to use nginx instead of apache