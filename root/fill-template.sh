#!/bin/sh

in=$1
out=$2

WS_PORT=${WS_PORT:-${HTTPS_PORT}}
PUBLIC_HTTPS_PORT=${PUBLIC_HTTPS_PORT:-${HTTPS_PORT}}

echo "Running fill-template.sh $*"

cp -f "${in}" "${out}"

sed -i -- "s|##LOCAL_NETWORK##|${LOCAL_NETWORK}|g" "${out}"
sed -i -- "s|##HTTP_PORT##|${HTTP_PORT}|g" "${out}"
sed -i -- "s|##HTTPS_PORT##|${HTTPS_PORT}|g" "${out}"
sed -i -- "s|##WS_PORT##|${WS_PORT}|g" "${out}"
sed -i -- "s|##UNMS_HTTP_PORT##|${UNMS_HTTP_PORT}|g" "${out}"
sed -i -- "s|##UNMS_WS_PORT##|${UNMS_WS_PORT}|g" "${out}"
sed -i -- "s|##PUBLIC_HTTPS_PORT##|${PUBLIC_HTTPS_PORT}|g" "${out}"
