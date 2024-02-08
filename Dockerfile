FROM ubuntu:latest
ARG USERNAME=dadalto
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
  # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
  && apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
  && chmod 0440 /etc/sudoers.d/$USERNAME

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
# USER root

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get -y install --no-install-recommends apt-utils 2>&1

# Verify git and needed tools are installed
RUN apt-get install --no-install-recommends -y git procps stow

COPY common-debian.sh /tmp/library-scripts/
RUN apt-get update && bash /tmp/library-scripts/common-debian.sh 

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

USER ${USERNAME}
WORKDIR /home/${USERNAME}
ENV USER=${USERNAME}
ENV HOME=/home/${USERNAME}
ENV PATH=${HOME}/.local/bin:${HOME}/.cargo/env:/root/.cargo/env:${PATH}:/root/.local/bin
ADD dotfiles/ dotfiles/
ADD dotfiles.private/ dotfiles.private/
COPY install.ubuntu.sh .
COPY ansible.ubuntu.yml .
COPY requirements.txt .
RUN sudo chown -R ${USERNAME} ${HOME}
RUN sudo rm -rf ${HOME}/.git .zshrc
WORKDIR ${HOME}/dotfiles
RUN stow -v --ignore="Makefile" -t ${HOME} .
WORKDIR ${HOME}/dotfiles.private
RUN stow -v --ignore="Makefile" --ignore=".config" -t ${HOME} .
RUN stow -v -t ${HOME} -d .config/ -S github-copilot
WORKDIR ${HOME}
RUN sudo chown -R ${USERNAME} ${HOME}
RUN bash install.ubuntu.sh

# Clean up
RUN sudo apt-get autoremove -y \
  && sudo apt-get clean -y \
  && sudo rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog \
  LANG=C.UTF-8 \
  LC_ALL=C.UTF-8

CMD ["/bin/zsh"]
