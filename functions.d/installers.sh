#!/bin/bash
#
# Installer functions for machine setups
#
# by Offensive Nomad

function install_docker() {
	sudo apt remove docker \
		docker-engine \
		docker.io \
		containerd runc
	sudo apt update
	sudo apt install -y apt-transport-https \
		ca-certificates \
		curl \
		gnupg-agent \
		software-properties-common
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
  sudo apt update
	sudo apt-get install -y \
		docker-ce \
		docker-ce-cli \
		containerd.io
	sudo usermod -aG docker "${USER}"
	docker pull hello-world
	sudo systemctl enable docker
	sudo systemctl start docker
	sudo cp "${HOME}"/.dotfiles/docker.json /etc/docker/daemon.json
	sudo systemctl restart docker
	docker run --rm -it alpine ping -c4 localhost.localdomain
	sed 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub
	sudo update-grub
	sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
	sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
	docker-compose --version
}

