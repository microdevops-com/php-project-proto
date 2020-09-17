include .env
export

export UID=$(shell ./uid.sh)
sources = bin/console config src
version = $(shell git describe --tags --dirty --always)
build_name = application-$(version)
# use the rest as arguments for "run"
RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
# ...and turn them into do-nothing targets
#$(eval $(RUN_ARGS):;@:)

.PHONY: fix-permission
fix-permission: ## fix permission for docker env
	sudo chown -R $(shell whoami):$(shell whoami) *
	sudo chown -R $(shell whoami):$(shell whoami) .docker/*
	sudo chmod +x ./bin/console

.PHONY: install
install: erase build up db ## clean current environment, recreate dependencies and spin up again

.PHONY: up
up: ## spin up environment
	docker-compose up -d

.PHONY: stop
stop: ## stop environment
	docker-compose stop

.PHONY: erase
erase: ## stop and delete containers, clean volumes.
	docker-compose stop
	docker-compose rm -v -f

.PHONY: build
build: ## build environment and initialize composer and project dependencies
	docker build .docker/php$(PHP_VER)-fpm/ -t docker.local/$(CI_PROJECT_PATH)/php$(PHP_VER)-fpm:master --build-arg CI_COMMIT_REF_SLUG=$(CI_COMMIT_REF_SLUG) --build-arg CI_SERVER_HOST=$(CI_SERVER_HOST) --build-arg CI_PROJECT_PATH=$(CI_PROJECT_PATH) --build-arg PHP_VER=$(PHP_VER)
	docker build .docker/php$(PHP_VER)-composer/ -t docker.local/$(CI_PROJECT_PATH)/php$(PHP_VER)-composer:master ${DOCKER_BUILD_ARGS} --build-arg CI_COMMIT_REF_SLUG=$(CI_COMMIT_REF_SLUG) --build-arg CI_SERVER_HOST=$(CI_SERVER_HOST) --build-arg CI_PROJECT_PATH=$(CI_PROJECT_PATH) --build-arg PHP_VER=$(PHP_VER)
	docker build .docker/php$(PHP_VER)-dev/ -t docker.local/$(CI_PROJECT_PATH)/php$(PHP_VER)-dev:master ${DOCKER_BUILD_ARGS} --build-arg CI_COMMIT_REF_SLUG=$(CI_COMMIT_REF_SLUG) --build-arg CI_SERVER_HOST=$(CI_SERVER_HOST) --build-arg CI_PROJECT_PATH=$(CI_PROJECT_PATH) --build-arg PHP_VER=$(PHP_VER)
	docker-compose build --pull
	make composer-install

.PHONY: composer-install
composer-install: ## Install project dependencies
	docker-compose run --rm --no-deps php sh -lc 'composer -vvv install'

.PHONY: composer-update
composer-update: ## Update project dependencies
	docker-compose run --rm --no-deps php sh -lc 'composer -vvv update'

.PHONY: composer-outdated
composer-outdated: ## Show outdated project dependencies
	docker-compose run --rm --no-deps php sh -lc 'composer -vvv outdated'

.PHONY: composer-validate
composer-validate: ## Validate composer config
	docker-compose run --rm --no-deps php sh -lc 'composer -vvv validate --no-check-publish'

.PHONY: composer
composer: ## Execute composer command
	docker-compose run --rm --no-deps php sh -lc "composer -vvv $(RUN_ARGS)"

.PHONY: console
console: ## execute symfony console command
	docker-compose run --rm php sh -lc "./bin/console $(RUN_ARGS)"

.PHONY: phpunit
phpunit: ## execute project unit tests
	docker-compose run --rm php sh -lc  "./bin/phpunit $(conf)"

.PHONY: lint
lint: ## checks syntax of PHP files
	docker-compose run --rm --no-deps php sh -lc './bin/console lint:yaml config'

.PHONY: db
db: ## recreate database
	docker-compose run --rm php sh -lc './bin/console d:d:d --force'
	docker-compose run --rm php sh -lc './bin/console d:d:c'
	docker-compose run --rm php sh -lc './bin/console d:m:m -n'

.PHONY: schema-validate
schema-validate: ## validate database schema
	docker-compose run --rm php sh -lc './bin/console d:s:v'

.PHONY: migration-generate
migration-generate: ## generate new database migration
	docker-compose run --rm php sh -lc './bin/console d:m:g'

.PHONY: migration-migrate
migration-migrate: ## run database migration
	docker-compose run --rm php sh -lc './bin/console d:m:m'

.PHONY: logs
logs: ## look for service logs
	docker-compose logs -f $(RUN_ARGS)

.PHONY: help
help: ## Display this help message
	    @cat $(MAKEFILE_LIST) | grep -e "^[a-zA-Z_\-]*: *.*## *" | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: php-shell
php-shell: ## PHP shell
	docker-compose run --rm php sh -l

.PHONY: php-test
php-test: ## PHP shell without deps
	docker-compose run --rm --no-deps php sh -l

.PHONY: clean
clean: ## Clear build vendor report folders
	rm -rf build/ vendor/ var/

unit-tests: ## Run unit-tests suite
	docker-compose run --rm --no-deps php sh -lc 'bin/phpunit --testsuite unit-tests'

integration-tests: ## Run integration-tests suite
	docker-compose run --rm --no-deps php sh -lc 'bin/phpunit --testsuite integration-tests'

.PHONY: test lint unit-tests integration-tests composer-validate
test: install lint unit-tests integration-tests composer-validate stop ## Run all test suites
