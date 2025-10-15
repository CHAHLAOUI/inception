FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Gen certificat auto-signé SSL
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/key.key \
    -out /etc/nginx/ssl/key.crt \
    -subj "/C=MA/ST=Casablanca/L=Casa/O=42/OU=IT/CN=achahlao.42.fr"

# Copie file confi Nginx
COPY ./tools/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
