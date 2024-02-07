FROM arm64v8/ubuntu:latest
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get -y install --no-install-recommends apt-utils 2>&1

# Verify git and needed tools are installed
RUN apt-get install --no-install-recommends -y git procps

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
RUN /root/.local/bin/ansible-playbook -v ansible.ubuntu.yml
ADD dotfiles/ .
WORKDIR /home
CMD ["/bin/zsh"]
