#!/bin/bash
set -e

if [[ "$1" == "bitcore-cli" || "$1" == "bitcore-tx" || "$1" == "bitcored" || "$1" == "test_bitcore" ]]; then
	mkdir -p "$BITCORE_DATA"

	cat <<-EOF > "$BITCORE_DATA/bitcore.conf"
	printtoconsole=1
	rpcallowip=::/0
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcore:bitcore "$BITCORE_DATA/bitcore.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcore "$BITCORE_DATA"
	ln -sfn "$BITCORE_DATA" /home/bitcore/.bitcore
	chown -h bitcore:bitcore /home/bitcore/.bitcore
	
	# Downloading bootstrap file
	WEB="bitcore.cc" # without "https://" and without the last "/" (only HTTPS accepted)
	BOOTSTRAP="bootstrap.tar.gz"
	cd $BITCORE_DATA
	if [ "$(curl -Is https://${WEB}/${BOOTSTRAP} | head -n 1 | tr -d '\r\n')" = "HTTP/1.1 200 OK" ] ; then \
        	sudo -u bitcore wget https://${WEB}/${BOOTSTRAP}; \
        	sudo -u bitcore tar -xvzf ${BOOTSTRAP}; \
        	sudo -u bitcore rm ${BOOTSTRAP}; \
	fi

	exec gosu bitcore "$@"
else
	exec "$@"
fi
