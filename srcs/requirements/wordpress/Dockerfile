FROM debian:bullseye

RUN apt-get update -y && apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /var/www/site

WORKDIR /var/www/site


COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh


# EXPOSE 9000

CMD ["bash", "/usr/local/bin/entrypoint.sh"]
