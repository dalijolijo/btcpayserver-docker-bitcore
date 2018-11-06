FROM debian:stretch-slim

RUN groupadd -r bitcore && useradd -r -m -g bitcore bitcore

RUN set -ex \
    && apt-get update \
    && apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget \
    && apt-get install -qq --no-install-recommends libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-thread-dev libminiupnpc10 libevent-dev libdb++-dev \
    && rm -rf /var/lib/apt/lists/*

RUN ln -s /usr/lib/x86_64-linux-gnu/libboost_system.so.1.62.0 /usr/lib/x86_64-linux-gnu/libboost_system.so.1.58.0 \
    && ln -s /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.62.0 /usr/lib/x86_64-linux-gnu/libboost_filesystem.so.1.58.0 \
    && ln -s /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.62.0 /usr/lib/x86_64-linux-gnu/libboost_program_options.so.1.58.0 \
    && ln -s /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.62.0 /usr/lib/x86_64-linux-gnu/libboost_thread.so.1.58.0 \
    && ln -s /usr/lib/x86_64-linux-gnu/libboost_chrono.so.1.62.0 /usr/lib/x86_64-linux-gnu/libboost_chrono.so.1.58.0 \
    && ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 \
    && ln -s /usr/lib/x86_64-linux-gnu/libdb_cxx-5.3.so /usr/lib/x86_64-linux-gnu/libdb_cxx-4.8.so

ENV BITCORE_VERSION 0.15.2
ENV BITCORE_URL https://github.com/LIMXTEC/BitCore/releases/download/0.15.2.0.0/linux.Ubuntu.16.04.LTS-static-libstdc.tar.gz
ENV BITCORE_SHA256 b9092c1ad8e814b95f1d2199c535f24a02174af342399fe9b7f457d9d182f5a4

# install Bitcore binaries
RUN set -ex \
    && cd /tmp \
    && wget -qO bitcore.tar.gz "$BITCORE_URL" \
    && echo "$BITCORE_SHA256 bitcore.tar.gz" | sha256sum -c - \
    && tar -xzvf bitcore.tar.gz -C /usr/local/bin --exclude=*-qt \
    && rm -rf /tmp/*

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
