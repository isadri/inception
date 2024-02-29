all:
	@mkdir -p /home/iabkadri/data/wordpress
	@mkdir -p /home/iabkadri/data/db
	@docker compose -f srcs/docker-compose.yml up --build

clean:
	@docker compose -f srcs/docker-compose.yml down

fclean: clean
	@sudo rm -rf /home/iabkadri/data/
	@docker rmi mariadb:iabkadri wordpress:iabkadri nginx:iabkadri
	@docker volume rm srcs_db srcs_wordpress
	
re: fclean all

.PHONY: all clean fclean re
