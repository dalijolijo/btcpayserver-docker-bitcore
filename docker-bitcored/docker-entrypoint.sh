#!/bin/bash
set -e

if [[ "$1" == "bitcore-cli" || "$1" == "bitcore-tx" || "$1" == "bitcored" || "$1" == "test_bitcore" ]]; then
	mkdir -p "$BITCORE_DATA"

	CONFIG_PREFIX=""
	if [[ "${BITCOIN_NETWORK}" == "regtest" ]]; then
		CONFIG_PREFIX=$'regtest=1\n[regtest]'
	fi
	if [[ "${BITCOIN_NETWORK}" == "testnet" ]]; then
		CONFIG_PREFIX=$'testnet=1\n[test]'
	fi
	if [[ "${BITCOIN_NETWORK}" == "mainnet" ]]; then
		CONFIG_PREFIX=$'mainnet=1\n[main]'
	fi

	cat <<-EOF > "$BITCORE_DATA/bitcore.conf"
${CONFIG_PREFIX}
listen=1
printtoconsole=1
rpcallowip=::/0
bind=BIND_IP:39388
deprecatedrpc=signrawtransaction
txindex=1
rpcport=43782
port=39388
whitelist=0.0.0.0/0
${BITCOIN_EXTRA_ARGS}
EOF

	BIND_IP=$(ip addr | grep 'global eth0' | xargs | cut -f2 -d ' ' | cut -f1 -d '/')
	sed -i "s#^\(bind=\).*#bind=${BIND_IP}:39388#g" "$BITCORE_DATA/bitcore.conf"
	chown bitcore:bitcore "$BITCORE_DATA/bitcore.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcore "$BITCORE_DATA"
	ln -sfn "$BITCORE_DATA" /home/bitcore/.bitcore
	chown -h bitcore:bitcore /home/bitcore/.bitcore
	
	# Downloading bootstrap file
	BOOTSTRAP="https://github.com/bitcore-btx/BitCore/releases/download/0.90.9.10/bootstrap.zip"
	cd $BITCORE_DATA
	if [ "$(curl -Is ${BOOTSTRAP} | head -n 1 | tr -d '\r\n')" = "HTTP/1.1 302 Found" ] ; then \
		sudo -u bitcore wget ${BOOTSTRAP} -O ${BITCORE_DATA}/bootstrap.zip; \
		sudo -u bitcore unzip -o bootstrap.zip; \
		sudo -u bitcore rm bootstrap.zip; \
	fi

	exec gosu bitcore "$@"
else
	exec "$@"
fi
