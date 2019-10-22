#!/bin/bash
set -e

if [[ "$#" -lt 2 ]]; then
	echo -e "Usage:\n $0 gen [clientname]\n $0 revoke [clientname]"
	exit 1
fi
mkdir -p ovpn-profiles
profile=ovpn-profiles/$2.ovpn
profile_obfsproxy=ovpn-profiles/$2-obfsproxy.ovpn
if [[ "$1" -eq "gen" ]]; then
	docker-compose run --rm openvpn easyrsa build-client-full $2 nopass
	docker-compose run --rm openvpn ovpn_getclient $2 > $profile

    sed -E "s/remote (\S*) [0-9]{1,5} tcp/remote \1 8080 tcp/" < $profile > $profile_obfsproxy
    echo "socks-proxy-retry" >> $profile_obfsproxy
    echo "socks-proxy 127.0.0.1 10194" >> $profile_obfsproxy

    chmod 600 $profile
    chmod 600 $profile_obfsproxy

elif [[ "$1" -eq "revoke" ]]; then
	docker-compose run --rm openvpn opvn_revokeclient $2 remove
else
	echo -e "Usage:\n $0 gen [clientname]\n $0 revoke [clientname]"
        exit 1
fi
