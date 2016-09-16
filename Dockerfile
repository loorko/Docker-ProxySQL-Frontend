FROM ubuntu:14.04
MAINTAINER Roland Goreczky
ENV REFRESHED_AT 2016-09-16

RUN apt-get update  
RUN apt-get install -y curl build-essential m4 libncurses5-dev libssh-dev libdbi-perl libdbd-mysql-perl
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  
RUN apt-get update && apt-get install perl  
RUN curl get.mojolicio.us | sh  
RUN curl -L http://cpanmin.us | perl - Mojolicious::Plugin::Config
RUN curl -L http://cpanmin.us | perl - Mojolicious::Plugin::I18N
RUN curl -L http://cpanmin.us | perl - DBI
RUN curl -L http://cpanmin.us | perl - Mojo::mysql
RUN curl -L http://cpanmin.us | perl - Try::Tiny
RUN curl -L http://cpanmin.us | perl - URI::Escape

VOLUME /var/log/docker
ADD . /srv/www

EXPOSE 8080

WORKDIR /srv/www/app

CMD hypnotoad -f script/app