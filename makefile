console: build
	@docker-compose run app make app-console

build:
	@docker-compose build

start: build
	@docker-compose up

stop:
	@docker-compose down --remove-orphans

create-db:
	@docker-compose exec app make create-db
