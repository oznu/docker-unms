# Multi-stage build - See https://docs.docker.com/engine/userguide/eng-image/multistage-build
FROM ubnt/unms as unms

FROM oznu/s6-node:latest

# Copy UNMS app from offical image since the source code is not published at this time
COPY --from=unms /home/app/unms /app

RUN apk add --no-cache python make gcc g++ openssl postgresql redis \
  && apk add vips-dev fftw-dev rabbitmq-server \
    --no-cache --repository https://dl-cdn.alpinelinux.org/alpine/edge/testing/

WORKDIR /app

# Re-install node modules
RUN rm -rf /app/node_modules \
  && yarn install --ignore-engines \
  && mkdir /app/cert

# Prepare for rabbitmq-server
RUN deluser rabbitmq \
  && addgroup -S rabbitmq && adduser -S -h /var/lib/rabbitmq -G rabbitmq rabbitmq \
  && mkdir -p /var/lib/rabbitmq /etc/rabbitmq \
  && chown -R rabbitmq:rabbitmq /var/lib/rabbitmq /etc/rabbitmq \
  && chmod -R 777 /var/lib/rabbitmq /etc/rabbitmq \
  && ln -sf /var/lib/rabbitmq/.erlang.cookie /root/

ENV PGDATA=/config/postgres \
  POSTGRES_DB=unms \
  HOME=/var/lib/rabbitmq

COPY root /
