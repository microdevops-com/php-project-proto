# php-project-proto
Prototype for PHP Project with GitLab Pipeline, docker-compose.yml, docker images etc.
Ready to use for local development on Linux, Mac, Windows and remote deploy via GitLab.

# Local Development

## Windows

### Docs and Links
- https://docs.microsoft.com/en-us/windows/wsl/install-win10
- https://docs.docker.com/docker-for-windows/wsl/
- https://docs.microsoft.com/en-us/windows/wsl/wsl-config
- https://blog.jetbrains.com/phpstorm/2020/06/phpstorm-2020-1-2-is-released/

### Docker Setup
[Check Windows 10 version requirement](https://docs.microsoft.com/en-us/windows/wsl/install-win10#update-to-wsl-2): Running Windows 10, updated to version 1903 or higher, Build 18362 or higher for x64 systems.

[Setup Docker version 2.3.0.5+.](https://docs.docker.com/docker-for-windows/install/) with WSL 2 enabled.

Reboot Windows, run Docker, allow WSL 2 kernel to be updated and restart Docker service for Windows.
Also kernel could be [updated](https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi) [manually](https://pureinfotech.com/install-windows-subsystem-linux-2-windows-10/).

Check Docker in `cmd.exe`:
- `docker ps` should work and show empty list.
- `docker-compose` should give help.
- `docker run --rm -it alpine sh` should run test Alpine image shell.

Check once again in Docker service settings (via tray icon menu) that WSL 2 is enabled and via `cmd.exe` that VERSION 2 is used for Docker:
```
wsl --list --verbose
```

### Ubuntu in WSL Setup
Run `powershell.exe` as Admin.

Enable Virtual Machine Platform.
```
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
```

Check WSL installed:
```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

Download Ubuntu 20 package omitting MS Store:
```
Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing
```

Install Ubuntu 20 WSL package:
```
Add-AppxPackage .\Ubuntu.appx
```

Run Ubuntu from Start menu.

Give Ubuntu username and password.

Run new Powershell window again.

Set default WSL version to 2:
```
wsl --set-version Ubuntu-20.04 2
wsl --set-default-version 2
wsl --list --verbose
```

### Link Ubuntu and Docker
Go to Docker service settings via tray icon, select Resources, WSL Integration, enable it for Ubuntu 20.

Apply and restart Docker service.

Open `cmd.exe` as Admin and set Ubuntu as default WSL app:
```
wsl --set-default Ubuntu-20.04
```

### Setup Ubuntu dev env:
Open Ubuntu bash shell via Start.

Update Ubuntu:
```
sudo apt update
sudo apt upgrade
sudo apt dist-upgrade
```

Setup needed utils:
```
sudo apt install git mc vim nano build-essential apt-transport-https ca-certificates curl software-properties-common
```

Setup git if needed:
```
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

Setup docker cli and docker-compose:
```
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install -y docker-ce-cli docker-compose
```

Allow your user to use docker without sudo:
```
sudo usermod -aG docker $USER
```

Setup mount of Windows disk with correct permissions. Add this to the `/etc/wsl.conf` file:
```
[automount]
enabled = true
options = "metadata,umask=22,fmask=11"
mountFsTab = false
```

Install symfony cli:
```
wget https://get.symfony.com/cli/installer -O - | sudo bash
sudo mv /root/.symfony/bin/symfony /usr/local/bin/symfony
```

Install php cli with demo symfony project deps:
```
sudo apt install php7.4-cli php7.4-sqlite3 php7.4-mbstring php7.4-xml
```

Install composer:
```
curl -s https://getcomposer.org/installer | sudo php
sudo mv composer.phar /usr/local/bin/composer
```

Restart Windows.

### Symfony Demo Test
Open Ubuntu bash shell.

Optionally change dir to your Windows home dir subfolder which is more convinient to open with your IDE.
```
cd /mnt/c/Users/USER/SomeDir
```

Decide project name and make dir for it:
```
export MY_PRJ=symfony-demo
mkdir $MY_PRJ
cd $MY_PRJ
```

Setup symfony demo (or other symfony project type):
```
symfony new --demo . # demo
#symfony new --full . # full app
#symfony new . # cli or microservice
```

Get project this project proto or pull new code:
```
(cd .. && cd php-project-proto && git pull || git clone https://github.com/sysadmws/php-project-proto)
```

Copy needed files from project proto:
```
cat ../php-project-proto/.env.addons | envsubst >> .env
cat ../php-project-proto/.gitignore >> .gitignore
cp -R ../php-project-proto/.docker/ ../php-project-proto/.gitlab-ci.yml ../php-project-proto/Makefile ../php-project-proto/docker-compose.yml ../php-project-proto/uid.sh .
```

Build and run project:
```
make build
make up
```

Other make commands help:
```
make help
```

Accept Windows firewall exceptions from Docker service. They will come with when containers run.

Open project services in Windows browser to check:
- [Symfony Demo](http://localhost)
- [phpinfo](http://localhost/_profiler/phpinfo)
- [RabbitMQ Admin](http://localhost:15672/)

# GitLab CI Setup
Install submodule:
```
git submodule add --name .gitlab-ci-functions -b master -- https://github.com/sysadmws/gitlab-ci-functions .gitlab-ci-functions
```

Substitute `__RUNNER_TAG__` with needed runner tag.

Set vars `DEPLOY_DOCKER_SERVER`, `DEPLOY_NGINX_SERVER`, `DEPLOY_URL`, `DEPLOY_APP` for CI for scope `proto` or change `proto` env in CI for something else.

# Push project to GitLab
The project dir should be already initialized as Git repo.

Add `git remote` remotes and push.
