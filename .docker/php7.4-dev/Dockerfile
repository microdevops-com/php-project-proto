ARG CI_COMMIT_REF_SLUG=master
ARG CI_SERVER_HOST
ARG CI_PROJECT_PATH
ARG PHP_VER
ARG DOCKER_REGISTRY_PORT

FROM ${CI_SERVER_HOST}${DOCKER_REGISTRY_PORT}/$CI_PROJECT_PATH/php${PHP_VER}-composer:$CI_COMMIT_REF_SLUG

RUN apt-get update
RUN apt-get install -y telnet iputils-ping

RUN pecl install xdebug-2.9.6
RUN docker-php-ext-enable xdebug

WORKDIR /app
