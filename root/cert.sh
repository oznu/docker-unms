#!/bin/sh

set -e

echo "Running cert.sh $*"
domain=$1

# if custom certificate is used, make sure that it is up to date
if [ ! -z "${SSL_CERT}" ]; then
  CERT_FILE="/config/unms/cert/live.crt"
  KEY_FILE="/config/unms/cert/live.key"
  if ! [ "${CERT_FILE}" -ot "/config/usercert/${SSL_CERT}" ] \
      && ! [ "${KEY_FILE}" -ot "/config/usercert/${SSL_CERT_KEY}" ] \
      && ([ -z "${SSL_CERT_CA}" ] || ! [ "${CERT_FILE}" -ot "/config/usercert/${SSL_CERT_CA}" ]);
    then
    echo "Custom SSL certificate not changed, exiting"
    exit 0
  fi

  if [ ! -z "${SSL_CERT_CA}" ]; then
    echo "Joining '/config/usercert/${SSL_CERT}' and '/config/usercert/${SSL_CERT_CA}' into '${CERT_FILE}'"
    cat "/config/usercert/${SSL_CERT}" "/config/usercert/${SSL_CERT_CA}" > /cert/live.crt
  else
    echo "Copying '/config/usercert/${SSL_CERT}' to '${CERT_FILE}'"
    cp -a "/config/usercert/${SSL_CERT}" ${CERT_FILE}
  fi
  cp -a "/config/usercert/${SSL_CERT_KEY}" ${KEY_FILE}

  echo "Reloading Nginx configuration"
  sudo /usr/sbin/nginx -s reload
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

  # determine subjectAltName - IP addressess need both IP and DNS, domains just need DNS
  case "${domain}" in
    *:*)    SAN="IP:${domain},DNS:${domain}" ;; # contains ":" - IPv6 address
    *[0-9]) SAN="IP:${domain},DNS:${domain}" ;; # ends with a digit - IPv4 address
    *)      SAN="DNS:${domain}" ;;              # else domain name
  esac

  SAN="${SAN}" openssl req -nodes -x509 -newkey rsa:4096 -subj "/CN=${domain}" -keyout "/config/unms/cert/${domain}.key" -out "/config/unms/cert/${domain}.crt" -days "36500" -batch -config "/defaults/openssl.cnf"
fi
ln -fs "./${domain}.crt" "/config/unms/cert/live.crt"
ln -fs "./${domain}.key" "/config/unms/cert/live.key"

echo "Reloading Nginx configuration"
sudo /usr/sbin/nginx -s reload

echo "cert.sh ${domain} finished successfully"
