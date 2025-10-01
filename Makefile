DOCKER_COMPOSE = docker compose -f ./srcs/docker-compose.yml

run:
	$(DOCKER_COMPOSE) up --build

stop:
	$(DOCKER_COMPOSE) down

logs:
	$(DOCKER_COMPOSE) logs -f

remove: stop
	@echo "🧹 Suppression des conteneurs, volumes et images..."
	@docker rm -f $$(docker ps -qa) 2>/dev/null || true
	@docker volume rm -f $$(docker volume ls -q) 2>/dev/null || true
	@docker rmi -f $$(docker images -qa) 2>/dev/null || true

.PHONY: run stop remove logs
