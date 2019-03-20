#!/bin/bash

BIN_DIR="$( cd "$( dirname $(dirname "${BASH_SOURCE[0]}" ))" >/dev/null && pwd )"/
BASE_DIR="$(dirname "${BIN_DIR}" )"/
CNF_DIR=${BIN_DIR}cnf/

source ${CNF_DIR}config.sh

RANDOM_PORT=$(awk 'BEGIN{srand();print int(rand()*(9990-9000))+9000 }')

APP_NAME=""
WEB_PATH=""
WEB_PORT=""
WEB_ASSETS_PATH=""
GULP_PORT=""
GULP_ADMIN_PORT=""
PHP_VERSION=""
APACHE_VERSION=""

DEFAULT_APP_NAME=default
DEFAULT_WEB_PATH=/var/www/html
DEFAULT_WEB_ASSETS_PATH=wp-content/themes/kodeline/
DEFAULT_PHP_VERSION=7.1
DEFAULT_APACHE_VERSION=2.4.38

ARGS_NOT_USED=6

for i in "$@" ; do
    if [[ "$i" =~ "--site-name" ]]; then
        APP_NAME=$(echo $i | awk -F '--site-name=' '{print $2}')
        ARGS_NOT_USED=$((${ARGS_NOT_USED}-1))
    fi
    if [[ "$i" =~ "--site-dir" ]]; then
        WEB_PATH=$(echo $i | awk -F '--site-dir=' '{print $2}')
        ARGS_NOT_USED=$((${ARGS_NOT_USED}-1))
    fi
    if [[ "$i" =~ "--site-assets-dir" ]]; then
        WEB_ASSETS_PATH=$(echo $i | awk -F '--site-assets-dir=' '{print $2}')
        ARGS_NOT_USED=$((${ARGS_NOT_USED}-1))
    fi
    if [[ "$i" =~ "--httpd-port" ]]; then
        WEB_PORT=$(echo $i | awk -F '--httpd-port=' '{print $2}')
        ARGS_NOT_USED=$((${ARGS_NOT_USED}-1))
    fi
    if [[ "$i" =~ "--browsersync-port" ]]; then
        GULP_PORT=$(echo $i | awk -F '--browsersync-port=' '{print $2}')
        ARGS_NOT_USED=$((${ARGS_NOT_USED}-1))
    fi
    if [[ "$i" =~ "--browsersync-admin-port" ]]; then
        GULP_ADMIN_PORT=$(echo $i | awk -F '--browsersync-admin-port=' '{print $2}')
        ARGS_NOT_USED=$((${ARGS_NOT_USED}-1))
    fi
    if [[ "$i" =~ "--php-fpm" ]]; then
        PHP_VERSION=$(echo $i | awk -F '--php-fpm=' '{print $2}')
    fi
    if [[ "$i" =~ "--apache" ]]; then
        APACHE_VERSION=$(echo $i | awk -F '--apache=' '{print $2}')
    fi
done

if [[ "$APP_NAME" == "" ]]; then
    while [[ ! "$APP_NAME" =~ ^[0-9a-zA-Z\_\-] ]]; do
        echo "Type the name of your site (Pattern allowed: [0-9a-z\_\-]):"
        read -p "Site name: " APP_NAME
    done
fi

if [[ "$WEB_PATH" == "" ]]; then
    echo "Type the absolute path of your current web site files:"
    read -p "Current site absolute path [${DEFAULT_WEB_PATH}]: " WEB_PATH
    WEB_PATH=${WEB_PATH:-$DEFAULT_WEB_PATH}
fi

if [[ "$WEB_ASSETS_PATH" == "" ]]; then
    echo "Type the relative path to the assets folder:"
    read -p "Assets relative path [${DEFAULT_WEB_ASSETS_PATH}]: " WEB_ASSETS_PATH
    WEB_ASSETS_PATH=${WEB_ASSETS_PATH:-$DEFAULT_WEB_ASSETS_PATH}
fi

if [[ "$WEB_PORT" == "" ]]; then
    echo "Type the port where you want to bind the httpd service:"
    read -p "httpd port [${RANDOM_PORT}]: " WEB_PORT
    WEB_PORT=${WEB_PORT:-$RANDOM_PORT}
fi

if [[ "$GULP_PORT" == "" ]]; then
    echo "Type the port where you want to bind the browserSync service:"
    read -p "browserSync port [$(($WEB_PORT+1))]: " GULP_PORT
    GULP_PORT=${GULP_PORT:-$(($WEB_PORT+1))}
fi

if [[ "$GULP_ADMIN_PORT" == "" ]]; then
    echo "Type the port where you want to bind the browserSync Admin service:"
    read -p "browserSync Admin port [$(($GULP_PORT+1))]: " GULP_ADMIN_PORT
    GULP_ADMIN_PORT=${GULP_ADMIN_PORT:-$(($GULP_PORT+1))}
