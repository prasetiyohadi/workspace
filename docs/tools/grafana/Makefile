.PHONY: build clean deploy volume

NAME	?= grafana

GRAFANA_NETWORK	?= dev
GRAFANA_PORT		?= 3000

build:
	docker build . \
		--build-arg "GRAFANA_VERSION=latest" \
		--build-arg "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
		-t pras/grafana:latest

clean:
	docker container stop $(NAME)
	docker container rm $(NAME)

deploy: volume
	docker container run \
		--detach \
		--env "GF_METRICS_ENABLED=true" \
		--name $(NAME) \
		--network $(GRAFANA_NETWORK) \
		--publish $(GRAFANA_PORT):3000 \
		--volume grafana-data:/var/lib/grafana \
		pras/grafana:latest

volume:
	docker volume create grafana-data
