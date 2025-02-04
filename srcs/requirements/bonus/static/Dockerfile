FROM nginx:alpine

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

RUN echo "Contents before copy:" && ls -la

COPY ./site/index.html /usr/share/nginx/html/
COPY ./conf/default.conf /etc/nginx/conf.d/

RUN echo "Contents after copy:" && ls -la

RUN chown -R nginx:nginx /usr/share/nginx/html && \
    chmod -R 755 /usr/share/nginx/html

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]