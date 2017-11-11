# Multi-stage build - See https://docs.docker.com/engine/userguide/eng-image/multistage-build
FROM ubnt/unms:0.10.4 as unms

FROM oznu/s6-node:8.9.0

# Copy UNMS app from offical image since the source code is not published at this time
COPY --from=unms /home/app/unms /app

RUN sed -i 's/edge\/community/edge\/testing/g' /etc/apk/repositories \
  && apk add --no-cache python make gcc g++ openssl postgresql redis bash \
  vips-dev fftw-dev rabbitmq-server

WORKDIR /app

# Re-install node modules
RUN rm -rf /app/node_modules \
  && yarn install --ignore-engines

# Prepare for rabbitmq-server
RUN deluser rabbitmq \
  && addgroup -S rabbitmq && adduser -S -h /var/lib/rabbitmq -G rabbitmq rabbitmq \
  && mkdir -p /var/lib/rabbitmq /etc/rabbitmq \
  && chown -R rabbitmq:rabbitmq /var/lib/rabbitmq /etc/rabbitmq \
  && chmod -R 777 /var/lib/rabbitmq /etc/rabbitmq \
  && ln -sf /var/lib/rabbitmq/.erlang.cookie /root/

ENV PGDATA=/config/postgres \
  POSTGRES_DB=unms \
  HOME=/var/lib/rabbitmq \
  PROD=true \
  HTTP_PORT=8081 \
  HTTPS_PORT=8444 \
  PUBLIC_HTTPS_PORT=443 \
  PUBLIC_WS_PORT=443 \
  BEHIND_REVERSE_PROXY=false

EXPOSE 8081 8444

VOLUME ["/config"]

COPY root /
