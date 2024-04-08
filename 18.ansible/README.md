# Ansible
Ansible is an automation tool.
## Use cases:
* Automation: Any system automation
* Change managment: Production server changes
* Provisioning: Setup servers from scratch/ cloud provisioning
* Orchestration: large scale automation framework

## Characteristics
Asible is:
* No agents: target machines/services are accessed by SSH, winrm & API
* No databases: YAML, INI & Texts
* No complex setup: it's just a Python library.
* No Residual Software: Push python package, execute, return output.
* YAML: no programming, stuctured, easy to read & write
* API: ansible has lots of modules such as API module: URL/Restful calls (e.g cloud), Shell commands, Scripts.
## Asible connection
See screenshot ansible-connection.png'.
Ansible uses SSH or winrm or API or physical cables to connect to systems:
* SSH: for Linux
* winrm: for windows
* API: for cloud
* cables: routers, switches, any server
## Ansible architecture
See screenshot 'ansible-architecture.png'.
## Example: ansible on AWS
Follow steps:
1. create EC2 instance free tier with this config:
* AMI ubuntu
* key pair: RSA and pem file
* new sg with inbount rule ssh and ip my ip
2. connect to the instance from windows 
* open git bash
* copy public ip of the instance
* use this command to ssh into the instance
```
$ ssh -i key-par-file.pem ubunto@<public ip addr here>
```
3. install ansible on ubuntu
* open ansible documentation section: "Installing Ansible on specific operating systems" and subsection "installing ansible on ubuntu"
* copy commands and execute them one by one:
```
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo add-apt-repository --yes --update ppa:ansible/ansible
$ sudo apt install ansible
$ ansible --version
```
4. create 3 client ec2 instances
* click start new instance and choose number of instances 3 and use name vprofile-web00 
* search new AMI centos 9 and select it
* change type t3.micro to t2.micro 1cpu and 1 gb memory ram
* create new sg with: first inbound rule type ssh from my ip and second inbound rule type custom tcp source custom and search for ansible sg.
* create new key pair: RSA pem file
* click create
* after creation change names and use: vprofile-web01, vprofile-web02, and vprofile-db01
5. create ansible inventory
* ssh into ansile ec2 instance
* search on google for ansible inventry and open link: How to build your inventory
* create folder vprofile/exercice1
* the default ansible inventory file is /etc/ansible/hosts it is not recommanded to use it
* create new inventory file:
```
$ vim inventory
all:
  hosts:
    web01:
      ansible_host: 172.31.25.59
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem

```
* copy content of client-key.pem keypair file downloaded from aws
```
$ cat client-key.pem
-----BEGIN RSA PRIVATE KEY-----
MIkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk
hhhhhhhhhhhhhhhhhhhhhhhh
example here
mmmmmmmmmmmmmmmmmmmmm9c
-----END RSA PRIVATE KEY-----
```
* create clientkey.pem under /vprofile/exercice1 in ansible ec2 instance
```
$ vim clientkey.pem
<past content here>
```
* change permission of clientkey.pem file
```
$ ls -l
-rw-rw-r-- 1 ubuntu ubuntu 1675 Apr  8 15:32 clientkey.pem
-rw-rw-r-- 1 ubuntu ubuntu  138 Apr  8 15:25 inventory
```
this file does not have the required permission we need to change it.

* use the key file to connect to ec2 instance using ansible
```
$ ansible web01 -m ping -i inventory
Are you sure you want to continue connecting (yes/no/[fingerprint])? no
```
This will ask as to say yes manualy. This is not good think for automation. We need to say to ansible to say yes by default.
To do that:
```
$ sudo cat /etc/ansible/ansible.cfg
$ sudo -i
$ cd /etc/ansible
$ ls
ansible.cfg hosts roles
$ mv ansible.cfg ansible.cfg_backup
$ cat /etc/ansible/ansible.cfg
$ ansible-config init --disabled -t all > ansible.cfg
$ ls
ansible.cfg ansible.cfg_backup hosts roles
$ vim ansible.cfg
host_key_checking=False
$ exit
$ pwd
vprofile/exercice1
$ ansible web01 -m ping -i inventory
UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: Warning: Permanently added '......' (ED25519) to the list of known hosts.\r\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\n@         WARNING: UNPROTECTED PRIVATE KEY FILE!          @\r\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\nPermissions 0664 for 'clientkey.pem' are too open.\r\nIt is required that your private key files are NOT accessible by others.\r\nThis private key will be ignored.\r\nLoad key \"clientkey.pem\": bad permissions\r\nec2-user@....: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).",
    "unreachable": true
}
$ chmod 400 clientkey.pem
$ ansible web01 -m ping -i inventory
web01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

```

