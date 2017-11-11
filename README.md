[![Docker Build Status](https://img.shields.io/docker/build/oznu/unms.svg)](https://hub.docker.com/r/oznu/unms/) [![Docker Automated build](https://img.shields.io/docker/automated/oznu/unms.svg)](https://hub.docker.com/r/oznu/unms/)

# Docker UNMS

This is a all-in-one Alpine Linux based Docker image for running the [Ubiquiti Network Management System](https://unms.com/). This image contains all the components required to run [UNMS](https://unms.com/) in a single container and uses the [s6-overlay](https://github.com/just-containers/s6-overlay) for process management.

This image will run on most platforms that support Docker including [Docker for Mac](https://www.docker.com/docker-mac), [Docker for Windows](https://www.docker.com/docker-windows), Synology DSM and Raspberry Pi boards.

## Usage

```shell
docker run \
  -p 80:8080 \
  -p 443:8443 \
  -e PUID=<UID> -e PGID=<GID> \
  -e TZ=<timezone> \
  -v </path/to/config>:/config \
  oznu/unms:latest
```

## Raspberry Pi / ARMv6

This image will also allow you to run [UNMS](https://unms.com/) on a Raspberry Pi or other Docker-enabled ARMv6/7/8 devices by using the `armhf` tag.

```
docker run -d --name unms -p 80:8080 -p 443:8443 -v </path/to/config>:/config oznu/unms:armhf
```

## Parameters

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.

* `-v </path/to/config>:/config` - The persistent data location, the database, certs and logs will be stored here
* `-p 80:8080` - Expose the HTTP web server port on the docker host
* `-p 443:8443` - Expose the HTTPS and WSS web server port on the docker host
* `-e TZ` - for [timezone information](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) e.g. `-e TZ=Europe/London`
* `-e PGID` - for GroupID - see below for explanation
* `-e PUID` - for UserID - see below for explanation

*Optional Settings:*

* `-e DEMO=false` - Enable UNMS demo mode
* `-e BEHIND_REVERSE_PROXY=false` - Set to true to disable automated Let's Encrypt SSL Certificates
* `-e PUBLIC_HTTPS_PORT=443` - This should match the HTTPS port your are exposing to on the docker host
* `-e PUBLIC_WS_PORT=443` - This should match the HTTPS port your are exposing to on the docker host

### User / Group Identifiers

Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work".

In this instance `PUID=1001` and `PGID=1001`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```

## Docker Compose

```yml
version: '2'
services:
  homebridge:
    image: oznu/unms:latest
    restart: always
    ports:
      - 80:8080
      - 443:8443
    environment:
      - TZ=Australia/Sydney
      - PGID=1000
      - PUID=1000
    volumes:
      - ./volumes/unms:/config
```
