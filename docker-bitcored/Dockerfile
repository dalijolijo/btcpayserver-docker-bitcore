FROM debian:buster-slim

RUN groupadd -r bitcore && useradd -r -m -g bitcore bitcore

RUN set -ex \
    && apt-get update \
    && apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget sudo curl iproute2 unzip \
    && rm -rf /var/lib/apt/lists/*
#    && apt-get install -qq --no-install-recommends libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-thread-dev libevent-dev libdb++-dev \

ENV BITCORE_VERSION 0.90.9.1
ENV BITCORE_URL https://github.com/LIMXTEC/BitCore/releases/download/${BITCORE_VERSION}/bitcore-x86_64-linux-gnu_no-wallet.tar.gz
ENV BITCORE_SHA256 7dc0f84799d025e7acbf13a985d69c2069f8e401b7d493766632a5339c1db8f8

# install Bitcore binaries
RUN set -ex \
    && cd /tmp \
    && wget -qO bitcore.tar.gz "$BITCORE_URL" \
    && echo "$BITCORE_SHA256 bitcore.tar.gz" | sha256sum -c - \
    && tar -xzvf bitcore.tar.gz -C /tmp/ --exclude=*-qt \
    && mv /tmp/bin/bitcore* /usr/local/bin/ \
    && mv /tmp/lib /usr/local/bin/ \
    && rm -rf /tmp/*

# create data directory
ENV BITCORE_DATA /data
RUN mkdir "$BITCORE_DATA" \
    && chown -R bitcore:bitcore "$BITCORE_DATA" \
    && ln -sfn "$BITCORE_DATA" /home/bitcore/.bitcore \
    && chown -h bitcore:bitcore /home/bitcore/.bitcore
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8555 8556 8666 50332 19444 50332
CMD ["bitcored"]
