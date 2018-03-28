[![Docker Build Status](https://img.shields.io/docker/build/oznu/unms.svg?label=x64%20build)](https://hub.docker.com/r/oznu/unms/) [![Travis](https://img.shields.io/travis/oznu/docker-unms.svg?label=arm%20build)](https://travis-ci.org/oznu/docker-unms) [![GitHub release](https://img.shields.io/github/release/oznu/unms/all.svg)](https://github.com/oznu/docker-unms/releases)

# Docker UNMS

This is an all-in-one Alpine Linux based Docker image for running the [Ubiquiti Network Management System](https://unms.com/). This image contains all the components required to run [UNMS](https://unms.com/) in a single container and uses the [s6-overlay](https://github.com/just-containers/s6-overlay) for process management.

This image will run on most platforms that support Docker including [Docker for Mac](https://www.docker.com/docker-mac), [Docker for Windows](https://www.docker.com/docker-windows), Synology DSM and Raspberry Pi boards.

## Usage

```shell
docker run \
  -p 80:80 \
  -p 443:443 \
  -e TZ=<timezone> \
  -v </path/to/config>:/config \
  oznu/unms:latest
```

## Raspberry Pi / ARMv6

This image will also allow you to run [UNMS](https://unms.com/) on a Raspberry Pi or other Docker-enabled ARMv6/7/8 devices by using the `armhf` tag.

```
docker run -d --name unms -p 80:80 -p 443:443 -v </path/to/config>:/config oznu/unms:armhf
```

## Parameters

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.

* `-v </path/to/config>:/config` - The persistent data location, the database, certs and logs will be stored here
* `-p 80:80` - Expose the HTTP web server port on the docker host
* `-p 443:443` - Expose the HTTPS and WSS web server port on the docker host
* `-e TZ` - for [timezone information](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) e.g. `-e TZ=Europe/London`

*Optional Settings:*

* `-e DEMO=false` - Enable UNMS demo mode
* `-e PUBLIC_HTTPS_PORT=443` - This should match the HTTPS port your are exposing to on the docker host
* `-e PUBLIC_WS_PORT=443` - This should match the HTTPS port your are exposing to on the docker host
* `-e SECURE_LINK_SECRET=` - Random key for secure link module. Set this to something random.

## Limitations

The Docker image, oznu/unms, is not maintained by or affiliated with Ubiquiti Networks. You should not expect any support from Ubiquiti when running UNMS using this image.

* In-app upgrades will not work. You can upgrade UNMS by downloading the latest version of this image.
* Device firmware upgrades initiated from UNMS may not work ([#7](https://github.com/oznu/docker-unms/issues/7)).

## Docker Compose

```yml
version: '2'
services:
  homebridge:
    image: oznu/unms:latest  # use "armhf" instead of "latest" for arm devices
    restart: always
    ports:
      - 80:80
      - 443:443
    environment:
      - TZ=Australia/Sydney
    volumes:
      - ./volumes/unms:/config
```
