#!make
include .env

# HELP
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

gen-pass: ## Generate an encrypt password from prompt
	@clear
	@./tools/system/gen_encrypt_password.sh

build: ## Build images
	@docker compose build
up: ## Start containers stack (dettached)
	@docker compose up -d
down: ## Stop containers stack 
	@docker compose down
destroy: ## Stop containers stack and remove volumes
	@docker compose down -v
ps: ## List all container
	@docker container ps -a

php-app: ## Connect to php-app container
	@docker compose exec php-app bash
php-app-linter: ## Hook for vscode and php linter
	@docker exec -it php-app php $@

mysql: ## Connect to mysql database
	@docker compose exec ${MYSQL_CONTAINER_NAME} mysql --user=${MYSQL_USERNAME} --host=${MYSQL_HOST_NAME} --port=${MYSQL_HOST_PORT} --password ${MYSQL_DATABASE}
mysql-root: ## Connect to mysql database as root
	@docker compose exec ${MYSQL_CONTAINER_NAME} mysql --user=root --host=${MYSQL_HOST_NAME} --port=${MYSQL_HOST_PORT} --password mysql
