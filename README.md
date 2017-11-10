# Docker UNMS

**This image is still in development!**

This is a all-in-one Alpine Linux based Docker image for running the [Ubiquiti Network Management System](https://unms.com/). This image contains all the components required to run [UNMS](https://unms.com/) in a single container and uses the [s6-overlay](https://github.com/just-containers/s6-overlay) for process management.

* PostgreSQL
* Redis
* RabbitMQ Server
* Node.js

## Usage

```shell
docker run \
  -p 8081:8081 -p 8444:8444 \
  -v </path/to/config>:/config
  oznu/unms
```

## Parameters

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side.

* `-p 8081:8081 -p 8444:8444` - Exposes ports 8081 and 8444 to the Docker host
* `-v </path/to/config>:/config` - The persistent data location, the database and logs will be stored here.

## Docker Compose

```yml
version: '2'
services:
  homebridge:
    image: oznu/unms:latest
    restart: always
    environment:
      - TZ=Australia/Sydney
      - PGID=1000
      - PUID=1000
    volumes:
      - ./volumes/unms:/config
```
