#! /bin/bash

#get updates
sudo dnf update -y &&
sudo dnf upgrade -y* &&
sudo dnf install epel-release -y

#install ntfs-3g
sudo dnf install ntfs-3g -y

#update git
sudo dnf -y remove git
sudo dnf -y remove git-*
sudo dnf install gettext-devel openssl-devel perl-CPAN perl-devel zlib-devel curl-devel expat-devel gcc autoconf -y
mkdir ~/git
cd ~/git
sudo curl -o git.tar.gz https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.35.3.tar.gz
sudo make prefix=/usr/local all
sudo make prefix=/usr/local install

#install Terraform
sudo yum install yum-utils -y &&
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo &&
sudo dnf install terraform -y

#install NginX
sudo dnf install nginx -y

#install HTOP and Glances
sudo dnf install htop glances -y

#install Visual Studio Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc &&

cat > /etc/yum.repos.d/vscode.repo << EOF
[vscode]
name=packages.microsoft.com
baseurl=https://packages.microsoft.com/yumrepos/vscode/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

sudo dnf install code -y

#install Azure-CLI
cat > /etc/yum.repos.d/azure-cli.repo << EOF
[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

sudo dnf install azure-cli -y

#install AWS-CLI
mkdir ~/awscli
cd ~/awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&
unzip awscliv2.zip
sudo ./aws/install -y


#install ShellCheck
mkdir ~/shellcheck
cd ~/shellcheck
curl "https://github.com/koalaman/shellcheck/releases/download/v0.8.0/shellcheck-v0.8.0.linux.x86_64.tar.xz" -o "shellcheck.tar.xz"
sudo tar -C /usr/local/bin/ -xf shellcheck-v0.8.0.linux.x86_64.tar.xz --no-anchored 'shellcheck' --strip=1

#install Docker

curl -fsSL https://get.docker.com -o get-docker.sh &&
sudo sh get-docker.sh

#install Node and NPM
sudo dnf install nodejs -y &&
sudo yum install npm -y


#install Resume-cli

npm install -g resume-cli --unsafe-perm=true


#configure firewalld
sudo firewall-cmd --zone=public --add-port=4000/tcp &&
sudo firewall-cmd --zone=public --add-service=http &&
sudo firewall-cmd --zone=public --add-service=https &&
sudo firewall-cmd --zone=public --add-service=ssh

sudo firewall-cmd --permanent --zone=public --add-port=4000/tcp &&
sudo firewall-cmd --permanent --zone=public --add-service=http &&
sudo firewall-cmd --permanent --zone=public --add-service=https &&
sudo firewall-cmd --permanent --zone=public --add-service=ssh


sudo firewall-cmd --reload


mkdir /home/"$(whoami)"/DevOps &&
sudo mkdir /var/www/nthsky.me &&
cd /home/"$(whoami)"/DevOps &&
git clone https://github.com/nthskyradiated/NthSkySpace.git

sudo cp -r ./NthSkySpace/ /var/www/nthsky.me




