# kodeline-docker-cms

Docker compose to use my own stack for Prestashop and Wordpress development.  
It is based on the images:
- [bitnami-docker-apache](https://github.com/bitnami/bitnami-docker-apache)
- [dockergento-php-fpm](https://github.com/ModestCoders/dockerfiles/tree/master/php/7.1-fpm)
 
 
Also, is added a node container to allow using Gulp + BrowserSync with my own image of [front-tools](https://github.com/jdominguez198/kodeline-toolset)

## How to use

There is two configuration files:
- configs/gulp/tools-config.json: Paths and ports for gulp + browsersync
- .env: Paths and ports for website

You have an example file for both configuration files under its folders.

## Changelog

### v1.2.0

> Add enable/disable xdebug for local development (disabled by default)

### v1.1.0

> Add CLI to setup config & start/stop stack

### v1.0.0

> First working version.

## TODO

> Try to use nginx instead of apache