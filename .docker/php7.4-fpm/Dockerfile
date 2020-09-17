ARG PHP_VER

FROM php:${PHP_VER}-fpm

RUN apt-get -y update

# php settings
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
ADD conf.ini /usr/local/etc/php/conf.d/
RUN chmod +r /usr/local/etc/php/conf.d/conf.ini
COPY www.conf /usr/local/etc/php-fpm.d/www.conf

# curl for cmd
RUN apt-get install -y curl

# php extensions

# mcrypt
RUN apt-get install -y libmcrypt-dev
RUN pecl install mcrypt-1.0.3
RUN docker-php-ext-enable mcrypt

# bcmath
RUN docker-php-ext-install bcmath
RUN docker-php-ext-enable bcmath

# sockets
RUN docker-php-ext-install sockets
RUN docker-php-ext-enable sockets

# intl
RUN apt-get install -y libicu-dev
RUN docker-php-ext-install intl
RUN docker-php-ext-enable intl

# opcache
RUN docker-php-ext-install opcache
RUN docker-php-ext-enable opcache

# amqp
RUN apt-get install -y librabbitmq-dev
RUN pecl install amqp
RUN docker-php-ext-enable amqp

# redis
RUN pecl install redis
RUN docker-php-ext-enable redis

# zip
RUN apt-get install -y libzip-dev
RUN docker-php-ext-install zip
RUN docker-php-ext-enable zip

# pdo_mysql
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-enable pdo_mysql

# gd
RUN apt-get install -y libpng-dev libjpeg-dev libjpeg62-turbo-dev
RUN docker-php-ext-configure gd --with-jpeg=/usr/include/
RUN docker-php-ext-install gd

# soap
RUN apt-get install -y libxml2-dev
RUN docker-php-ext-install soap
RUN docker-php-ext-enable soap

## mssql
#ENV ACCEPT_EULA=Y
#RUN apt-get install -y gnupg
#RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
#RUN apt-get install -y --no-install-recommends locales apt-transport-https
#RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen && apt-get update && apt-get -y --no-install-recommends install unixodbc-dev msodbcsql17
#RUN apt-get install -y --no-install-recommends openssl
#RUN sed -i -E 's/(CipherString\s*=\s*DEFAULT@SECLEVEL=)2/\11/' /etc/ssl/openssl.cnf
#RUN apt-get -y install unixodbc-dev
#RUN pecl install sqlsrv pdo_sqlsrv 
#RUN docker-php-ext-enable sqlsrv pdo_sqlsrv
