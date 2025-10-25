FROM debian:bookworm

RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Gen certificat auto-signé SSL
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/key.key \
    -out /etc/nginx/ssl/key.crt \
    -subj "/C=MO/ST=KH/L=KH/O=42/OU=42/CN=$DOMAIN_NAME"

# Copie file confi Nginx
COPY ./tools/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]