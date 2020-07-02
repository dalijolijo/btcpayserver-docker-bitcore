# btcpayserver-docker-bitcore
BTX Docker image for btcpayserver-docker - needed for [btcpayserver-docker](https://github.com/btcpayserver/btcpayserver-docker)

## Build new docker image version
Clone repository
```sh
git clone https://github.com/dalijolijo/btcpayserver-docker-bitcore.git
```

Change version in docker-bitcored/VERSION file and build new docker image with <new_version> tag
```sh
docker build -t dalijolijo/docker-bitcore:<new_version> .
```

Push new version to https://hub.docker.com/r/dalijolijo/docker-bitcore/tags/
```sh
docker push dalijolijo/docker-bitcore:<new_version>
```
