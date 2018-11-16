FROM ubuntu:16.04

RUN groupadd -r bitcore && useradd -r -m -g bitcore bitcore

RUN set -ex \
    && apt-get update \
    && apt-get install -qq --no-install-recommends software-properties-common ca-certificates dirmngr sudo wget sudo curl supervisor gosu \
    && apt-get install -qq --no-install-recommends libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-thread-dev libminiupnpc10 libevent-dev libdb++-dev \
    && add-apt-repository -y ppa:bitcoin/bitcoin \
    && apt-get update \
    && apt-get install -y libdb4.8-dev libdb4.8++-dev \
    && rm -rf /var/lib/apt/lists/*

ENV BITCORE_VERSION 0.15.2
ENV BITCORE_URL https://github.com/LIMXTEC/BitCore/releases/download/0.15.2.0.0/linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz
ENV BITCORE_SHA256 b9092c1ad8e814b95f1d2199c535f24a02174af342399fe9b7f457d9d182f5a4

# download Bitcore binaries
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
