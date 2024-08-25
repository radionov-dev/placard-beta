## syntax=docker/dockerfile:3

FROM bitnami/php-fpm:7.4.30

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

EXPOSE 9000

# Placard default Mysql credentials
ENV DB_HOST=mysql \
    DB_DATABASE=mysql_database \
    DB_USERNAME=mysql_user \
    DB_PASSWORD=mysql_password

# Install Placard dependencies:
# nodejs for compiling SCSS to CSS
# mariadb-client for mysql exist check
# gettext-base for envsubst util
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nodejs \
        mariadb-client \
        gettext-base \
        php-imagick \
        php-bcmath \
        #php-mysql \
        #php-mbstring \
        #php-tokenizer \
        #php-xml php-xmlrpc \
        #php-json \
        #imagemagick \
    && rm -rf /var/lib/apt/lists/*

# Add php-fpm socket
RUN sed -i 's%listen = 9000%&\nlisten = /opt/bitnami/php/var/run/php-fpm.sock\nlisten.mode = 0666%' /opt/bitnami/php/etc/php-fpm.d/www.conf

# Get placard sources
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends git \
    && git clone https://git.bitdeals.org/private/placard.git .\
    && apt-get -y remove git \
    && rm -rf /var/lib/apt/lists/* 
RUN chown -R www-data:www-data .

# Get placard sources from local storage
#COPY --chown=www-data:www-data placard/ .

# Change owner for unprivileged nginx access
RUN chown -R www-data:daemon ./storage ./public ;\
	find ./storage ./public -type d -exec chmod 0775 {} \; ;\
	find ./storage ./public -type f -exec chmod 0664 {} \; ;\
        find ./storage ./public -type d -exec chmod g+s {} \; 

RUN chmod 755 ./docker/entrypoint.sh
CMD ["./docker/entrypoint.sh"]

