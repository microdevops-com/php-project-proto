ARG CI_COMMIT_REF_SLUG=master
ARG CI_SERVER_HOST
ARG CI_PROJECT_PATH
ARG PHP_VER
ARG DOCKER_REGISTRY_PORT

FROM ${CI_SERVER_HOST}${DOCKER_REGISTRY_PORT}/$CI_PROJECT_PATH/php${PHP_VER}-composer:$CI_COMMIT_REF_SLUG

RUN apt-get update
RUN apt-get install -y telnet iputils-ping

RUN pecl install xdebug-3.1.2
RUN docker-php-ext-enable xdebug

ARG USER_ID=33
ARG GROUP_ID=33
RUN groupadd --force --gid ${GROUP_ID} app && useradd --non-unique --uid ${USER_ID} --gid ${GROUP_ID} --home /app app
RUN sed -i 's/user.*/user = app/g' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/group.*/group = app/g' /usr/local/etc/php-fpm.d/www.conf
USER app:app
WORKDIR /app
