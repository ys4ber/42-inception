FROM debian:bullseye

RUN apt-get update && apt-get install -y vsftpd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html && \
    mkdir -p /var/run/vsftpd/empty && \
    chmod 555 /var/run/vsftpd/empty

COPY ./conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY ./tools/setup.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 21

CMD ["/usr/local/bin/setup.sh"]