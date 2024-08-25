## syntax=docker/dockerfile:3

FROM certbot/certbot:latest

# Install socat
RUN apk --no-cache add socat

# Copy scripts
COPY ./docker/scripts/ /etc/scripts/
RUN chmod 755 /etc/scripts/*.sh

# Expose port 380
EXPOSE 380

