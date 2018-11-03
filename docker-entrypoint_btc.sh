#!/bin/bash
set -e

if [[ "$1" == "bitcore-cli" || "$1" == "bitcore-tx" || "$1" == "bitcored" ]]; then
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
        printtoconsole=1
        rpcallowip=::/0
        ${BITCOIN_EXTRA_ARGS}
        EOF
        chown bitcore:bitcore "$BITCORE_DATA/bitcore.conf"

        # ensure correct ownership and linking of data directory
        # we do not update group ownership here, in case users want to mount
        # a host directory and still retain access to it
        chown -R bitcore "$BITCORE_DATA"
        ln -sfn "$BITCOIN_DATA" /home/bitcore/.bitcore
        chown -h bitcore:bitcore /home/bitcore/.bitcore

        exec gosu bitcore "$@"
else
        exec "$@"
fi
