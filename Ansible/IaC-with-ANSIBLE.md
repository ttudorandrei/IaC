# IAC with Ansible

## Table of Contents

- [IAC with Ansible](#iac-with-ansible)
  - [Table of Contents](#table-of-contents)
  - [Technologies we will use](#technologies-we-will-use)
  - [What is Ansible?](#what-is-ansible)
  - [Setting up Ansible Controller](#setting-up-ansible-controller)
  - [Ansible Playbooks](#ansible-playbooks)
  - [Why should we use Playbooks?](#why-should-we-use-playbooks)
  - [Useful Commands](#useful-commands)
    - [How to create a Playbook (`<filename>.yaml/yml`)](#how-to-create-a-playbook-filenameyamlyml)
    - [Migrate to aws](#migrate-to-aws)
    - [Create the EC2 instance using Ansible yml file](#create-the-ec2-instance-using-ansible-yml-file)
    - [After launching instance](#after-launching-instance)
  - [Let's create Vagrantfile to create Three VMs for Ansible architecture](#lets-create-vagrantfile-to-create-three-vms-for-ansible-architecture)
    - [Ansible controller and Ansible agents](#ansible-controller-and-ansible-agents)
  - [Useful links](#useful-links)

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

## Ansible Playbooks

- They are a script (YAML/YML) files to implement config management.
- The YAML file starts with `---`

## Why should we use Playbooks?

Playbooks save time and are reusable.

## Useful Commands

- SSH into agent node: From controller, do `ssh vagrant@<ip>`
- To run a playbook, from the controller, go to `/etc/ansible` and run `ansible-playbook <playbook-name>.yaml/yml`
- To execute a command from `ansible controller` on a `node` do `ansible <node-name> -a '<command/s>'`. Node name has to be the same one as the one in `hosts file`.

### How to create a Playbook (`<filename>.yaml/yml`)

- Go to hosts file and link the nodes (as in the setup above.)
- Create a file with `yml` extension

### Migrate to aws

- Set up ansible controller to use in hybrid infra form on prem - public cloud
- Install required dependencies (`python3` - `pip3` - `awscli` - `ansible` - `boto3` - `tree`)
- To sync local files to vagrant controller do `scp -i "<path-and-file-folder-name>" -r <folder-or-filename> <vm-suer>@<ip-of-vm>:<path-to-destination-folder>`. Example: `scp -i "~/sparta-global/week-3-devops-intro-environments" -r app vagrant@192.168.33.12:~/app/`
- Alias `python=python3`
- Set up `Ansible Vault`
- Get `aws_access & secret keys`
- ansible-vault folder structure: got to `/etc/ansible` and create a new folder `group_vars` inside of which you create another folder `all`.
- Inside the `all` folder from above create a `file.yml` to store `aws keys`: `sudo ansible-vault create pass.yml`
- chmod 600 file.yml (to change permissions for `file.yml`)

### Create the EC2 instance using Ansible yml file

- Create a new `.yml` file
- Add this code:

```
---
- hosts: localhost
  connection: local
  gather_facts: yes

  vars_files:
  - group_vars/all/pass.yml

  tasks:
  - name: Launch ec2 instance
    ec2:
      aws_access_key: "{{ ec2_access_key }}"
      aws_secret_key: "{{ ec2_secret_key }}"
      key_name: eng103a
      instance_type: t2.micro
      image: ami-07d8796a2b0f8d29c
      wait: yes
      group: default
      region: "eu-west-1"
      count: 1
      vpc_subnet_id: subnet-0429d69d55dfad9d2
      assign_public_ip: yes
      instance_tags:
        Name: tudor_playbook

  tags: ['never', 'create_ec2']

```

- Use this command to execute the `.yml` file: `sudo ansible-playbook ec2-3.yml --ask-vault-pass --tags create_ec2 --tags=ec2-create -e "ansible_python_interpreter=/usr/bin/python3" --verbose`

### After launching instance

- Get the ip of the instance
- ping the instance `ansible <name-of-instance> -m ping`. If it is an EC2 instance, do something like this: `sudo ansible aws -m ping --ask-vault-pass`
- Got to `/etc/ansible`
- Open the `hosts` file
- Add:

```
[aws]
<ec2-ip> <secret_key> <password>

# example for ec2 instance
[aws]
54.170.219.46 ansible_connection=ssh ansible_ssh_user=ubuntu ansible_ssh_private_key_file=/home/vagrant/.ssh/eng103a.pem
```

- To work with a hybrid setup you need to add `--ask-vault-pass` at the end of the command. Example: `sudo ansible all -m ping --ask-vault-pass` to ping instances

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
     # creating a link called development.web so we can access web page with this link instead of an IP

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

## Useful links

- Create EC2 instance with ansible: [Article on medium](https://medium.datadriveninvestor.com/devops-using-ansible-to-provision-aws-ec2-instances-3d70a1cb155f), [Official Ansible Documentation](https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_module.html), [Similar Ansible documentation](https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_instance_module.html#ansible-collections-amazon-aws-ec2-instance-module)
