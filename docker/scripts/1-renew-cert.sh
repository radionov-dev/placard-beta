#!/bin/sh

# Certificates exist
if [ -n "$DOMAIN" -a -d /etc/letsencrypt/live/"$DOMAIN" ]; then
  # Check certificates and renew them
  certbot renew --http-01-port=380

  # Concatenate certificates
  . /etc/scripts/2-concatenate-cert.sh

  # Update certificates in HAProxy
  . /etc/scripts/3-update-haproxy-cert.sh

# Certificates don't exist
else
  #  Execute certificate creation script
  . /etc/scripts/0-create-cert.sh
fi

