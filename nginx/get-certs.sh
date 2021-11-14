#!/bin/bash
set -e -x

SCRIPT_DIR=$(dirname $(realpath $0))
cd ${SCRIPT_DIR}

runas='sudo -u #296608 -g #296608'

if [ ! -d "${SCRIPT_DIR}/data/certbot/conf" ]; then
    ${runas} mkdir -p ${SCRIPT_DIR}/data/certbot/conf
fi

if [ ! -e "${SCRIPT_DIR}/data/certbot/conf/options-ssl-nginx-conf" ] || [ ! -e "${SCRIPT_DIR}/data/certbot/conf/ssl-dhparams.pem" ]; then
    ${runas} curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf -o "${SCRIPT_DIR}/data/certbot/conf/options-ssl-nginx.conf"
    ${runas} curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem -o "${SCRIPT_DIR}/data/certbot/conf/ssl-dhparams.pem"
fi

docker run -it --rm \
    --mount type=bind,src=${SCRIPT_DIR}/data/certbot/conf,dst=/etc/letsencrypt \
    --mount type=bind,src=${SCRIPT_DIR}/data/certbot/aws,dst=/root/.aws \
    certbot/dns-route53 \
    --dry-run \
    certonly --dns-route53 \
    -d powers.jordanpowers.link \
    -d \*.powers.jordanpowers.link 

docker-compose down

docker run -it --rm \
    --mount type=bind,src=${SCRIPT_DIR}/data/certbot/conf,dst=/etc/letsencrypt \
    -p 80:80 \
    certbot/dns-route53 \
    --dry-run \
    certonly --standalone \
    -d powers.jordanpowers.net \
    -d unifi.powers.jordanpowers.net
