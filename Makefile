install_macos:
	sh ./install.macos.sh

ansible_macos:
	ansible-playbook --ask-become-pass ./ansible.macos.yml

clone:
	git clone https://github.com/edadaltocg/dotfiles.private.git

build:
	docker build --progress=plain -t dev-image .

run:
	docker run \
		-it \
		-v $(PWD)/v/home/dadalto/.zsh_history:/home/dadalto/.zsh_history \
		-v $(PWD)/projects:/home/dadalto/projects \
		-v $(PWD)/dotfiles:/home/dadalto/dotfiles \
		-v $(PWD)/dotfiles.private:/home/dadalto/dotfiles.private \
		--name dev \
		dev-image

start:
	docker start dev

exec:
	docker exec -it dev /bin/zsh

clean:
	docker container stop dev
	docker container rm dev

all:
	@make clone
	@make clean
	@make build 
	@make run

compose_up:
	docker compose run dev dev id
