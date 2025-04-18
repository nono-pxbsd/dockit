# Makefile - Outils pour Dockit (PrestaShop)

PROJECT_NAME ?= $(shell basename $(CURDIR))
ENV_FILE := .env

include .env

start:
	@echo "🚀 Démarrage de l'environnement $(PROJECT_NAME)..."
	docker compose up -d

stop:
	@echo "🛑 Arrêt de l'environnement $(PROJECT_NAME)..."
	docker compose down

restart: stop start

build:
	@echo "🔧 Reconstruction des images Docker..."
	docker compose build

reset:
	@echo "♻️  Réinitialisation complète (volumes + images)..."
	docker compose down -v && docker compose build && docker compose up -d

logs:
	@echo "📋 Logs en direct (web, PHP, SQL...)"
	docker compose logs -f

shell-php:
	docker compose exec php bash

shell-db:
	docker compose exec db bash

composer-install:
	docker run --rm -v $(PWD)/prestashop:/app -w /app composer:latest install

composer-update:
	docker run --rm -v $(PWD)/prestashop:/app -w /app composer:latest update

composer-require:
	@read -p "Nom du package à installer : " pkg; \
	docker run --rm -v $(PWD)/prestashop:/app -w /app composer:latest require $$pkg

composer-dump:
	docker run --rm -v $(PWD)/prestashop:/app -w /app composer:latest dump-autoload

# Activer les extensions PHP
enable-php-extensions:
    docker exec -it php-container enable-php-extensions

# Activer Blackfire
enable-blackfire:
    docker exec -it php-container bash -c "echo 'extension=blackfire.so' > /usr/local/etc/php/conf.d/blackfire.ini && php -m | grep blackfire"

# Désactiver Blackfire
disable-blackfire:
    docker exec -it php-container bash -c "rm -f /usr/local/etc/php/conf.d/blackfire.ini && php -m | grep blackfire || echo 'Blackfire désactivé'"

.PHONY: start stop restart build reset logs shell-php shell-db composer-*
