install_macos:
	sh ./install.macos.sh

ansible_macos:
	ansible-playbook --ask-become-pass ./ansible.macos.yml

dotfiles_private:
	git clone https://github.com/edadaltocg/dotfiles.private.git

build:
	docker build --progress=plain -t dev-image .

run:
	docker run \
		-it \
		-v $(PWD)/projects:/home/${USER}/projects \
		-v $(PWD)/dotfiles:/home/${USER}/dotfiles \
		-v $(PWD)/dotfiles.private:/home/${USER}/dotfiles.private \
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
	@make dotfiles_private
	@make clean
	@make build
	@make run

compose_up:
	docker compose run dev dev id

subrepo_dotfiles:
	# git subrepo clone <repository> [<subdir>] [-b <branch>] [-f] [-m <msg>] [--file=<msg file>] [-e] [--method <merge|rebase>]
	git subrepo clone https://github.com/edadaltocg/dotfiles \
		dotfiles/ \
		-b master \
		-f

subrepo_new:
	# git subrepo init <subdir> [-r <remote>] [-b <branch>] [--method <merge|rebase>]

subrepo_pull:
	# git subrepo pull <subdir>|--all [-M|-R|-f] [-m <msg>] [--file=<msg file>] [-e] [-b <branch>] [-r <remote>] [-u]

subrepo_push:
	# git subrepo push <subdir>|--all [<branch>] [-m msg] [--file=<msg file>] [-r <remote>] [-b <branch>] [-M|-R] [-u] [-f] [-s] [-N]