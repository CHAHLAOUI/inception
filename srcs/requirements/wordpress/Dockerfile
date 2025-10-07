FROM debian:bullseye

# نثبت الأدوات اللازمة
RUN apt-get update -y && apt-get install -y \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# ننشئ مجلد موقع ووردبريس
RUN mkdir -p /var/www/site
WORKDIR /var/www/site

# ننسخ سكريبت الإعداد
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# نفتح المنفذ اللي يستخدمه php-fpm
EXPOSE 9000

# نشغل php-fpm و سكريبت الإعداد
CMD ["bash", "/usr/local/bin/entrypoint.sh"]
