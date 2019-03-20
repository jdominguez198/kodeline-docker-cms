#!/bin/bash

BIN_DIR="$( cd "$( dirname $(dirname "${BASH_SOURCE[0]}" ))" >/dev/null && pwd )"/
BASE_DIR="$(dirname "${BIN_DIR}" )"/
CNF_DIR=${BIN_DIR}cnf/

source ${CNF_DIR}config.sh

if [[ ! -f "${BASE_DIR}.env" ]]; then
    echo "Execute setup first!"
    exit 0
else
    sed 's/\(=[[:blank:]]*\)\(.*\)/\1"\2"/' ${BASE_DIR}.env > ${BASE_DIR}.env.vars
    source ${BASE_DIR}.env.vars
    rm -f ${BASE_DIR}.env.vars
fi

echo "Starting containers..."

cd ${BASE_DIR}
docker-compose -p ${APP_NAME} up -d