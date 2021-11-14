#!/bin/bash
set -e 

SCRIPT_DIR=$(dirname $(realpath $0))
cd ${SCRIPT_DIR}

docker-compose down &> /dev/null

echo "# $(date)"

docker run --rm \
    --mount type=bind,src=${SCRIPT_DIR}/data/certbot/conf,dst=/etc/letsencrypt \
    --mount type=bind,src=${SCRIPT_DIR}/data/certbot/aws,dst=/root/.aws \
    -p 80:80 \
    certbot/dns-route53 \
    renew

docker-compose up -d &> /dev/null

echo
