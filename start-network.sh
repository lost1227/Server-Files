# creates the external ipvlan network used by many docker container
# this ipvlan network is used to assign containers ip addresses
# as if those containers were on the physical network
docker network create -d ipvlan \
    --subnet 192.168.1.0/24 \
    --gateway 192.168.1.1 \
    --ip-range 192.168.1.240/28 \
    --aux-address 'host=192.168.1.241' \
    -o ipvlan_mode=l2 \
    -o parent=enp2s0f0 \
    external_net
