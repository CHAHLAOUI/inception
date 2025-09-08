# Dockerfile
FROM debian:11-slim

ENV DEBIAN_FRONTEND=noninteractive

# تثبيت nginx و openssl و ca-certificates
RUN apt-get update \
    && apt-get install -y --no-install-recommends nginx openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /etc/nginx/certs

# نسخ ملفات الكونفيج
COPY conf/nginx.conf /etc/nginx/nginx.conf

# نسخ السكريبت ديال entrypoint
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# فتح بورت HTTPS
EXPOSE 443

# تشغيل السكريبت كـ entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# الأمر الافتراضي لتشغيل nginx في foreground
CMD ["nginx", "-g", "daemon off;"]
