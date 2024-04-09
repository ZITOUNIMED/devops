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
In this exercice we will see how to use ansible Files module with a sample example of copying a file from ansible host to target host.
Search for the documentation using keywork ansible module index and open the link of the module Files index. You can see there examples.
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

$ ls
clientkey.pem  files  inventory  web.yaml
$ cat inventory
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

$ ssh -i clientkey.pem ec2-user@172.31.16.174
Last login: Tue Apr  9 05:27:19 2024 from 172.31.25.35
$ cd /var/www/html/
$ ls
index.html  index.html.19371.2024-04-09@05:27:20~
$ cat index.html
Learn modules of ansible
$ cat index.html.19371.2024-04-09\@05\:27\:20~
this is managed by ansible v2
$ exit
$ sudo hostname control
$ exit
$ ssh -i mz-controlmachine-kp.pem ubuntu@54.197.2.148
ubuntu@control:~$
```

### Exercice 7
In this exercice we will see how to manage a database on a target host using ansible.
Search for documentation using keyword ansible index module and open the submodule link databases modules and look for mysql and open it.
```
ubuntu@control:~$ cd vprofile
ubuntu@control:~/vprofile$ cp -r exercice5 exercice7
ubuntu@control:~/vprofile$ cd exercice7
ubuntu@control:~/vprofile/exercice7$ ls
clientkey.pem  inventory  web-db.yaml
ubuntu@control:~/vprofile/exercice7$ mv web-db.yaml db.yaml
ubuntu@control:~/vprofile/exercice7$ vim db.yaml
---
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
    - name: Create a new database with name 'accounts'
      mysql_db:
        name: accounts
        state: present
ubuntu@control:~/vprofile/exercice7$ ansible-playbook -i inventory db.yaml -C

PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [Install mariadb-server] ******************************************************
ok: [db01]

TASK [start mariadb service] *******************************************************
ok: [db01]

TASK [Create a new database with name 'accounts'] **********************************
fatal: [db01]: FAILED! => {"changed": false, "msg": "A MySQL module is required: for Python 2.7 either PyMySQL, or MySQL-python, or for Python 3.X mysqlclient or PyMySQL. Consider setting ansible_python_interpreter to use the intended Python version."}

PLAY RECAP *************************************************************************
db01                       : ok=3    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

$ cat inventory
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

ubuntu@control:~/vprofile/exercice7$ ls
clientkey.pem  db.yaml  inventory
ubuntu@control:~/vprofile/exercice7$ ssh -i clientkey.pem ec2-user@172.31.27.54
Last login: Tue Apr  9 05:51:54 2024 from 172.31.25.35
[ec2-user@ip-172-31-27-54 ~]$ sudo -i
[root@ip-172-31-27-54 ~]# yum search python | grep -i mysql
Last metadata expiration check: 1:00:05 ago on Tue 09 Apr 2024 04:57:25 AM UTC.
python3-PyMySQL.noarch : Pure-Python MySQL client library
python3.11-PyMySQL.noarch : Pure-Python MySQL client library
python3.11-PyMySQL+rsa.noarch : Metapackage for python3.11-PyMySQL: rsa extras
python3.12-PyMySQL.noarch : Pure-Python MySQL client library
python3.12-PyMySQL+rsa.noarch : Metapackage for python3.12-PyMySQL: rsa extras
[root@ip-172-31-27-54 ~]# exit
logout
[ec2-user@ip-172-31-27-54 ~]$ exit
logout
Connection to 172.31.27.54 closed.
ubuntu@control:~/vprofile/exercice7$
ubuntu@control:~/vprofile/exercice7$ vim db.yaml
---
- name: DBserver setup
  hosts: dbservers
  become: yes
  tasks:
    - name: Install mariadb-server
      ansible.builtin.yum:
        name: mariadb-server
        state: present

    - name: Install pymysql
      ansible.builtin.yum:
        name: python3-PyMySQL
        state: present

    - name: start mariadb service
      ansible.builtin.service:
        name: mariadb
        state: started
        enabled: yes

    - name: Create a new database with name 'accounts'
      mysql_db:
        name: accounts
        state: present
ubuntu@control:~/vprofile/exercice7$ ansible-playbook -i inventory db.yaml

PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [Install mariadb-server] ******************************************************
ok: [db01]

TASK [Install pymysql] *************************************************************
changed: [db01]

TASK [start mariadb service] *******************************************************
ok: [db01]

TASK [Create a new database with name 'accounts'] **********************************
fatal: [db01]: FAILED! => {"changed": false, "msg": "unable to find /root/.my.cnf. Exception message: (1698, \"Access denied for user 'root'@'localhost'\")"}

PLAY RECAP *************************************************************************
db01                       : ok=4    changed=1    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
ubuntu@control:~/vprofile/exercice7$ vim db.yaml
---
- name: DBserver setup
  hosts: dbservers
  become: yes
  tasks:
    - name: Install mariadb-server
      ansible.builtin.yum:
        name: mariadb-server
        state: present

    - name: Install pymysql
      ansible.builtin.yum:
        name: python3-PyMySQL
        state: present

    - name: start mariadb service
      ansible.builtin.service:
        name: mariadb
        state: started
        enabled: yes

    - name: Create a new database with name 'accounts'
      mysql_db:
        name: accounts
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock

ubuntu@control:~/vprofile/exercice7$ ansible-playbook -i inventory db.yaml

PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [Install mariadb-server] ******************************************************
ok: [db01]

TASK [Install pymysql] *************************************************************
ok: [db01]

TASK [start mariadb service] *******************************************************
ok: [db01]

TASK [Create a new database with name 'accounts'] **********************************
changed: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
#### Exercice 7 part 2
Use mysql community module:
* Search on Google for ansible mysql community and open the found link. 
* Open mysql_db.module

```
ubuntu@control:~/vprofile/exercice7$ ansible-galaxy collection install community.mysql
Starting galaxy collection install process
Nothing to do. All requested collections are already installed. If you want to reinstall them, consider using `--force`.
ubuntu@control:~/vprofile/exercice7$ vim db.yaml
ubuntu@control:~/vprofile/exercice7$ cat db.yaml
---
- name: DBserver setup
  hosts: dbservers
  become: yes
  tasks:
    - name: Install mariadb-server
      ansible.builtin.yum:
        name: mariadb-server
        state: present

    - name: Install pymysql
      ansible.builtin.yum:
        name: python3-PyMySQL
        state: present

    - name: start mariadb service
      ansible.builtin.service:
        name: mariadb
        state: started
        enabled: yes

    - name: Create a new database with name 'accounts'
      community.mysql.mysql_db:
        name: accounts
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock

    - name: Create database user with name 'vprofile'
      community.mysql.mysql_user:
        name: vprofile
        password: 'admin943'
        priv: '*.*:ALL'
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock
ubuntu@control:~/vprofile/exercice7$ ansible-playbook -i inventory db.yaml          
PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [Install mariadb-server] ******************************************************
ok: [db01]

TASK [Install pymysql] *************************************************************
ok: [db01]

TASK [start mariadb service] *******************************************************
ok: [db01]

TASK [Create a new database with name 'accounts'] **********************************
ok: [db01]

TASK [Create database user with name 'vprofile'] ***********************************
[WARNING]: Option column_case_sensitive is not provided. The default is now false,
so the column's name will be uppercased. The default will be changed to true in
community.mysql 4.0.0.
changed: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=6    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

## Ansible configuration
### Order of Ansible config
1. ANSIBLE_CONFIG (environment variable if set)
2. ansible.cfg (in the current directory)
3. ~/.ansible.cfg (in the home directory)
4. /etc/ansible/ansible.cfg

* Lets inspect /etc/ansible.ansible.cfg file:
```
ubuntu@control:~/vprofile/exercice7$ sudo -i
root@control:~# vim /etc/ansible/ansible.cfg
root@control:~# exit
```

* Search on google for ansible configuration file.

* Lets use local ansible.cfg file for the current project

```
ubuntu@control:~/vprofile/exercice7$ vim ansible.cfg
ubuntu@control:~/vprofile/exercice7$ cat ansible.cfg
[defaults]
host_key_checking=False
inventory= ./inventory
forks=3
log_path=/var/log/ansible.log

[privilege_escalation]
become=True
become_method=sudo
become_ask_pass=False
ubuntu@control:~/vprofile/exercice7$ ansible-playbook db.yaml
[WARNING]: log file at /var/log/ansible.log is not writeable and we cannot create it, aborting


PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [Install mariadb-server] ******************************************************
ok: [db01]

TASK [Install pymysql] *************************************************************
ok: [db01]

TASK [start mariadb service] *******************************************************
ok: [db01]

TASK [Create a new database with name 'accounts'] **********************************
ok: [db01]

TASK [Create database user with name 'vprofile'] ***********************************
[WARNING]: Option column_case_sensitive is not provided. The default is now false,
so the column's name will be uppercased. The default will be changed to true in
community.mysql 4.0.0.
ok: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu@control:~/vprofile/exercice7$ sudo touch /var/log/ansible.log
ubuntu@control:~/vprofile/exercice7$ sudo chown ubuntu.ubuntu /var/log/ansible.log
ubuntu@control:~/vprofile/exercice7$ cat /var/log/ansible.log
ubuntu@control:~/vprofile/exercice7$ ansible-playbook db.yaml

PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [Install mariadb-server] ******************************************************
ok: [db01]

TASK [Install pymysql] *************************************************************
ok: [db01]

TASK [start mariadb service] *******************************************************
ok: [db01]

TASK [Create a new database with name 'accounts'] **********************************
ok: [db01]

TASK [Create database user with name 'vprofile'] ***********************************
[WARNING]: Option column_case_sensitive is not provided. The default is now false,
so the column's name will be uppercased. The default will be changed to true in
community.mysql 4.0.0.
ok: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice7$ cat /var/log/ansible.log
2024-04-09 07:01:30,843 p=14178 u=ubuntu n=ansible | PLAY [DBserver setup] **************************************************************
2024-04-09 07:01:30,852 p=14178 u=ubuntu n=ansible | TASK [Gathering Facts] *************************************************************
2024-04-09 07:01:32,487 p=14178 u=ubuntu n=ansible | ok: [db01]
2024-04-09 07:01:32,501 p=14178 u=ubuntu n=ansible | TASK [Install mariadb-server] ******************************************************
2024-04-09 07:01:33,780 p=14178 u=ubuntu n=ansible | ok: [db01]
2024-04-09 07:01:33,787 p=14178 u=ubuntu n=ansible | TASK [Install pymysql] *************************************************************
2024-04-09 07:01:34,875 p=14178 u=ubuntu n=ansible | ok: [db01]
2024-04-09 07:01:34,882 p=14178 u=ubuntu n=ansible | TASK [start mariadb service] *******************************************************
2024-04-09 07:01:35,826 p=14178 u=ubuntu n=ansible | ok: [db01]
2024-04-09 07:01:35,834 p=14178 u=ubuntu n=ansible | TASK [Create a new database with name 'accounts'] **********************************
2024-04-09 07:01:36,483 p=14178 u=ubuntu n=ansible | ok: [db01]
2024-04-09 07:01:36,488 p=14178 u=ubuntu n=ansible | TASK [Create database user with name 'vprofile'] ***********************************
2024-04-09 07:01:37,180 p=14178 u=ubuntu n=ansible | [WARNING]: Option column_case_sensitive is not provided. The default is now false,
so the column's name will be uppercased. The default will be changed to true in
community.mysql 4.0.0.

2024-04-09 07:01:37,180 p=14178 u=ubuntu n=ansible | ok: [db01]
2024-04-09 07:01:37,194 p=14178 u=ubuntu n=ansible | PLAY RECAP *************************************************************************
2024-04-09 07:01:37,194 p=14178 u=ubuntu n=ansible | db01                       : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 

