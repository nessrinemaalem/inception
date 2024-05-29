all: 
	mkdir -p /home/imaalem/data/mariadb
	mkdir -p /home/imaalem/data/wordpress
	docker-compose -f ./srcs/docker-compose.yml build
	docker-compose -f ./srcs/docker-compose.yml up -d

logs:
	docker logs wordpress
	docker logs mariadb
	docker logs nginx

clean:
	docker-compose -f ./srcs/docker-compose.yml down 

fclean: clean
	docker-compose -f ./srcs/docker-compose.yml down
	@sudo docker system prune -af
	@sudo rm -rf /home/imaalem/data/mariadb/*
	@sudo rm -rf /home/imaalem/data/wordpress/*

re: fclean all

.Phony: all logs clean fclean re
