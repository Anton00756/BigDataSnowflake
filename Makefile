up: down
	@docker-compose -f=docker-compose.yaml -p snowflake up -d

down:
	@docker-compose -p snowflake down