# Fast Hypernode Vagrant Box

**The fastest Magento2 Vagrant VM**
Fast Byte Hypernode Box (Uses nfs_guest plugin for file shares)

Based on:
* https://github.com/EcomDev/fast-hypernode
* https://github.com/byteinternet/hypernode-vagrant

# Installation

Installation is possible via composer:

```bash
1) composer create-project claudiucreanga/magento2-vagrant
```

# Required Vagrant plugins

* vagrant-hostmanager
* vagrant-auto_network
* vagrant-nfs_guest

```bash
2) vagrant plugin install vagrant-hostmanager vagrant-auto_network vagrant-nfs_guest
```

# Usage

3) Edit config.rb to reflect your project settings (configuration options at the bottom of the page)
```ruby
name 'your-project-name'
hostname name + '.box' # will be your main url http://your-project-name.box/
profiler true # Add tideways-profiler ?
developer true # Enable development mode?
directory 'server' # Directory into which NFS share will be mounted on your host
php7 true
memory 3072
```
4) Start the box (it will take about ~45 minutes)
```bash
cd magento2-vagrant
vagrant up
```

5) Build your magento2 project (install nodejs, npm etc.)
```bash
vagrant ssh
# install nodejs 5
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install nodejs

# inside /data/web/public/ you can find your files from server/public directory
cd /data/web/public/

# install npm packages and grunt globally
sudo npm install
sudo npm install -g grunt-cli
```

6) Setup your database
```bash
# find you MySQL password in /data/web/.my.cnf by loging in to SSH
cat /data/web/.my.cnf
mysql -u app -p
# create database and/or import an already existing one
```

7) Clone an already existing project or create a new magento2 project with composer. You can do it inside your vagrant machine or on your local machine depending where you will want to do your git work.

8) Magento bash
```bash
# always work as the app user so that you will not get permission errors when magento generates files
sudo su app
# open your bash profile
sudo nano ~/.bashrc
# add this line into your bash profile
export PATH=$PATH:/data/web/public/bin
# then refresh your profile
source ~/.bashrc
# then give permissions to magento
sudo chmod a+x /data/web/public/bin/magento
# give permissions to magento folders
sudo chown -R app:app /data/web/public/
sudo chmod -R 777 var/ lib/ pub/ app/etc/
# test that everything is fine, inside /data/web/public/ directory type
magento list
# you should receive the list of magento commands, now deploy your static files
magento setup:static-content:deploy
# and visit the domain.box
```

9) Day to day work
```bash
cd magento2-vagrant
vagrant ssh
cd /data/web/public/
sudo su app
grunt task
```

# Configuration Options

* `name` - name of your node
* `hostname` - default project hostname
* `domains` - list of additional domain names for your project
* `varnish` - enable or disable varnish for your project (default: `false`)
* `profiler` - enable or disable tideways-profiler (default: `false`)
* `developer` - enable or disable developer mode in Magento (default: `false`)
* `magento2` - Magento 2.0 installment? (default: `false`)
* `install` - Shall Magento be installed? (default: `false`, only Magento 2.0 installation supported)
* `shell` - Install FishShell? (default: `false`)
* `php7` - PHP7 instead of PHP5? (default: `false`)
* `cpu` - number of CPUs to dedicate to your VM (default: `1`)
* `memory` - memory in MB to dedicate to your VM (default: `1024`)
* `user` - User name for nfs share permissions (default: `app`)
* `group` - Group name for nfs share permissions (default: `app`)
* `uid` - User ID of your host to be mapped to linux VM (default: `Process.euid`)
* `gid` - Group ID of your host to be mapped to linux VM (default: `Process.egid`)
* `directory` - Directory to be used as mount on host machine (default: `server`)
* `network` - Network mast for automatical network assignment to VM (default: `33.33.33.0/24`)

# Adding custom shell provisioners

You can easily add more provision shell scripts from configuration file (config.rb):
```ruby
shell_add 'some-custom-shell-script.sh'

# Will provision only if PHP7 flag is turned on
shell_add 'some-custom-script-for-php7.sh', :php7  
```
