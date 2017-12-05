#!/bin/sh

set -e

echo "Running cert.sh $*"
domain=$1

# don't do anything if user provides a custom certificate
if [ ! -z "${SSL_CERT}" ]; then
  echo "Custom certificate is set up, exiting"
  exit 0
fi

# domain name is required
if [ -z "${domain}" ]; then
  echo "No domain specified, exiting"
  exit 1
fi

echo "Looking for an existing self-signed certificate for ${domain}"

if [ -f "/config/unms/cert/${domain}.crt" ] && [ -f "/config/unms/cert/${domain}.key" ]; then
  echo "Found existing self-signed certificate for ${domain}"
else
  echo "Generating self-signed certificate for ${domain}"
  SAN="DNS:${domain}" openssl req -nodes -x509 -newkey rsa:4096 -subj "/CN=${domain}" -keyout "/config/unms/cert/${domain}.key" -out "/config/unms/cert/${domain}.crt" -days "36500" -batch -config "/defaults/openssl.cnf"
fi
ln -fs "./${domain}.crt" "/config/unms/cert/live.crt"
ln -fs "./${domain}.key" "/config/unms/cert/live.key"

echo "Reloading Nginx configuration"
sudo /usr/sbin/nginx -s reload

echo "cert.sh ${domain} finished successfully"
