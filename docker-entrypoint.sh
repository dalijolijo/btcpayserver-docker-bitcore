#!/bin/bash
set -e

if [[ "$1" == "bitcore-cli" || "$1" == "bitcore-tx" || "$1" == "bitcored" || "$1" == "test_bitcore" ]]; then
        mkdir -p "$BITCORE_DATA"

        cat <<-EOF > "$BITCORE_DATA/bitcore.conf"
        printtoconsole=1
        rpcallowip=::/0
        ${BITCORE_EXTRA_ARGS}
        EOF
        chown bitcore:bitcore "$BITCORE_DATA/bitcore.conf"

        # ensure correct ownership and linking of data directory
        # we do not update group ownership here, in case users want to mount
        # a host directory and still retain access to it
        chown -R bitcore "$BITCORE_DATA"
        ln -sfn "$BITCORE_DATA" /home/bitcore/.bitcore
        chown -h bitcore:bitcore /home/bitcore/.bitcore

        exec gosu bitcore "$@"
else
        exec "$@"
fi
