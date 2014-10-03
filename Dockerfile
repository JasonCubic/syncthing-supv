# Syncthing with supervisor Dockerfile

FROM ubuntu:14.04
MAINTAINER jcubic@gmail.com

ENV HOME /home/syncthing
ENV STNORESTART yes
ENV VERSION 0.9.19

RUN apt-get update
RUN apt-get install -y supervisor 
RUN apt-get install -y wget

RUN mkdir -p /var/syncthing_working/
RUN wget https://github.com/syncthing/syncthing/releases/download/v${VERSION}/syncthing-linux-amd64-v${VERSION}.tar.gz -P /var/syncthing_working/
RUN tar xzvf /var/syncthing_working/syncthing*.tar.gz -C /var/syncthing_working/
RUN cp /var/syncthing_working/sync*/syncthing /usr/local/bin
RUN rm -rf /var/syncthing_working

RUN adduser --disabled-login --shell /bin/dash --gecos 'SyncThing' syncthing
RUN passwd -d syncthing

RUN rm /etc/supervisor/supervisord.conf
RUN echo [supervisord] >> /etc/supervisor/supervisord.conf
RUN echo nodaemon=true >> /etc/supervisor/supervisord.conf
RUN echo >> /etc/supervisor/supervisord.conf
RUN echo [program:syncthing] >> /etc/supervisor/supervisord.conf
RUN echo command=/usr/local/bin/syncthing >> /etc/supervisor/supervisord.conf
RUN echo user=root >> /etc/supervisor/supervisord.conf
RUN echo autorestart=true >> /etc/supervisor/supervisord.conf

EXPOSE 8080:8080 22000:22000 21025:21025/udp

VOLUME ["/home/syncthing/.config/syncthing", "/home/syncthing/Sync"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
