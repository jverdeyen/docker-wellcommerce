FROM debian:jessie

MAINTAINER Joeri Verdeyen <info@jverdeyen.be>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y nginx \
    php5-fpm \
    php5-mysql \
    php5-mcrypt \
    php5-gd \
    php5-memcached \
    php5-curl \
    php-pear \
    php5-apcu \
    php5-cli \
    php5-curl \
    php5-mcrypt \
    php5-sqlite \
    php5-intl \
    php5-tidy \
    php5-imap \
    php5-imagick \
    php5-json \
    php5-redis \
    php5-imagick \
    unzip \
    git \
    supervisor \
    curl

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN git clone -b master https://github.com/WellCommerce/WellCommerce.git /var/www/app
RUN composer install -n --ignore-platform-reqs -o --no-scripts -d /var/www/app

COPY parameters.yml /var/www/app/app/config/parameters.yml
COPY vhost.conf /etc/nginx/sites-enabled/default
COPY supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN sed -e 's/;daemonize = yes/daemonize = no/' -i /etc/php5/fpm/php-fpm.conf
RUN sed -e 's/;listen\.owner/listen.owner/' -i /etc/php5/fpm/pool.d/www.conf
RUN sed -e 's/;listen\.group/listen.group/' -i /etc/php5/fpm/pool.d/www.conf
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

ADD init.sh /init.sh

EXPOSE 80

CMD ["/init.sh"]