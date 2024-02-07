install_macos:
	sh ./install.macos.sh

ansible_macos:
	ansible-playbook --ask-become-pass ./ansible.macos.yml

.PHONY clone:
	git clone https://github.com/edadaltocg/dotfiles.git

build:
	docker build -t myubuntu .

dev:
	docker run \
		-it \
		-v $(PWD)/myubuntuv/root/.zsh_history:/root/.zsh_history \
		--name dev \
		myubuntu

dev_private:
	docker run \
		--name devp \
		-v $(pwd)/dotfiles.private:/root/dotfiles.private:ro \
		-v myubuntuv:/ \
		-it myubuntu

exec:
	docker exec -it dev /bin/zsh

clean:
	docker container stop dev
	docker container rm dev

all:
	@make clone
	@make clean
	@make build 
	@make dev
 
