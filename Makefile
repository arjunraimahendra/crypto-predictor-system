# Install all the packages for the project
installpackages:
	uv add pre-commit quixstreams websocket-client pydantic requests loguru

######################################################
## Development
######################################################

# Runs the trades service as a standalone Pyton app (not Dockerized)
dev:
	uv run services/${service}/src/${service}/main.py

# # Builds and pushes the docker image to the given environment
# build-for-dev:
# 	docker build -t ${service}:dev -f docker/${service}.dockerfile .

# # Push the docker image to the docker registry of our kind cluster
# push-for-dev:
# 	kind load docker-image ${service}:dev --name rwml-34fa

# # Deploys the docker image to the kind cluster 
# deploy-for-dev: build push
# 	kubectl delete -f deployments/dev/${service}/${service}.yaml --ignore-not-found=true
# 	kubectl apply -f deployments/dev/${service}/${service}.yaml

# Builds and pushes the docker image to the given environment
build-and-push:
	chmod +x ./scripts/build-and-push-image.sh
	./scripts/build-and-push-image.sh ${image} ${env}

# Deploys a service to the given environment
deploy:
	chmod +x ./scripts/deploy.sh
	./scripts/deploy.sh ${service} ${env}


delete:
	kubectl delete -f deployments/${env}/${service}/${service}.yaml --ignore-not-found=true

lint:
	ruff check . --fix


lint:
	ruff check . --fix
