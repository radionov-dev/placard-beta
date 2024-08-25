## syntax=docker/dockerfile:3

FROM alpine

# Install tor
RUN apk --no-cache add tor

CMD chmod 700 /var/lib/tor/hidden-service ;\
	chown -R tor /var/lib/tor/hidden-service;\
	cat /var/lib/tor/hidden-service/hostname 2>/dev/null;\
	/usr/bin/tor -f /etc/tor/torrc --runasdaemon 0


