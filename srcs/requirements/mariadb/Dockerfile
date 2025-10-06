FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/init_db.sh

EXPOSE 3306

CMD ["entrypoint.sh"]
