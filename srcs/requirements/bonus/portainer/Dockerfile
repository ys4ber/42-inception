FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    curl \
    && curl -L https://github.com/portainer/portainer/releases/download/2.11.1/portainer-2.11.1-linux-amd64.tar.gz -o portainer.tar.gz \
    && tar xvzf portainer.tar.gz \
    && rm portainer.tar.gz

EXPOSE 9000

CMD ["/portainer/portainer"]