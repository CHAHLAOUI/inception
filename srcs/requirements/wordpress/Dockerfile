FROM debian:bullseye

RUN apt  update && apt  upgrade -y && apt  install curl -y

RUN apt install php php-fpm php-mysql mariadb-client wget -y

COPY tools/setup.sh /

RUN  chmod +x setup.sh

ENTRYPOINT [ "./setup.sh" ]