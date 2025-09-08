FROM debian:11-slim

ENV DEBIAN_FRONTEND=noninteractive

# تثبيت PHP + curl + ca-certificates
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      php-fpm php-mysql curl unzip less mariadb-client ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x wp-cli.phar \
 && mv wp-cli.phar /usr/local/bin/wp
