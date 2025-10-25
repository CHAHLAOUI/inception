FROM debian:bookworm

RUN apt update && apt install mariadb-server  -y 

RUN mkdir -p /var/lib/mysql &&  mkdir -p /run/mysqld &&\
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

COPY tools/entrypoint.sh /usr/bin/entrypoint.sh

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["bash", "/usr/bin/entrypoint.sh"]