```

## Ansible varibles
* Playbook
- hosts: webserver
  vars:
    http_port: 80
    sqluser: admin

* Inventory Based
in inventory file
group_vars/all: for all hosts
group_vars/groupname: for a specific group
host_vars/hostname: for specific host

* Roles
Include variables variables from files in playbook.

* Fact variables: setup module
Ansible has its own variables they are generated by setup module. We don't need to execute setup module. When we execute the playbook, the first task is executed gathering fact, that task will run the setup module and generate the fact variables.
Examples:
- ansible_os_family
OS name like Redhat, Debian
etc.
- ansible_processor_corses
Number of CPU cores
- ansible_kernel
kernet version
- ansible_devices
connected device information
- ansible_default_ipv4
IP, MAC address, gateway etc.
- ansible_architecture
64 bit or 32 bit

These variables can be used to let our playbook make decisions during execution. for example install package based on ansible_architecture variable 64 or 32.

* Store output: register module
We can execute a task and return the output in json format and store it and use as the variable in the next task or just print it.
Steps:
- Module execution: Playbook tasks
- Return output: JSON Format
- Store Output: variable to store
- use variable: in tasks or print it

### Exercice 8
Example of use of variables
```
ubuntu@control:~/vprofile$ cp -r exercice7 exercice8
ubuntu@control:~/vprofile$ ls
exercice1  exercice3  exercice5  exercice7
exercice2  exercice4  exercice6  exercice8
ubuntu@control:~/vprofile$ cd exercice8
ubuntu@control:~/vprofile/exercice8$ ls
ansible.cfg  clientkey.pem  db.yaml  inventory
ubuntu@control:~/vprofile/exercice8$ vim db.yaml
ubuntu@control:~/vprofile/exercice8$ cat db.yaml
---
- name: DBserver setup
  hosts: dbservers
  become: yes
  vars:
    dbname: electric
    dbuser: current
    dbpass: tesla
  tasks:
    - name: Install mariadb-server
      ansible.builtin.yum:
        name: mariadb-server
        state: present

    - name: Install pymysql
      ansible.builtin.yum:
        name: python3-PyMySQL
        state: present

    - name: start mariadb service
      ansible.builtin.service:
        name: mariadb
        state: started
        enabled: yes

    - name: Create a new database
      community.mysql.mysql_db:
        name: "{{dbname}}"
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock

    - name: Create database user
      community.mysql.mysql_user:
        name: "{{dbuser}}"
        password: "{{dbpass}}"
        priv: '*.*:ALL'
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock

ubuntu@control:~/vprofile/exercice8$ ansible-playbook db.yaml

PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [Install mariadb-server] ******************************************************
ok: [db01]

TASK [Install pymysql] *************************************************************
ok: [db01]

TASK [start mariadb service] *******************************************************
ok: [db01]

TASK [Create a new database] *******************************************************
changed: [db01]

TASK [Create database user] ********************************************************
[WARNING]: Option column_case_sensitive is not provided. The default is now false,
so the column's name will be uppercased. The default will be changed to true in
community.mysql 4.0.0.
changed: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=6    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice8$ vim db.yaml
ubuntu@control:~/vprofile/exercice8$ cat db.yaml
---
- name: DBserver setup
  hosts: dbservers
  become: yes
  vars:
    dbname: electric
    dbuser: current
    dbpass: tesla
  tasks:
    - debug:
        msg: "Dbname: {{dbname}}, dbuser: {{dbuser}}, dbpass: {{dbpass}}"
    - name: Install mariadb-server
      ansible.builtin.yum:
        name: mariadb-server
        state: present

    - name: Install pymysql
      ansible.builtin.yum:
        name: python3-PyMySQL
        state: present

    - name: start mariadb service
      ansible.builtin.service:
        name: mariadb
        state: started
        enabled: yes

    - name: Create a new database
      community.mysql.mysql_db:
        name: "{{dbname}}"
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock

    - name: Create database user
      community.mysql.mysql_user:
        name: "{{dbuser}}"
        password: "{{dbpass}}"
        priv: '*.*:ALL'
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock

ubuntu@control:~/vprofile/exercice8$ ansible-playbook db.yaml

PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [debug] ***********************************************************************
ok: [db01] => {
    "msg": "Dbname: electric, dbuser: current, dbpass: tesla"
}

TASK [Install mariadb-server] ******************************************************
ok: [db01]

TASK [Install pymysql] *************************************************************
ok: [db01]

TASK [start mariadb service] *******************************************************
ok: [db01]

TASK [Create a new database] *******************************************************
ok: [db01]

