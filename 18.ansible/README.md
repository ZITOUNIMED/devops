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
## Examples: ansible on AWS
### Exercice 1
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
      ansible_host: ........
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

### Exercice 2
```
$ pwd 
vprofile
$ cp -r exercice1/ exerice2
$ cd exercice2
$ ls
clientkey.pem inventory
$ vim inventory
all:
  hosts:
    web01:
      ansible_host: .....
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem
    web02:
      ansible_host: ......
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem
    db01:
      ansible_host: .......
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem
$ ansible web02 -m ping -i inventory
web02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
$ ansible db01 -m ping -i inventory
db01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

```

* ping many hosts together

```
$ vim inventory
all:
  hosts:
    web01:
      ansible_host: 172.31.25.59
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem
    web02:
      ansible_host: 172.31.16.174
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem
    db01:
      ansible_host: 172.31.27.54
      ansible_user: ec2-user
      ansible_ssh_private_key_file: clientkey.pem

  children:
    webservers:
      hosts:
        web01:
        web02:
    dbservers:
      hosts:
        db01:
    dc_oregon:
      children:
        webservers:
        dbservers:
$ ansible webservers -m ping -i inventoryweb02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
web01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
$ ansible dbservers -m ping -i inventory db01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
$ ansible dc_oregon -m ping -i inventory
web02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
db01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
web01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
$ ansible all -m ping -i inventory
web02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
db01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
web01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
$ ansible '*' -m ping -i inventory
web02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
web01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
db01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
$ ansible 'web*' -m ping -i inventory
web02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
web01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

### Exercice 3
```
$ cd ..
$ cp -r exercice2 exercice3
$ cd exercice3
$ ls
clientkey.pem  inventory
# we can define variables
# host variables have more priority than group variables
$ vim inventory
all:
  hosts:
    web01:
      ansible_host: 172.31.25.59
    web02:
      ansible_host: 172.31.16.174
    db01:
      ansible_host: 172.31.27.54

  children:
    webservers:
      hosts:
        web01:
        web02:
    dbservers:
      hosts:
        db01:
    dc_oregon:
      children:
        webservers:
        dbservers:
      vars:
        ansible_user: ec2-user
        ansible_ssh_private_key_file: clientkey.pem
```
### Exercice 4: ad hoc commands
Configuration managements:
```
$ cd ..
$ cp -r exercice3 exercice4
$ ansible web01 -m ansible.builtin.yum -a "name=httpd state=present" -i inventory
web01 | FAILED! => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "msg": "This command has to be run under the root user.",
    "results": []
}
$ ansible web01 -m ansible.builtin.yum -a "name=httpd state=present" -i inventory --become
web01 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": true,
    "msg": "",
    "rc": 0,
    "results": [
        "Installed: apr-util-1.6.1-23.el9.x86_64",
        "Installed: apr-util-bdb-1.6.1-23.el9.x86_64",
        "Installed: httpd-tools-2.4.57-8.el9.x86_64",
        "Installed: centos-logos-httpd-90.4-1.el9.noarch",
        "Installed: mailcap-2.1.49-5.el9.noarch",
        "Installed: mod_lua-2.4.57-8.el9.x86_64",
        "Installed: httpd-2.4.57-8.el9.x86_64",
        "Installed: apr-util-openssl-1.6.1-23.el9.x86_64",
        "Installed: httpd-core-2.4.57-8.el9.x86_64",
        "Installed: apr-1.7.0-12.el9.x86_64",
        "Installed: mod_http2-2.0.26-1.el9.x86_64",
        "Installed: httpd-filesystem-2.4.57-8.el9.noarch"
    ]
}
$ ansible webservers -m ansible.builtin.yum -a "name=httpd state=present" -i inventory --become
web01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "msg": "Nothing to do",
    "rc": 0,
    "results": []
}
web02 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": true,
    "msg": "",
    "rc": 0,
    "results": [
        "Installed: apr-util-1.6.1-23.el9.x86_64",
        "Installed: apr-util-bdb-1.6.1-23.el9.x86_64",
        "Installed: httpd-tools-2.4.57-8.el9.x86_64",
        "Installed: centos-logos-httpd-90.4-1.el9.noarch",
        "Installed: mailcap-2.1.49-5.el9.noarch",
        "Installed: mod_lua-2.4.57-8.el9.x86_64",
        "Installed: httpd-2.4.57-8.el9.x86_64",
        "Installed: apr-util-openssl-1.6.1-23.el9.x86_64",
        "Installed: httpd-core-2.4.57-8.el9.x86_64",
        "Installed: apr-1.7.0-12.el9.x86_64",
        "Installed: mod_http2-2.0.26-1.el9.x86_64",
        "Installed: httpd-filesystem-2.4.57-8.el9.noarch"
    ]
}
$ ansible webservers -m ansible.builtin.yum -a "name=httpd state=present" -i inventory --become
web02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "msg": "Nothing to do",
    "rc": 0,
    "results": []
}
web01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "msg": "Nothing to do",
    "rc": 0,
    "results": []
}
$ ansible webservers -m ansible.builtin.yum -a "name=httpd state=absent" -i inventory --become
web01 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": true,
    "msg": "",
    "rc": 0,
    "results": [
        "Removed: httpd-2.4.57-8.el9.x86_64",
        "Removed: mod_http2-2.0.26-1.el9.x86_64"
    ]
}
web02 | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": true,
    "msg": "",
    "rc": 0,
    "results": [
        "Removed: httpd-2.4.57-8.el9.x86_64",
        "Removed: mod_http2-2.0.26-1.el9.x86_64"
    ]
}
$ ansible webservers -m ansible.builtin.service -a "name=httpd state=started enabled=yes" -i inventory --become
# this will do systemctl start httpd and systemctl enable httpd
$ ansible webservers -m ansible.builtin.copy -a "src=index.html dest=/var/www/html/index.html" -i inventory --become
# change client-sg security group on aws and add new rule custom tcp from anywhere ipv4 or my ip on port 80
# copy public ip address from one ec2 instance web01 or web02 and open it in a browser => you will see the web page
$ ansible webservers -m ansible.builtin.service -a "name=httpd state=stopped" -i inventory --become
# and remove the last added inbound rule from security group
```
### Exercice 5: playbooks
```
$ cp exercice4 exercice5
$ cd exercice5
$ rm -rf index.html
$ $ ansible webservers -m yum -a "name=httpd state=absent" -i inventory --become
$ vim web-db.yaml
---
- name: Webserver setup
  hosts: webservers
  become: yes
  tasks:
    - name: Install httpd
      ansible.builtin.yum:
        name: httpd
        state: present

    - name: start service
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: yes

