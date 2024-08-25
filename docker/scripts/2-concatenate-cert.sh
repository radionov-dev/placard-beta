#!/bin/sh

cd /etc/letsencrypt/live/"$DOMAIN"

if [ -f fullchain.pem -a -f privkey.pem ]; then
  cat fullchain.pem privkey.pem > /etc/certificates/site.pem
fi

