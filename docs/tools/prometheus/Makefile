.PHONY: build clean deploy volume

NAME	?= prometheus

PROMETHEUS_NETWORK	?= dev
PROMETHEUS_PORT			?= 9090

build:
	docker build . \
		-t pras/prometheus:latest

clean:
	docker container stop $(NAME)
	docker container rm $(NAME)

deploy: volume
	docker container run \
		--detach \
		--name $(NAME) \
		--network $(PROMETHEUS_NETWORK) \
		--publish $(PROMETHEUS_PORT):9090 \
		--volume prometheus-data:/prometheus \
		pras/prometheus:latest

volume:
	docker volume create prometheus-data
