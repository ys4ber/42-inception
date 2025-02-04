#!/bin/sh

while ! mysqladmin ping -h"$DB_HOST" --silent; do
    echo "waiting for mysql ..."
    sleep 2
done

cd /var/www/html

wp core download --allow-root

wp config create --allow-root \
    --dbname="$DB_NAME" \
    --dbuser="$DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="$DB_HOST" \
    --dbcharset="utf8"

# -------------------- redis -------------------- #

wp config set WP_REDIS_HOST redis --allow-root
wp config set WP_REDIS_PORT 6379 --allow-root
wp config set WP_CACHE true --allow-root

# ------------------------------------------------ #

wp core install --allow-root \
    --url="$WP_URL" \
    --title="Inception" \
    --admin_user="$DB_USER" \
    --admin_password="$DB_PASSWORD" \
    --admin_email="youss42@proton.me"

wp plugin install redis-cache --activate --allow-root
wp redis enable --allow-root

chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
exec $(find /usr/sbin -name 'php-fpm*' | sort -V | tail -n 1) -F