- name: DBserver setup
  hosts: dbservers
  become: yes
  tasks:
    - name: Install mariadb-server
      ansible.builtin.yum:
        name: mariadb-server
        state: present
$ ansible-playbook -i inventory web-db.yaml

PLAY [Webserver setup] *************************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]

TASK [Install httpd] ***************************************************************
changed: [web02]
changed: [web01]

TASK [start service] ***************************************************************
changed: [web02]
changed: [web01]

PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [Install mariadb-server] ******************************************************
changed: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=3    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$ vim web-db.yaml
---
- name: Webserver setup
  hosts: webservers
  become: yes
  tasks:
    - name: Install httpd
      ansible.builtin.yum:
        name: httpd
        state: present

    - name: start service
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: yes

- name: DBserver setup
  hosts: dbservers
  become: yes
  tasks:
    - name: Install mariadb-server
      ansible.builtin.yum:
        name: mariadb-server
        state: present
    - name: start mariadb service
      ansible.builtin.service:
        name: mariadb
        state: started
        enabled: yes

$ ansible-playbook -i inventory web-db.yaml 
# -v for debugging
# -vv for more debugging
# -vvv for mooore debugging

PLAY [Webserver setup] *************************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]

TASK [Install httpd] ***************************************************************
ok: [web02]
ok: [web01]

TASK [start service] ***************************************************************
ok: [web02]
ok: [web01]

PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [Install mariadb-server] ******************************************************
ok: [db01]

TASK [start mariadb service] *******************************************************
changed: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=3    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

$ ansible-playbook -i inventory web-db.yaml --syntax-check
$ ansible-playbook -i inventory web-db.yaml -C
# it is a dry-run it similated executing the playbook
```

### Exercice 6
```
$ cp exercice5 exercice6
$ cd exercice6
$ mv web-db.yaml web.yaml
$ vim web.yaml
---
- name: Webserver setup
  hosts: webservers
  become: yes
  tasks:
    - name: Install httpd
      ansible.builtin.yum:
        name: httpd
        state: present

    - name: start service
      ansible.builtin.service:
        name: httpd
        state: started
        enabled: yes
    - name: Copy Index file
      copy:
        src: files/index.html
        dest: /var/www/html/index.html
        backup: yes
$ mkdir files
$ cd files
$ vim index.html
Learn ansible modules
$ cd ..
$ ansible-playbook -i inventory web.yaml -C
$ ansible-playbook -i inventory web.yaml
PLAY [Webserver setup] *************************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]

TASK [Install httpd] ***************************************************************
ok: [web02]
ok: [web01]

TASK [start service] ***************************************************************
ok: [web02]
ok: [web01]

TASK [Copy Index file] *************************************************************
changed: [web02]
changed: [web01]

PLAY RECAP *************************************************************************
web01                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


```