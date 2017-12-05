#!/bin/sh

in=$1
out=$2

WS_PORT=${WS_PORT:-${HTTPS_PORT}}
PUBLIC_HTTPS_PORT=${PUBLIC_HTTPS_PORT:-${HTTPS_PORT}}

echo "Running fill-template.sh $*"

cp -f "${in}" "${out}"

sed -i -- "s|##HTTP_PORT##|${HTTP_PORT}|g" "${out}"
sed -i -- "s|##HTTPS_PORT##|${HTTPS_PORT}|g" "${out}"
sed -i -- "s|##WS_PORT##|${WS_PORT}|g" "${out}"
sed -i -- "s|##UNMS_HTTP_PORT##|${UNMS_HTTP_PORT}|g" "${out}"
sed -i -- "s|##UNMS_WS_PORT##|${UNMS_WS_PORT}|g" "${out}"
sed -i -- "s|##PUBLIC_HTTPS_PORT##|${PUBLIC_HTTPS_PORT}|g" "${out}"

if [ -z "${SSL_CERT}" ]; then
  sed -i -- "s|##SSL_CERTIFICATE##|ssl_certificate /config/unms/cert/live.crt;|g" "${out}"
  sed -i -- "s|##SSL_CERTIFICATE_KEY##|ssl_certificate_key /config/unms/cert/live.key;|g" "${out}"
  sed -i -- "s|##SSL_CERTIFICATE_CA##||g" "${out}"
else
  sed -i -- "s|##SSL_CERTIFICATE##|ssl_certificate /config/unms/cert/${SSL_CERT};|g" "${out}"
  sed -i -- "s|##SSL_CERTIFICATE_KEY##|ssl_certificate_key /config/unms/cert/${SSL_CERT_KEY};|g" "${out}"
  if [ ! -z "${SSL_CERT_CA}" ]; then
    sed -i -- "s|##SSL_CERTIFICATE_CA##|ssl_certificate_ca /config/unms/cert/${SSL_CERT_CA};|g" "${out}"
  fi
fi
