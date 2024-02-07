FROM arm64v8/ubuntu:latest
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get -y install --no-install-recommends apt-utils 2>&1

# Verify git and needed tools are installed
RUN apt-get install --no-install-recommends -y git procps

# COPY common-debian.sh /tmp/library-scripts/
# RUN apt-get update && bash /tmp/library-scripts/common-debian.sh 

ENV GOROOT=/usr/local/go \
  GOPATH=/go
ENV PATH=${GOPATH}/bin:${GOROOT}/bin:${PATH}
COPY go-debian.sh /tmp/library-scripts/
RUN apt-get update && bash /tmp/library-scripts/go-debian.sh "latest" "${GOROOT}" "${GOPATH}"

ARG PYTHON_PATH=/usr/local/python
ENV PIPX_HOME=/usr/local/py-utils \
  PIPX_BIN_DIR=/usr/local/py-utils/bin
ENV PATH=${PYTHON_PATH}/bin:${PATH}:${PIPX_BIN_DIR}
COPY python-debian.sh /tmp/library-scripts/
RUN apt-get update && bash /tmp/library-scripts/python-debian.sh "3.10.12" "${PYTHON_PATH}" "${PIPX_HOME}"

ENV CARGO_HOME=/usr/local/cargo \
  RUSTUP_HOME=/usr/local/rustup
ENV PATH=${CARGO_HOME}/bin:${PATH}
COPY rust-debian.sh /tmp/library-scripts/
RUN apt-get update && bash /tmp/library-scripts/rust-debian.sh "${CARGO_HOME}" "${RUSTUP_HOME}"

# Clean up
RUN apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8

WORKDIR /root
COPY install.ubuntu.sh .
RUN sh install.ubuntu.sh
COPY ansible.ubuntu.yml .
RUN /root/.local/bin/ansible-playbook -vvv ansible.ubuntu.yml
ADD dotfiles/ .
WORKDIR /home
CMD ["/bin/zsh"]
