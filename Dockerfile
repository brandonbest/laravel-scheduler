FROM php:cli-alpine

ENV WEB_DOCUMENT_ROOT "/app/public"
WORKDIR /app

RUN apk update
RUN apk upgrade

####################################
#
#  Base Packages
#
####################################

# Setup Zip
RUN apk add zip unzip git libzip-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

RUN docker-php-ext-install bcmath ctype fileinfo tokenizer

# Setup Required PHP Extensions
RUN apk add oniguruma-dev
RUN docker-php-ext-install mbstring \
    && docker-php-ext-enable mbstring \
    && rm -rf /tmp/*

RUN docker-php-ext-install pdo pdo_mysql \
    && docker-php-ext-enable pdo pdo_mysql \
    && rm -rf /tmp/*

# Postgres
RUN apk add postgresql-libs postgresql-dev

RUN docker-php-ext-install pdo pdo_pgsql pgsql \
    && docker-php-ext-enable pdo pdo_pgsql \
    && rm -rf /tmp/*

RUN apk del postgresql-dev

# Customize PHP
ENV PHP_DISMOD=ioncube,mongodb

# Install Opcache
RUN docker-php-ext-install opcache
COPY ./etc/opcache/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Customize Default Packages
RUN apk add nano \
    procps \
    bash \
    curl

# Add Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


####################################
#
#  Scheduler
#
####################################

# Setup Schedule
COPY ./bash/schedule.sh /usr/local/bin/schedule-start
RUN chmod u+x /usr/local/bin/schedule-start

####################################
#
#  Start and Monitor Processes
#
####################################

COPY ./bash/start.sh /usr/local/bin/start
RUN chmod u+x /usr/local/bin/start

CMD ["/usr/local/bin/start"]