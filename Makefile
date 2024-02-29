all:
	@mkdir -p /home/iabkadri/data/wordpress
	@mkdir -p /home/iabkadri/data/db
	@docker compose -f srcs/docker-compose.yml up --build

clean:
	@docker compose -f srcs/docker-compose.yml down

fclean: clean
	@sudo rm -rf /home/iabkadri/data/ 2>/dev/null
	@docker rmi mariadb:iabkadri wordpress:iabkadri nginx:iabkadri 2>/dev/null
	@docker volume rm srcs_db srcs_wordpress 2>/dev/null
	
re: fclean all

.PHONY: all clean fclean re
