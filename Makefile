DOCKER_COMPOSE = ./srcs/docker-compose.yml
DOCKER_COMPOSE_UP = docker compose -f $(DOCKER_COMPOSE) up --build
DOCKER_COMPOSE_DOWN = docker compose -f $(DOCKER_COMPOSE) down

all:
	$(DOCKER_COMPOSE_UP)

clean:
	$(DOCKER_COMPOSE_DOWN)

fclean: clean
	docker system prune -af
	docker volume prune -af

re: fclean all