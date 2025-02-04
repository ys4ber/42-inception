FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    curl \
    lsb-release \
    ca-certificates \
    apt-transport-https \
    software-properties-common && \
    curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg && \
    sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ bullseye main" > /etc/apt/sources.list.d/php.list' && \
    apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-common \
    php8.2-curl \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    php8.2-gd \
    php8.2-redis \
    wget \
    mariadb-client

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN mkdir -p /run/php && mkdir -p /var/www/html
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/

COPY tools/script.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/script.sh

WORKDIR /var/www/html

EXPOSE 9000

CMD ["/usr/local/bin/script.sh"]
