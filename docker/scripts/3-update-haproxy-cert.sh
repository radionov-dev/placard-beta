#!/bin/sh

# Start transaction
echo -e "set ssl cert /usr/local/etc/haproxy/certificates/site.pem <<\n$(cat /etc/certificates/site.pem)\n" | socat tcp-connect:haproxy:9999 -

# Commit transaction
echo "commit ssl cert /usr/local/etc/haproxy/certificates/site.pem" | socat tcp-connect:haproxy:9999 -

# Show certification info (not essential)
echo "show ssl cert /usr/local/etc/haproxy/certificates/site.pem" | socat tcp-connect:haproxy:9999 -
