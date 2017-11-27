FROM ubuntu:trusty

MAINTAINER Matt Snoby <snobym@cisco.com>

ENV DEBIAN_FRONTEND noninteractive

# add NGINX official stable repository
RUN echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/nginx.list

# add PHP5.6 unofficial repository (https://launchpad.net/~ondrej/+archive/ubuntu/php)
RUN echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/php.list

# install packages
RUN apt-get update && \
    apt-get -y --force-yes --no-install-recommends install \
    ca-certificates\
    openssl         \
    nginx           \
    curl            \
    wget            \
    git             \
    mysql-client    \
    memcached       \
    drush           \
    mc              \
    php5.6-cli      \
    php5.6-fpm      \
    php5.6-common   \
    php5.6-mysql    \
    php5.6-gd       \
    php5.6-pgsql    \
    php5.6-sqlite   \
    php5.6-curl     \
    php5.6-json     \
    php5.6-redis    \
    php5.6-xml      \
    php5.6-mbstring \
    php5.6-memcache

# configure NGINX as non-daemon
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# configure php-fpm as non-daemon
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/5.6/fpm/php-fpm.conf

# clear apt cache and remove unnecessary packages
RUN apt-get autoclean && apt-get -y autoremove

# copy config file for Supervisor
#COPY config/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# backup default default config for NGINX
RUN mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bak
RUN  rm -rf /etc/nginx/sites-enabled/default
