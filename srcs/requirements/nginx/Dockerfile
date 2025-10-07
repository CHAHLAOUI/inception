
FROM debian:bullseye

RUN apt-get update -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=MA/ST=Casablanca/L=Casablanca/O=Inception/CN=localhost"

# Copie 
COPY ./tools/nginx.conf /etc/nginx/conf.d/default.conf

# Démarre nginx 
CMD ["nginx", "-g", "daemon off;"]
