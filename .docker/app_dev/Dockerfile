ARG CI_COMMIT_REF_SLUG=master
ARG CI_SERVER_HOST
ARG CI_PROJECT_PATH
ARG PHP_VER
ARG DOCKER_REGISTRY_PORT

FROM ${CI_SERVER_HOST}${DOCKER_REGISTRY_PORT}/$CI_PROJECT_PATH/php${PHP_VER}-composer:$CI_COMMIT_REF_SLUG AS composer
USER www-data:www-data

WORKDIR /app
COPY --chown=www-data:www-data . /app

RUN --mount=type=cache,uid=33,gid=33,target=/app/.composer composer install --optimize-autoloader

FROM ${CI_SERVER_HOST}${DOCKER_REGISTRY_PORT}/$CI_PROJECT_PATH/php${PHP_VER}-fpm:$CI_COMMIT_REF_SLUG
USER www-data:www-data
COPY --chown=www-data:www-data --from=composer /app /app

WORKDIR /app/public

HEALTHCHECK --interval=30s --timeout=100s CMD bash /app/ping.bash
