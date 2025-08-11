# Runs the trades service as a standalone Pyton app (not Dockerized)
dev:
	uv run services/trades/src/trades/main.py

# Builds and pushes the docker image to the given environment
build:
	docker build -t trades:dev -f docker/trades.dockerfile .


installpackages:
	uv add pre-commit quixstreams websocket-client pydantic requests loguru