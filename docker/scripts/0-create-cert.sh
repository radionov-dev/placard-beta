#!/bin/sh

set -e

if [ ! -f /etc/certificates/site.pem ]; then
  # Generate self-signed certificate
  openssl genrsa -out site.key 2048
  openssl req -new -key site.key -out site.csr -batch
  openssl x509 -req -days 365 -in site.csr -signkey site.key -out site.crt
  cat site.key site.crt >> /etc/certificates/site.pem
fi


if [ -n "$DOMAIN" -a -n "$EMAIL" ]; then

  # Request certificate
  certbot certonly --standalone \
    --non-interactive --agree-tos --http-01-port=380 \
    --email "$EMAIL" \
    --cert-name "$DOMAIN" \
    -d "$DOMAIN"

  # Concatenate certificates
  . /etc/scripts/2-concatenate-cert.sh

fi

# Update certificates in HAProxy
. /etc/scripts/3-update-haproxy-cert.sh

