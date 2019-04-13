#!/bin/bash
set -e

sudo chown -R app:app /var/www

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

if [[ ! -z "$APP_DEBUG_MODE" ]] && [[ "$APP_DEBUG_MODE" == 1 ]]; then
    echo "Running PHP-FPM in debug mode"
    sed -i -e 's/^;zend_extension/\zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
    sudo /usr/sbin/sshd -e
fi

exec "$@"
