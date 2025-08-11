# Install all the packages for the project
installpackages:
	uv add pre-commit quixstreams websocket-client pydantic requests loguru

# Runs the trades service as a standalone Pyton app (not Dockerized)
dev:
	uv run services/trades/src/trades/main.py

# Builds and pushes the docker image to the given environment
build:
	docker build -t trades:dev -f docker/trades.dockerfile .

push:
	kind load docker-image trades:dev --name rwml-34fa

deploy: build push
# 	kubectl delete -f deployments/dev/trades/trades.yaml
	kubectl apply -f deployments/dev/trades/trades.yaml

lint:
	ruff check . --fix
