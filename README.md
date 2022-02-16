# IAC with Ansible

## Table of Contents

- [IAC with Ansible](#iac-with-ansible)
  - [Table of Contents](#table-of-contents)
  - [Technologies we will use](#technologies-we-will-use)
  - [What is Ansible?](#what-is-ansible)
  - [Setting up Ansible Controller](#setting-up-ansible-controller)
  - [Let's create Vagrantfile to create Three VMs for Ansible architecture](#lets-create-vagrantfile-to-create-three-vms-for-ansible-architecture)
    - [Ansible controller and Ansible agents](#ansible-controller-and-ansible-agents)

## Technologies we will use

- Ansible (YAML/YML) (YAML - Yet Another Markup Language)
- Terraform for Orchestration
- Configuration Management
- Push Config - Ansible to push to config

## What is Ansible?

Ansible is Agentless (the nodes do not need to have Ansible)

## Setting up Ansible Controller

- install required dependencies i.e. Python `sudo apt-get install software-properties-common`
- install ansible `sudo apt-add-repository ppa:ansible/ansible`, `sudo apt-get ansible -y`
- check version of ansible `ansible --version`
- tree `sudo apt install tree`. This displays the folder structure in a better way.
- set up `agent nodes`
- default folder structures `/etc/ansible`. In this folder we have the hosts file we need to inform that we have an `agent node` called `web`. It has the ip of the `web`. To edit this use `sudo nano /etc/ansible/hosts`:
  ```
  [<name-of-node>]
  <ip-of-node> ansible_connection=ssh ansible_ssh_user=vagrant ansible_ssh_pass=vagrant
  ```
- to connect to agent nodes, from your controller do `ssh <node-username>@<node-ip>`. Example: `ssh vagrant@193.168.33.11`
- check free memory in all nodes: From controller do `ansible all -a free`
- copy file from controller to node: `ansible <destination-node-name> -m copy -a 'src=<path-to-file> dest=<destination-path-on-node>'`

## Let's create Vagrantfile to create Three VMs for Ansible architecture

### Ansible controller and Ansible agents

```

# -*- mode: ruby -*-
 # vi: set ft=ruby :

 # All Vagrant configuration is done below. The "2" in Vagrant.configure
 # configures the configuration version (we support older styles for
 # backwards compatibility). Please don't change it unless you know what

 # MULTI SERVER/VMs environment
 #
 Vagrant.configure("2") do |config|
 # creating are Ansible controller
   config.vm.define "controller" do |controller|

    controller.vm.box = "bento/ubuntu-18.04"

    controller.vm.hostname = 'controller'

    controller.vm.network :private_network, ip: "192.168.33.12"

    # config.hostsupdater.aliases = ["development.controller"]

   end
 # creating first VM called web
   config.vm.define "web" do |web|

     web.vm.box = "bento/ubuntu-18.04"
    # downloading ubuntu 18.04 image

     web.vm.hostname = 'web'
     # assigning host name to the VM

     web.vm.network :private_network, ip: "192.168.33.10"
     #   assigning private IP

     #config.hostsupdater.aliases = ["development.web"]
     # creating a link called development.web so we can access web page with this link instread of an IP

   end

 # creating second VM called db
   config.vm.define "db" do |db|

     db.vm.box = "bento/ubuntu-18.04"

     db.vm.hostname = 'db'

     db.vm.network :private_network, ip: "192.168.33.11"

     #config.hostsupdater.aliases = ["development.db"]
   end


 end
```
