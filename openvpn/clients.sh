#!/bin/bash
if [[ "$#" -lt 2 ]]; then
	echo -e "Usage:\n $0 gen [clientname]\n $0 revoke [clientname]"
	exit 1
fi
if [[ "$1" -eq "gen" ]]; then
	sudo docker-compose run --rm openvpn easyrsa build-client-full $2 nopass
	sudo docker-compose run --rm openvpn ovpn_getclient $2 > ovpn-profiles/$2.ovpn
    chmod 600 ovpn-profiles/$2.ovpn
elif [[ "$1" -eq "revoke" ]]; then
	sudo docker-compose run --rm openvpn opvn_revokeclient $2 remove
else
	echo -e "Usage:\n $0 gen [clientname]\n $0 revoke [clientname]"
        exit 1
fi
