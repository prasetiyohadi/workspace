DIR ?= ${HOME}/Downloads
OS_TYPE ?= linux-amd64

# Nerdctl
NERDCTL_GIT = https://github.com/containerd/nerdctl.git
NERDCTL_RELEASE = https://github.com/containerd/nerdctl/releases/download
NERDCTL_VERSION ?= $(shell ./get-latest.sh ${NERDCTL_GIT})
NERDCTL_PKG = nerdctl-${NERDCTL_VERSION}-${OS_TYPE}
NERDCTL_PKG_FULL = nerdctl-full-${NERDCTL_VERSION}-${OS_TYPE}
NERDCTL_URL = ${NERDCTL_RELEASE}/v${NERDCTL_VERSION}

dir:
	mkdir -p ${DIR}

clean:
	@echo "# Cleaning nerdctl..."
	rm -fv ${DIR}/${NERDCTL_PKG}.tar.gz
	rm -fv ${DIR}/${NERDCTL_PKG}.SHA256SUMS
	rm -fv ${DIR}/${NERDCTL_PKG}.SHA256SUMS.asc

clean-full:
	@echo "# Cleaning nerdctl full package..."
	rm -fv ${DIR}/${NERDCTL_PKG_FULL}.tar.gz

download: dir
	@echo "# Downloading nerdctl..."
	wget -P ${DIR} ${NERDCTL_URL}/${NERDCTL_PKG}.tar.gz
	wget -O ${DIR}/${NERDCTL_PKG}.SHA256SUMS ${NERDCTL_URL}/SHA256SUMS
	wget -O ${DIR}/${NERDCTL_PKG}.SHA256SUMS.asc ${NERDCTL_URL}/SHA256SUMS.asc

download-full: dir
	@echo "# Downloading nerdctl full package..."
	wget -P ${DIR} ${NERDCTL_URL}/${NERDCTL_PKG_FULL}.tar.gz

checksum:
	@echo "# Checking nerdctl..."
	@echo $$(grep nerdctl-${NERDCTL_VERSION}-${OS_TYPE} ${DIR}/${NERDCTL_PKG}.SHA256SUMS | awk '{print $$1}') ${DIR}/${NERDCTL_PKG}.tar.gz | sha256sum --check

checksum-full:
	@echo "# Checking nerdctl full package..."
	@echo $$(grep full-${NERDCTL_VERSION}-${OS_TYPE} ${DIR}/${NERDCTL_PKG}.SHA256SUMS | awk '{print $$1}') ${DIR}/${NERDCTL_PKG}.tar.gz | sha256sum --check

install:
	@echo "# Installing nerdctl..."
	mkdir -p ${HOME}/.local/bin
	tar Cxzvvf ${HOME}/.local/bin ${DIR}/${NERDCTL_PKG}.tar.gz

install-full:
	@echo "# Installing nerdctl full package..."
	mkdir -p ${HOME}/.local
	tar Cxzvvf ${HOME}/.local ${DIR}/${NERDCTL_PKG_FULL}.tar.gz

.PHONY: dir clean clean-full download download-full checksum checksum-full install install-full
