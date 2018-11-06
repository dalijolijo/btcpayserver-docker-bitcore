FROM debian:stretch-slim

RUN groupadd -r bitcore && useradd -r -m -g bitcore bitcore

RUN set -ex \
    && apt-get update \
    && apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
    && apt-get install -qq --no-install-recommends libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-thread-dev libminiupnpc10 libevent-dev libdb++-dev \
    && rm -rf /var/lib/apt/lists/*

ENV BITCORE_VERSION 0.15.2
#ENV BITCORE_URL https://bitcore.cc/btx1520.2.tar.gz 
#ENV BITCORE_SHA256 b64e2287fb605b974d7fed7be64d7e8d37b027018c2f90b30788da2abedaf591 

# install Bitcore binaries
#RUN set -ex \
#    && cd /tmp \
#    && wget -qO bitcore.tar.gz "$BITCORE_URL" \
#    && echo "$BITCORE_SHA256 bitcore.tar.gz" | sha256sum -c - \
#    && tar -xzvf bitcore.tar.gz -C /usr/local/bin --exclude=*-qt \
#    && rm -rf /tmp/*

COPY bitcored /usr/local/bin
COPY bitcore-cli /usr/local/bin
COPY bitcore-tx /usr/local/bin

# create data directory
# To speed up sync process: https://bitcore.cc/bootstrap.tar.gz
ENV BITCORE_DATA /data
RUN mkdir "$BITCORE_DATA" \
    && chown -R bitcore:bitcore "$BITCORE_DATA" \
    && ln -sfn "$BITCORE_DATA" /home/bitcore/.bitcore \
    && chown -h bitcore:bitcore /home/bitcore/.bitcore
VOLUME /data

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8556 8555
CMD ["bitcored"]
