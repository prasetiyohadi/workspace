DIR ?= ${HOME}/Downloads
OS_TYPE ?= $(shell uname -m)

# Rootlesskit
ROOTLESSKIT_GIT = https://github.com/rootless-containers/rootlesskit.git
ROOTLESSKIT_RELEASE = https://github.com/rootless-containers/rootlesskit/releases/download
ROOTLESSKIT_VERSION ?= $(shell ./get-latest.sh ${ROOTLESSKIT_GIT})
ROOTLESSKIT_PKG = rootlesskit-${OS_TYPE}
ROOTLESSKIT_URL = ${ROOTLESSKIT_RELEASE}/v${ROOTLESSKIT_VERSION}

dir:
	mkdir -p ${DIR}

clean:
	@echo "# Cleaning rootlesskit..."
	rm -fv ${DIR}/${ROOTLESSKIT_PKG}.tar.gz
	rm -fv ${DIR}/${ROOTLESSKIT_PKG}.SHA256SUMS
	rm -fv ${DIR}/${ROOTLESSKIT_PKG}.SHA256SUMS.asc

download: dir
	@echo "# Downloading rootlesskit..."
	wget -P ${DIR} ${ROOTLESSKIT_URL}/${ROOTLESSKIT_PKG}.tar.gz
	wget -O ${DIR}/${ROOTLESSKIT_PKG}.SHA256SUMS ${ROOTLESSKIT_URL}/SHA256SUMS
	wget -O ${DIR}/${ROOTLESSKIT_PKG}.SHA256SUMS.asc ${ROOTLESSKIT_URL}/SHA256SUMS.asc

checksum:
	@echo "# Checking rootlesskit..."
	@echo $$(grep ${OS_TYPE} ${DIR}/${ROOTLESSKIT_PKG}.SHA256SUMS | awk '{print $$1}') ${DIR}/${ROOTLESSKIT_PKG}.tar.gz | sha256sum --check

install:
	@echo "# Installing rootlesskit..."
	mkdir -p ${HOME}/.local/bin
	tar Cxzvf ${HOME}/.local/bin ${DIR}/${ROOTLESSKIT_PKG}.tar.gz

.PHONY: dir clean download checksum install
