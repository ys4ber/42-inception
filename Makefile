NAME = inception
COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = /home/ysaber42/data

all: setup build up

setup:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb

build:
	@docker-compose -f $(COMPOSE_FILE) build

up:
	@docker-compose -f $(COMPOSE_FILE) up -d

down:
	@docker-compose -f $(COMPOSE_FILE) down

stop:
	@docker-compose -f $(COMPOSE_FILE) stop

start:
	@docker-compose -f $(COMPOSE_FILE) start

restart:
	@docker-compose -f $(COMPOSE_FILE) restart

clean: down
	@docker system prune -a --force
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

fclean: clean
	@sudo rm -rf $(DATA_PATH)/wordpress/*
	@sudo rm -rf $(DATA_PATH)/mariadb/*

re: fclean all

ps:
	@docker-compose -f $(COMPOSE_FILE) ps

logs:
	@docker-compose -f $(COMPOSE_FILE) logs

push:
	@git add . && \
	if [ $$? -eq 0 ]; then \
		git commit -m "auto commit $$(date)" && \
		if [ $$? -eq 0 ]; then \
			git push && \
			if [ $$? -eq 0 ]; then \
				echo "\033[0;32mcommit and push success\033[0m"; \
			else \
				echo "\033[0;31mpush failed\033[0m"; \
			fi \
		else \
			echo "\033[0;31mcommit failed\033[0m"; \
		fi \
	else \
		echo "\033[0;31madd failed\033[0m"; \
	fi


check_redis:
	@docker exec wordpress wp redis status --allow-root

.PHONY: all setup build up down stop start restart clean fclean re ps logs