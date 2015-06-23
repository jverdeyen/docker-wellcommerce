FROM debian:jessie

MAINTAINER Joeri Verdeyen <info@jverdeyen.be>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y nginx \
    php5-fpm \
    php5-json \
    php5-cli \
    php5-mysql \
    php5-curl \
    unzip \
    git \
    supervisor \
    nodejs \
    npm \
    curl

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

COPY vhost.conf /etc/nginx/sites-enabled/default
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf
RUN sed -e 's/;listen\.owner/listen.owner/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/;listen\.group/listen.group/' -i /etc/php5/fpm/pool.d/www.conf
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

ADD init.sh /init.sh

VOLUME ["/var/www/app"]

EXPOSE 80

CMD ["/init.sh"]