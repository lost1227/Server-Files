docker-compose run --rm openvpn ovpn_genconfig \
    -u tcp://powers.myq-see.com:8443 \
    -n 192.168.1.242 \
    -p 'redirect-gateway def1' \
    -s 192.168.254.0/24 \
    
