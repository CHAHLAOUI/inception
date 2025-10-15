FROM debian:bullseye

RUN apt  update && apt  upgrade -y && apt  install -y curl iputils-ping

RUN apt install -y php php-fpm php-mysql mariadb-client wget

COPY tools/setup.sh /

RUN  chmod +x setup.sh

ENTRYPOINT [ "./setup.sh" ]