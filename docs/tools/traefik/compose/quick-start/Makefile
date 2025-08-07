.PHONY: deploy

clean:
	docker-compose down

deploy-proxy:
	docker-compose up -d reverse-proxy

deploy-whoami:
	docker-compose up -d whoami

scale-whoami:
	docker-compose up -d --scale whoami=2

test:
	curl -H Host:whoami.docker.localhost http://127.0.0.1
