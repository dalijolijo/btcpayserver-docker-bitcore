FROM debian:stretch-slim

RUN groupadd -r bitcore && useradd -r -m -g bitcore bitcore

RUN set -ex \
    && apt-get update \
    && apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget sudo curl iproute2 \
    && apt-get install -qq --no-install-recommends libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-thread-dev libminiupnpc10 libevent-dev libdb++-dev \
    && rm -rf /var/lib/apt/lists/*

ENV BITCORE_VERSION 0.15.2
ENV BITCORE_URL https://bitcore.cc/bitcore.152.tar.gz 
ENV BITCORE_SHA256 bf73545cc9e59a7386212daed87027bd7442644caf848a1073c0e860c7b603ce 

# install Bitcore binaries
RUN set -ex \
    && cd /tmp \
    && wget -qO bitcore.tar.gz "$BITCORE_URL" \
    && echo "$BITCORE_SHA256 bitcore.tar.gz" | sha256sum -c - \
    && tar -xzvf bitcore.tar.gz -C /usr/local/bin --exclude=*-qt \
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
