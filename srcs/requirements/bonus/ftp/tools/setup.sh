#!/bin/bash

useradd -m -d /var/www/html ${FTP_USER}
echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd

chown -R ${FTP_USER}:${FTP_USER} /var/www/html


# start ftp (vsftpd)
/usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
