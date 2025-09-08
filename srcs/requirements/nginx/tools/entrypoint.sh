#!/bin/sh
set -e

CERT_DIR="/etc/nginx/certs"

if [ ! -f "$CERT_DIR/nginx.crt" ] || [ ! -f "$CERT_DIR/nginx.key" ]; then
    echo "👉 Generating self-signed SSL certificate..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$CERT_DIR/nginx.key" \
        -out "$CERT_DIR/nginx.crt" \
        -subj "/C=MA/ST=Khouribga/L=Khouribga/O=42/OU=Student/CN=${DOMAIN_NAME}"
fi

exec "$@"