fi

if [[ "$PHP_VERSION" == "" ]]; then
    echo "Type the php-fpm version to use:"
    read -p "php-fpm version: [${DEFAULT_PHP_VERSION}]: " PHP_VERSION
    PHP_VERSION=${PHP_VERSION:-$DEFAULT_PHP_VERSION}
fi

if [[ "$APACHE_VERSION" == "" ]]; then
    echo "Type the apache version to use:"
    read -p "apache version: [${DEFAULT_APACHE_VERSION}]: " APACHE_VERSION
    APACHE_VERSION=${APACHE_VERSION:-$DEFAULT_APACHE_VERSION}
fi


if [[ "$ARGS_NOT_USED" -gt 0 ]]; then
    echo ""
    echo ""
    echo "Please confirm the typed values are correct:"
    echo "Site name: ${APP_NAME}"
    echo "Current site absolute path: ${WEB_PATH}"
    echo "Assets relative path: ${WEB_ASSETS_PATH}"
    echo "httpd port: ${WEB_PORT}"
    echo "browserSync port: ${GULP_PORT}"
    echo "browserSync Admin port: ${GULP_ADMIN_PORT}"
    echo "php-fpm version: ${PHP_VERSION}"
    echo "apache version: ${APACHE_VERSION}"
    echo ""
    echo ""

    PROCESS_CONFIRM="N"
    while [[ "$PROCESS_CONFIRM" != "Y" ]]; do
        read -r -p "Are they correct? [Y/N]: " PROCESS_CONFIRM

        case "$PROCESS_CONFIRM" in
            [yY][eE][sS]|[yY])
                PROCESS_CONFIRM="Y"
                ;;
            [nN][oO]|[nN])
                break
                ;;
            *)
            echo "Please use Y to confirm or N to exit"
            ;;
        esac
    done

    if [[ "$PROCESS_CONFIRM" != "Y" ]]; then
        echo "Process canceled!"
        exit 1
    fi
fi

cat ${BASE_DIR}.env-example > ${BASE_DIR}.env

PARSED_WEB_PATH=${WEB_PATH////\\/}
sed -i '' "s/WEB_PATH.*/WEB_PATH=${PARSED_WEB_PATH}/g" ${BASE_DIR}.env
sed -i '' "s/APP_NAME.*/APP_NAME=${APP_NAME}/g" ${BASE_DIR}.env
sed -i '' "s/WEB_PORT.*/WEB_PORT=${WEB_PORT}/g" ${BASE_DIR}.env
sed -i '' "s/GULP_PORT.*/GULP_PORT=${GULP_PORT}/g" ${BASE_DIR}.env
sed -i '' "s/GULP_ADMIN_PORT.*/GULP_ADMIN_PORT=${GULP_ADMIN_PORT}/g" ${BASE_DIR}.env
sed -i '' "s/PHP_VERSION.*/PHP_VERSION=${PHP_VERSION}/g" ${BASE_DIR}.env
sed -i '' "s/APACHE_VERSION.*/APACHE_VERSION=${APACHE_VERSION}/g" ${BASE_DIR}.env
echo "File ${BASE_DIR}.env generated successfully!"

cat ${BASE_DIR}configs/gulp/tools-config.json.example > ${BASE_DIR}configs/gulp/tools-config.json

WEB_SITE_URL=http://${APP_NAME}.kodeline/
PARSED_WEB_SITE_URL="\"public_url\": \"${WEB_SITE_URL////\\/}\","
sed -i '' "s/\"public_url\".*/${PARSED_WEB_SITE_URL}/g" ${BASE_DIR}configs/gulp/tools-config.json
PARSED_GULP_PORT="\"browsersync_port\": ${GULP_PORT},"
sed -i '' "s/\"browsersync_port\".*/${PARSED_GULP_PORT}/g" ${BASE_DIR}configs/gulp/tools-config.json
PARSED_GULP_ADMIN_PORT="\"browsersync_admin_port\": ${GULP_ADMIN_PORT},"
sed -i '' "s/\"browsersync_admin_port\".*/${PARSED_GULP_ADMIN_PORT}/g" ${BASE_DIR}configs/gulp/tools-config.json
PARSED_WEB_ASSETS_PATH="\"site_assets_relative_path\": \"${WEB_ASSETS_PATH////\\/}\","
sed -i '' "s/\"site_assets_relative_path\".*/${PARSED_WEB_ASSETS_PATH}/g" ${BASE_DIR}configs/gulp/tools-config.json


echo "File ${BASE_DIR}configs/gulp/tools-config.json generated successfully!"
