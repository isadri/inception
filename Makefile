all:
	- @mkdir -p /home/iabkadri/data/wordpress
	- @mkdir -p /home/iabkadri/data/db
	- @docker compose -f srcs/docker-compose.yml up --build

clean:
	- @docker compose -f srcs/docker-compose.yml down

fclean: clean
	- @sudo rm -rf /home/iabkadri/data/ 2>/dev/null
	- @docker system prune -af
	- @docker volume rm srcs_db srcs_wordpress
	
re: fclean all

.PHONY: all clean fclean re
