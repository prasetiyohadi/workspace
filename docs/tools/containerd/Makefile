DIR ?= ${HOME}/Downloads
OS_TYPE ?= linux-amd64

# Containerd
CONTAINERD_GIT = https://github.com/containerd/containerd.git
CONTAINERD_RAW = https://raw.githubusercontent.com/containerd/containerd
CONTAINERD_RELEASE = https://github.com/containerd/containerd/releases/download
CONTAINERD_VERSION ?= $(shell ./get-latest.sh ${CONTAINERD_GIT})
CONTAINERD_PKG = containerd-${CONTAINERD_VERSION}-${OS_TYPE}
CONTAINERD_SYSTEMD = ${CONTAINERD_RAW}/v${CONTAINERD_VERSION}/containerd.service
CONTAINERD_URL = ${CONTAINERD_RELEASE}/v${CONTAINERD_VERSION}/${CONTAINERD_PKG}

# Runc
RUNC_GIT = https://github.com/opencontainers/runc.git
RUNC_OSTYPE = amd64
RUNC_PKG = runc
RUNC_RELEASE = https://github.com/opencontainers/runc/releases/download
RUNC_VERSION ?= $(shell ./get-latest.sh ${RUNC_GIT})
RUNC_URL = ${RUNC_RELEASE}/v${RUNC_VERSION}/${RUNC_PKG}

# CNI Plugins
CNI_PLUGINS_GIT = https://github.com/containernetworking/plugins.git
CNI_PLUGINS_RELEASE = https://github.com/containernetworking/plugins/releases/download
CNI_PLUGINS_VERSION ?= $(shell ./get-latest.sh ${CNI_PLUGINS_GIT})
CNI_PLUGINS_PKG = cni-plugins-${OS_TYPE}-v${CNI_PLUGINS_VERSION}
CNI_PLUGINS_URL = ${CNI_PLUGINS_RELEASE}/v${CNI_PLUGINS_VERSION}/${CNI_PLUGINS_PKG}

dir:
	mkdir -p ${DIR}

.PHONY: dir

clean-containerd:
	@echo "# Cleaning containerd..."
	rm -fv ${DIR}/${CONTAINERD_PKG}.tar.gz
	rm -fv ${DIR}/${CONTAINERD_PKG}.tar.gz.sha256sum

clean-runc:
	@echo "# Cleaning runc..."
	rm -fv ${DIR}/${RUNC_PKG}.${RUNC_OSTYPE}
	rm -fv ${DIR}/${RUNC_PKG}.${RUNC_OSTYPE}.asc
	rm -fv ${DIR}/${RUNC_PKG}.sha256sum

clean-cni-plugins:
	@echo "# Cleaning CNI plugins..."
	rm -fv ${DIR}/${CNI_PLUGINS_PKG}.tgz
	rm -fv ${DIR}/${CNI_PLUGINS_PKG}.tgz.sha256

clean: clean-containerd clean-runc clean-cni-plugins

.PHONY: clean clean-containerd clean-runc clean-cni-plugins

download-containerd: dir
	@echo "# Downloading containerd..."
	wget -P ${DIR} ${CONTAINERD_URL}.tar.gz
	wget -P ${DIR} ${CONTAINERD_URL}.tar.gz.sha256sum

download-runc: dir
	@echo "# Downloading runc..."
	wget -P ${DIR} ${RUNC_URL}.${RUNC_OSTYPE}
	wget -P ${DIR} ${RUNC_URL}.${RUNC_OSTYPE}.asc
	wget -P ${DIR} ${RUNC_URL}.sha256sum
	@echo "# Downloading CNI plugins..."

download-cni-plugins: dir
	wget -P ${DIR} ${CNI_PLUGINS_URL}.tgz
	wget -P ${DIR} ${CNI_PLUGINS_URL}.tgz.sha256

download: download-containerd download-runc download-cni-plugins

.PHONY: download download-containerd download-runc download-cni-plugins

checksum-containerd:
	@echo "# Checking containerd..."
	@echo $$(awk '{print $$1}' ${DIR}/${CONTAINERD_PKG}.tar.gz.sha256sum) ${DIR}/${CONTAINERD_PKG}.tar.gz | sha256sum --check

checksum-runc:
	@echo "# Checking runc..."
	@echo $$(grep ${RUNC_OSTYPE} ${DIR}/${RUNC_PKG}.sha256sum | awk '{print $$1}') ${DIR}/${RUNC_PKG}.${RUNC_OSTYPE} | sha256sum --check

checksum-cni-plugins:
	@echo "# Checking CNI plugins..."
	@echo $$(awk '{print $$1}' ${DIR}/${CNI_PLUGINS_PKG}.tgz.sha256) ${DIR}/${CNI_PLUGINS_PKG}.tgz | sha256sum --check

checksum: checksum-containerd checksum-runc checksum-cni-plugins

.PHONY: checksum checksum-containerd checksum-runc checksum-cni-plugins

install-containerd:
	@echo "# Installing containerd..."
	sudo tar Cxzvf /usr/local ${DIR}/${CONTAINERD_PKG}.tar.gz

install-runc:
	@echo "# Installing runc..."
	sudo install -m 755 ${DIR}/${RUNC_PKG}.${RUNC_OSTYPE} /usr/local/sbin/${RUNC_PKG}

install-cni-plugins:
	@echo "# Installing CNI plugins..."
	sudo mkdir -p /opt/cni/bin
	sudo tar Cxzvf /opt/cni/bin ${DIR}/${CNI_PLUGINS_PKG}.tgz

install: install-containerd install-runc install-cni-plugins

.PHONY: install install-containerd install-runc install-cni-plugins

systemd:
	sudo mkdir -p /usr/local/lib/systemd/system
	sudo curl -o /usr/local/lib/systemd/system/containerd.service ${CONTAINERD_SYSTEMD}
	sudo systemctl daemon-reload
	sudo systemctl status containerd
	sudo systemctl enable --now containerd

rootless:
	sudo chmod 0755 /etc/cni

.PHONY: systemd rootless
