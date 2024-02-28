all:
	@docker compose -f srcs/docker-compose.yml up --build

clean:
	@docker compose -f srcs/docker-compose.yml down

fclean: clean
	@docker system prune -af
	@docker volume rm $(docker volume ls -q)
	
re: fclean all

.PHONY: all clean fclean re