TASK [Create database user] ********************************************************
[WARNING]: Option column_case_sensitive is not provided. The default is now false,
so the column's name will be uppercased. The default will be changed to true in
community.mysql 4.0.0.
ok: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice8$
ubuntu@control:~/vprofile/exercice8$ vim db.yaml
ubuntu@control:~/vprofile/exercice8$ cat db.yaml
---
- name: DBserver setup
  hosts: dbservers
  become: yes
  vars:
    dbname: electric
    dbuser: current
    dbpass: tesla
  tasks:
    - debug:
        msg: "Dbname: {{dbname}}, dbuser: {{dbuser}}"
    - debug:
        var: dbpass

    - name: Install mariadb-server
      ansible.builtin.yum:
        name: mariadb-server
        state: present

    - name: Install pymysql
      ansible.builtin.yum:
        name: python3-PyMySQL
        state: present

    - name: start mariadb service
      ansible.builtin.service:
        name: mariadb
        state: started
        enabled: yes

    - name: Create a new database
      community.mysql.mysql_db:
        name: "{{dbname}}"
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock

    - name: Create database user
      community.mysql.mysql_user:
        name: "{{dbuser}}"
        password: "{{dbpass}}"
        priv: '*.*:ALL'
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock

ubuntu@control:~/vprofile/exercice8$ ansible-playbook db.yaml

PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [debug] ***********************************************************************
ok: [db01] => {
    "msg": "Dbname: electric, dbuser: current"
}

TASK [debug] ***********************************************************************
ok: [db01] => {
    "dbpass": "tesla"
}

TASK [Install mariadb-server] ******************************************************
ok: [db01]

TASK [Install pymysql] *************************************************************
ok: [db01]

TASK [start mariadb service] *******************************************************
ok: [db01]

TASK [Create a new database] *******************************************************
ok: [db01]

TASK [Create database user] ********************************************************
[WARNING]: Option column_case_sensitive is not provided. The default is now false,
so the column's name will be uppercased. The default will be changed to true in
community.mysql 4.0.0.
ok: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=8    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice8$ vim db.yaml
ubuntu@control:~/vprofile/exercice8$ cat db.yaml
---
- name: DBserver setup
  hosts: dbservers
  become: yes
  vars:
    dbname: electric
    dbuser: current
    dbpass: tesla
  tasks:
    - debug:
        msg: "Dbname: {{dbname}}, dbuser: {{dbuser}}"
    - debug:
        var: dbpass

    - name: Install mariadb-server
      ansible.builtin.yum:
        name: mariadb-server
        state: present

    - name: Install pymysql
      ansible.builtin.yum:
        name: python3-PyMySQL
        state: present

    - name: start mariadb service
      ansible.builtin.service:
        name: mariadb
        state: started
        enabled: yes

    - name: Create a new database
      community.mysql.mysql_db:
        name: "{{dbname}}"
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock

    - name: Create database user
      community.mysql.mysql_user:
        name: "{{dbuser}}"
        password: "{{dbpass}}"
        priv: '*.*:ALL'
        state: present
        login_unix_socket: /var/lib/mysql/mysql.sock
      register: dbout
    - name: print dbout variable
      debug:
        var: dbout

ubuntu@control:~/vprofile/exercice8$ ansible-playbook db.yaml

PLAY [DBserver setup] **************************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]

TASK [debug] ***********************************************************************
ok: [db01] => {
    "msg": "Dbname: electric, dbuser: current"
}

TASK [debug] ***********************************************************************
ok: [db01] => {
    "dbpass": "tesla"
}

TASK [Install mariadb-server] ******************************************************
ok: [db01]

TASK [Install pymysql] *************************************************************
ok: [db01]

TASK [start mariadb service] *******************************************************
ok: [db01]

TASK [Create a new database] *******************************************************
ok: [db01]

TASK [Create database user] ********************************************************
[WARNING]: Option column_case_sensitive is not provided. The default is now false,
so the column's name will be uppercased. The default will be changed to true in
community.mysql 4.0.0.
ok: [db01]

TASK [print dbout variable] ********************************************************
ok: [db01] => {
    "dbout": {
        "attributes": {},
        "changed": false,
        "failed": false,
        "msg": "User unchanged",
        "password_changed": false,
        "user": "current",
        "warnings": [
            "Option column_case_sensitive is not provided. The default is now false, so the column's name will be uppercased. The default will be changed to true in community.mysql 4.0.0."
        ]
    }
}

PLAY RECAP *************************************************************************
db01                       : ok=9    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


```