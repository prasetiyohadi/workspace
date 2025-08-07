DIR ?= ${HOME}/Downloads
OS_TYPE ?= $(shell uname -m)

# Slirp4netns
SLIRP4NETNS_GIT = https://github.com/rootless-containers/slirp4netns.git
SLIRP4NETNS_RELEASE = https://github.com/rootless-containers/slirp4netns/releases/download
SLIRP4NETNS_VERSION ?= $(shell ./get-latest.sh ${SLIRP4NETNS_GIT})
SLIRP4NETNS_PKG = slirp4netns-${OS_TYPE}
SLIRP4NETNS_URL = ${SLIRP4NETNS_RELEASE}/v${SLIRP4NETNS_VERSION}

dir:
	mkdir -p ${DIR}

clean:
	@echo "# Cleaning slirp4netns..."
	rm -fv ${DIR}/${SLIRP4NETNS_PKG}
	rm -fv ${DIR}/${SLIRP4NETNS_PKG}.SHA256SUMS
	rm -fv ${DIR}/${SLIRP4NETNS_PKG}.SHA256SUMS.asc

download: dir
	@echo "# Downloading slirp4netns..."
	wget -P ${DIR} ${SLIRP4NETNS_URL}/${SLIRP4NETNS_PKG}
	wget -O ${DIR}/${SLIRP4NETNS_PKG}.SHA256SUMS ${SLIRP4NETNS_URL}/SHA256SUMS
	wget -O ${DIR}/${SLIRP4NETNS_PKG}.SHA256SUMS.asc ${SLIRP4NETNS_URL}/SHA256SUMS.asc

checksum:
	@echo "# Checking slirp4netns..."
	@echo $$(grep ${OS_TYPE} ${DIR}/${SLIRP4NETNS_PKG}.SHA256SUMS | awk '{print $$1}') ${DIR}/${SLIRP4NETNS_PKG} | sha256sum --check

install:
	@echo "# Installing slirp4netns..."
	mkdir -p ${HOME}/.local/bin
	install -m 755 ${DIR}/${SLIRP4NETNS_PKG} ${HOME}/.local/bin/slirp4netns
	chmod +x ${HOME}/.local/bin/slirp4netns

.PHONY: dir clean download checksum install
