# Simple helper Makefile for managing the FrankenPHP + MariaDB stack

COMPOSE=docker compose -f compose.yml --env-file .env

.PHONY: up start stop down restart logs build clean install-wp help

up: ## Build (if needed) and start the stack in detached mode
	$(COMPOSE) up -d

start: ## Start existing containers
	$(COMPOSE) start

stop: ## Stop running containers without removing them
	$(COMPOSE) stop

down: ## Stop and remove containers, but keep volumes/images
	$(COMPOSE) down

restart: ## Restart containers
	$(COMPOSE) restart

logs: ## Follow container logs
	$(COMPOSE) logs -f

build: ## Build/rebuild images
	$(COMPOSE) build

clean: ## Remove containers, images, volumes and orphans – full reset
	@echo "💥 removing docker images"
	$(COMPOSE) down --rmi all -v --remove-orphans

install-wp: ## Download and extract latest WordPress into ./wordpress
	@echo "Downloading WordPress ..."
	@curl -L -o /tmp/wordpress.zip https://wordpress.org/latest.zip
	@unzip -q /tmp/wordpress.zip
	@rm /tmp/wordpress.zip
	@rm -rf ./wordpress/wp-content
	@echo "WordPress installed in ./wordpress"
	@echo "Downloading adminer.php"
	@curl -L -o adminer.php https://github.com/vrana/adminer/releases/download/v5.3.0/adminer-5.3.0.php
	@echo "Done ✅"

help: ## Display this help
	@echo "--HELP--"
	@grep -E '^[a-zA-Z_-]+:\s+##' Makefile | awk 'BEGIN {FS = ":"}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$3}'
	@echo "--END--"
