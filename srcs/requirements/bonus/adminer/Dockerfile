FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php \
    php-mysql \
    wget

WORKDIR /var/www/html/

RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
    mv adminer-4.8.1.php index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080"]