include .env
export

export PGPASSWORD ?= $(DB_PASSWORD)
export DB_ENTRY ?= psql -h $(DB_HOST) -p $(DB_PORT) -U $(DB_USER)

app-start: wait-for-db wait-for-sqs
	@RUBYOPT='-W:no-deprecated' bundle exec shoryuken -C ./config/shoryuken.yml

app-console:
	@RUBYOPT='-W:no-deprecated' bundle exec bin/console

wait-for-db: wait-for-postgres
	@while ! $(DB_ENTRY) ${DB_NAME} -c "select 1"; do echo postgresql starting ..; sleep 1; done;

wait-for-postgres:
	@while ! nc -zv ${DB_HOST} ${DB_PORT}; do echo waiting for postgresql ..; sleep 1; done;

wait-for-sqs:
	@while ! nc -zv ${SQS_HOST} ${SQS_PORT}; do echo waiting for sqs ..; sleep 1; done;

create-db:
	@$(DB_ENTRY) -c "create database ${DB_NAME}";


