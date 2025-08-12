# Install all the packages for the project
installpackages:
	uv add pre-commit quixstreams websocket-client pydantic requests loguru

# Runs the trades service as a standalone Pyton app (not Dockerized)
dev:
	uv run services/${service}/src/${service}/main.py

# Builds and pushes the docker image to the given environment
build:
	docker build -t ${service}:dev -f docker/${service}.dockerfile .

push:
	kind load docker-image ${service}:dev --name rwml-34fa

deploy: build push
	kubectl delete -f deployments/dev/${service}/${service}.yaml --ignore-not-found=true
	kubectl apply -f deployments/dev/${service}/${service}.yaml

lint:
	ruff check . --fix
