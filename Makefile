s: setup
setup:
	@docker volume create claude_data || true

u: up
up: setup
	docker compose up -d

b: build
build: setup
	docker compose up -d --build

d: down
down:
	docker compose down

c: connect
connect:
	docker exec -it claude-dev bash

claude:
	@docker exec -it claude-dev claude