.PHONY: install

CI_REGISTRY	?= localhost
IMAGE				?= $(shell pwd | awk -F/ '{print $$NF}')

ifeq (,$(wildcard ./VERSION))
	export VERSION	?= $(shell git show -q --format=%h)
else
	export VERSION	?= $(shell cat ./VERSION)
endif

all: install

install:
	echo $(IMAGE):$(VERSION)
