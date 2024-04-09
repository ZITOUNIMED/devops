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

ubuntu@control:~/vprofile/exercice8$ mkdir group_vars
ubuntu@control:~/vprofile/exercice8$ vim group_vars/all
ubuntu@control:~/vprofile/exercice8$ cat group_vars/all
dbname: sky
dbuser: pilot
dbpass: aircraft
ubuntu@control:~/vprofile/exercice8$ vim db.yaml
ubuntu@control:~/vprofile/exercice8$ cat db.yaml
---
- name: DBserver setup
  hosts: dbservers
  become: yes
    #vars:
    #dbname: electric
    #dbuser: current
    #dbpass: tesla
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
    "msg": "Dbname: sky, dbuser: pilot"
}

TASK [debug] ***********************************************************************
ok: [db01] => {
    "dbpass": "aircraft"
}

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

TASK [print dbout variable] ********************************************************
ok: [db01] => {
    "dbout": {
        "attributes": null,
        "changed": true,
        "failed": false,
        "msg": "User added",
        "password_changed": true,
        "user": "pilot",
        "warnings": [
            "Option column_case_sensitive is not provided. The default is now false, so the column's name will be uppercased. The default will be changed to true in community.mysql 4.0.0."
        ]
    }
}

PLAY RECAP *************************************************************************
db01                       : ok=9    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

### Exercice 9
```
ubuntu@control:~/vprofile/exercice8$ cd ..
ubuntu@control:~/vprofile$ cp -r exercice8 exercice9
ubuntu@control:~/vprofile$ cd exercice9
ubuntu@control:~/vprofile/exercice9$ ls
ansible.cfg  clientkey.pem  db.yaml  group_vars  inventory
ubuntu@control:~/vprofile/exercice9$ rm -rf db.yaml
ubuntu@control:~/vprofile/exercice9$ rm -rf group_vars
ubuntu@control:~/vprofile/exercice9$ ls
ansible.cfg  clientkey.pem  inventory
ubuntu@control:~/vprofile/exercice9$ vim vars_precedence.yaml
ubuntu@control:~/vprofile/exercice9$ cat vars_precedence.yaml
- name: Understanding vars
  hosts: all
  vars:
    USRNM: playuser
    COMM: variable from playbook
  tasks:
    - name: create user
      ansible.builtin.user:
        name: "{{USRNM}}"
        comment: "{{COMM}}"
ubuntu@control:~/vprofile/exercice9$ ansible-playbook vars_precedence.yaml

PLAY [Understanding vars] **********************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]
ok: [web01]
ok: [web02]

TASK [create user] *****************************************************************
changed: [web02]
changed: [db01]
changed: [web01]

PLAY RECAP *************************************************************************
db01                       : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice9$ vim vars_precedence.yaml
ubuntu@control:~/vprofile/exercice9$ cat vars_precedence.yaml
- name: Understanding vars
  hosts: all
  vars:
    USRNM: playuser
    COMM: variable from playbook
  tasks:
    - name: create user
      ansible.builtin.user:
        name: "{{USRNM}}"
        comment: "{{COMM}}"
ubuntu@control:~/vprofile/exercice9$ ansible-playbook vars_precedence.yaml

PLAY [Understanding vars] **********************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]
ok: [web01]
ok: [web02]

TASK [create user] *****************************************************************
changed: [web02]
changed: [db01]
changed: [web01]

PLAY RECAP *************************************************************************
db01                       : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice9$ vim vars_precedence.yaml
ubuntu@control:~/vprofile/exercice9$ cat vars_precedence.yaml
- name: Understanding vars
  hosts: all
  vars:
    USRNM: playuser
    COMM: variable from playbook
  tasks:
    - name: create user
      ansible.builtin.user:
        name: "{{USRNM}}"
        comment: "{{COMM}}"
      register: usrout
    - debug:
        var: usrout
ubuntu@control:~/vprofile/exercice9$ ansible-playbook vars_precedence.yaml

PLAY [Understanding vars] **********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web01]
ok: [web02]
ok: [db01]

TASK [create user] *****************************************************************
ok: [web02]
ok: [web01]
ok: [db01]

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout": {
        "append": false,
        "changed": false,
        "comment": "variable from playbook",
        "failed": false,
        "group": 1001,
        "home": "/home/playuser",
        "move_home": false,
        "name": "playuser",
        "shell": "/bin/bash",
        "state": "present",
        "uid": 1001
    }
}
ok: [web02] => {
    "usrout": {
        "append": false,
        "changed": false,
        "comment": "variable from playbook",
        "failed": false,
        "group": 1001,
        "home": "/home/playuser",
        "move_home": false,
        "name": "playuser",
        "shell": "/bin/bash",
        "state": "present",
        "uid": 1001
    }
}
ok: [db01] => {
    "usrout": {
        "append": false,
        "changed": false,
        "comment": "variable from playbook",
        "failed": false,
        "group": 1001,
        "home": "/home/playuser",
        "move_home": false,
        "name": "playuser",
        "shell": "/bin/bash",
        "state": "present",
        "uid": 1001
    }
}

PLAY RECAP *************************************************************************
db01                       : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice9$ vim vars_precedence.yaml
ubuntu@control:~/vprofile/exercice9$ cat vars_precedence.yaml
- name: Understanding vars
  hosts: all
  vars:
    USRNM: playuser
    COMM: variable from playbook
  tasks:
    - name: create user
      ansible.builtin.user:
        name: "{{USRNM}}"
        comment: "{{COMM}}"
      register: usrout
    - debug:
        var: usrout.name
    - debug:
        var: usrout.comment
ubuntu@control:~/vprofile/exercice9$ vim vars_precedence.yaml
ubuntu@control:~/vprofile/exercice9$ ansible-playbook vars_precedence.yaml

PLAY [Understanding vars] **********************************************************

TASK [Gathering Facts] *************************************************************
ok: [db01]
ok: [web01]
ok: [web02]

TASK [create user] *****************************************************************
ok: [web01]
ok: [db01]
ok: [web02]

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.name": "playuser"
}
ok: [web02] => {
    "usrout.name": "playuser"
}
ok: [db01] => {
    "usrout.name": "playuser"
}

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.comment": "variable from playbook"
}
ok: [web02] => {
    "usrout.comment": "variable from playbook"
}
ok: [db01] => {
    "usrout.comment": "variable from playbook"
}

PLAY RECAP *************************************************************************
db01                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice9$ ls
ansible.cfg  clientkey.pem  inventory  vars_precedence.yaml
ubuntu@control:~/vprofile/exercice9$ mkdir group_vars
ubuntu@control:~/vprofile/exercice9$ vim group_vars/all
ubuntu@control:~/vprofile/exercice9$ cat group_vars/all
USRNM: commonuser
COMM: variable from groupvars_all file
ubuntu@control:~/vprofile/exercice9$ cat vars_precedence.yaml
- name: Understanding vars
  hosts: all
  vars:
    USRNM: playuser
    COMM: variable from playbook
  tasks:
    - name: create user
      ansible.builtin.user:
        name: "{{USRNM}}"
        comment: "{{COMM}}"
      register: usrout
    - debug:
        var: usrout.name
    - debug:
        var: usrout.comment
ubuntu@control:~/vprofile/exercice9$ ansible-playbook vars_precedence.yaml

PLAY [Understanding vars] **********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]
ok: [db01]

TASK [create user] *****************************************************************
ok: [web01]
ok: [db01]
ok: [web02]

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.name": "playuser"
}
ok: [web02] => {
    "usrout.name": "playuser"
}
ok: [db01] => {
    "usrout.name": "playuser"
}

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.comment": "variable from playbook"
}
ok: [web02] => {
    "usrout.comment": "variable from playbook"
}
ok: [db01] => {
    "usrout.comment": "variable from playbook"
}

PLAY RECAP *************************************************************************
db01                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice9$ vim vars_precedence.yaml
ubuntu@control:~/vprofile/exercice9$ cat vars_precedence.yaml
- name: Understanding vars
  hosts: all
    #vars:
    #USRNM: playuser
    #COMM: variable from playbook
  tasks:
    - name: create user
      ansible.builtin.user:
        name: "{{USRNM}}"
        comment: "{{COMM}}"
      register: usrout
    - debug:
        var: usrout.name
    - debug:
        var: usrout.comment
ubuntu@control:~/vprofile/exercice9$ ansible-playbook vars_precedence.yaml

PLAY [Understanding vars] **********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]
ok: [db01]

TASK [create user] *****************************************************************
changed: [web02]
changed: [db01]
changed: [web01]

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.name": "commonuser"
}
ok: [web02] => {
    "usrout.name": "commonuser"
}
ok: [db01] => {
    "usrout.name": "commonuser"
}

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.comment": "variable from groupvars_all file"
}
ok: [web02] => {
    "usrout.comment": "variable from groupvars_all file"
}
ok: [db01] => {
    "usrout.comment": "variable from groupvars_all file"
}

PLAY RECAP *************************************************************************
db01                       : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice9$ vim group_vars/webservers
ubuntu@control:~/vprofile/exercice9$ cat group_vars/webservers
USRNM: webgroup
COMM: variable from group_vars_webservers file
ubuntu@control:~/vprofile/exercice9$ cat group_vars/all
USRNM: commonuser
COMM: variable from groupvars_all file
ubuntu@control:~/vprofile/exercice9$ ansible-playbook vars_precedence.yaml

PLAY [Understanding vars] **********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]
ok: [db01]

TASK [create user] *****************************************************************
ok: [db01]
changed: [web01]
changed: [web02]

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.name": "webgroup"
}
ok: [web02] => {
    "usrout.name": "webgroup"
}
ok: [db01] => {
    "usrout.name": "commonuser"
}

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.comment": "variable from group_vars_webservers file"
}
ok: [web02] => {
    "usrout.comment": "variable from group_vars_webservers file"
}
ok: [db01] => {
    "usrout.comment": "variable from groupvars_all file"
}

PLAY RECAP *************************************************************************
db01                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice9$ ls
ansible.cfg  clientkey.pem  group_vars  inventory  vars_precedence.yaml
ubuntu@control:~/vprofile/exercice9$ mkdir host_vars
ubuntu@control:~/vprofile/exercice9$ vim host_vars/web02
ubuntu@control:~/vprofile/exercice9$ cat host_vars/web02
USRNM: web02user
COMM: variables from host_vars/web02 file
ubuntu@control:~/vprofile/exercice9$ ansible-playbook vars_precedence.yaml

PLAY [Understanding vars] **********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]
ok: [db01]

TASK [create user] *****************************************************************
ok: [web01]
ok: [db01]
changed: [web02]

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.name": "webgroup"
}
ok: [web02] => {
    "usrout.name": "web02user"
}
ok: [db01] => {
    "usrout.name": "commonuser"
}

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.comment": "variable from group_vars_webservers file"
}
ok: [web02] => {
    "usrout.comment": "variables from host_vars/web02 file"
}
ok: [db01] => {
    "usrout.comment": "variable from groupvars_all file"
}

PLAY RECAP *************************************************************************
db01                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

Note: Variables priority order is:
1. playbook variables
2. host variables: host_vars/hostname
3. specific group variables: group_vars/groupname
4. all groups variables: group_vars/all

### Variables through command lines
```
ubuntu@control:~/vprofile/exercice9$ ansible-playbook -e USRNM=cliuser -e COMM=variable_from_cli vars_precedence.yaml

PLAY [Understanding vars] **********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]
ok: [db01]

TASK [create user] *****************************************************************
changed: [web02]
changed: [web01]
changed: [db01]

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.name": "cliuser"
}
ok: [web02] => {
    "usrout.name": "cliuser"
}
ok: [db01] => {
    "usrout.name": "cliuser"
}

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.comment": "variable_from_cli"
}
ok: [web02] => {
    "usrout.comment": "variable_from_cli"
}
ok: [db01] => {
    "usrout.comment": "variable_from_cli"
}

PLAY RECAP *************************************************************************
db01                       : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Command line variables are most priority

#### List variables

```
region:
  - northeast
  - southheast
  - midwest

region: "{{region[0]}}"
```

#### Variable from external file
These variables have playbook priority.
```
- hosts: all
  remote_user: root
  vars:
    favcolor: blue
  var_files:
    - /vars/external_vars.yml
  tasks:
    - name: this is just a plaeholder
      ansible.builtin.command: /bin/echo foo
```

## Fact variables
They are runtime variables they get generated when setup module gets executed.
Examples:
- ansible_os_family
- ansible_processor_cores
- ansible_kernel
- ansible_devices
- ansible_default_ipv4
- ansible_architecture

When we execute a playbook the first task executed is called Gathering Facts for all the hosts.

```
ubuntu@control:~/vprofile/exercice9$ ansible-playbook vars_precedence.yaml

PLAY [Understanding vars] **********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]
ok: [db01]

TASK [create user] *****************************************************************
changed: [web01]
changed: [web02]
changed: [db01]

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.name": "webgroup"
}
ok: [web02] => {
    "usrout.name": "web02user"
}
ok: [db01] => {
    "usrout.name": "commonuser"
}

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.comment": "variable from group_vars_webservers file"
}
ok: [web02] => {
    "usrout.comment": "variables from host_vars/web02 file"
}
ok: [db01] => {
    "usrout.comment": "variable from groupvars_all file"
}

PLAY RECAP *************************************************************************
db01                       : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=4    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

Gathering Facts execute a module called Setup Module. This module collecting information about the host in JSON format. It is only during the runtime and it doesnot use it by default only if we ask.
If we don't use this file we can disable it by adding garther_facts: False in the playbook.

```
ubuntu@control:~/vprofile/exercice9$ vim vars_precedence.yaml
ubuntu@control:~/vprofile/exercice9$ cat vars_precedence.yaml
- name: Understanding vars
  hosts: all
  gather_facts: False
    #vars:
    #USRNM: playuser
    #COMM: variable from playbook
  tasks:
    - name: create user
      ansible.builtin.user:
        name: "{{USRNM}}"
        comment: "{{COMM}}"
      register: usrout
    - debug:
        var: usrout.name
    - debug:
        var: usrout.comment
ubuntu@control:~/vprofile/exercice9$ ansible-playbook vars_precedence.yaml

PLAY [Understanding vars] **********************************************************

TASK [create user] *****************************************************************
ok: [web02]
ok: [web01]
ok: [db01]

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.name": "webgroup"
}
ok: [web02] => {
    "usrout.name": "web02user"
}
ok: [db01] => {
    "usrout.name": "commonuser"
}

TASK [debug] ***********************************************************************
ok: [web01] => {
    "usrout.comment": "variable from group_vars_webservers file"
}
ok: [web02] => {
    "usrout.comment": "variables from host_vars/web02 file"
}
ok: [db01] => {
    "usrout.comment": "variable from groupvars_all file"
}

PLAY RECAP *************************************************************************
db01                       : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

We can execute the gathering facts using ad hoc commands
```
ubuntu@control:~/vprofile/exercice9$ ansible -m setup web01
web01 | SUCCESS => {
    "ansible_facts": {
        "ansible_all_ipv4_addresses": [
            "172.31.25.59"
        ],
        "ansible_all_ipv6_addresses": [
            "fe80::8ff:d4ff:fe71:e7f"
        ],
        "ansible_apparmor": {
            "status": "disabled"
        },
        "ansible_architecture": "x86_64",
        "ansible_bios_date": "08/24/2006",
        "ansible_bios_vendor": "Xen",
        ..........
    }
    ..........
    "ansible_kernel": "5.14.0-229.el9.x86_64",
    ..........
    "ansible_processor_cores": 1,
    "ansible_processor_count": 1,
    "ansible_processor_nproc": 1,
    "ansible_processor_threads_per_core": 1,
    ..........
}
```
### Use Fact variables
```
ubuntu@control:~/vprofile/exercice9$ vim print-facts.yaml
ubuntu@control:~/vprofile/exercice9$ cat print-facts.yaml
- name: Print facts
  hosts: all
  tasks:
    - name: Print OS name
      debug:
        var: ansible_distribution
ubuntu@control:~/vprofile/exercice9$ ansible-playbook print-facts.yaml

PLAY [Print facts] *****************************************************************

TASK [Gathering Facts] *************************************************************
ok: [web01]
ok: [web02]
ok: [db01]

TASK [Print OS name] ***************************************************************
ok: [web01] => {
    "ansible_distribution": "CentOS"
}
ok: [web02] => {
    "ansible_distribution": "CentOS"
}
ok: [db01] => {
    "ansible_distribution": "CentOS"
}

PLAY RECAP *************************************************************************
db01                       : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

* Create a new Ec2 instance called vprofile-web03 using the same keypair client-key.pem and same security group client-sg but with different os ubuntu not centos.
* copy ip private address of the new instance and update inventory to add it.
```
ubuntu@control:~/vprofile/exercice9$ vim inventory
ubuntu@control:~/vprofile/exercice9$ cat inventory
all:
  hosts:
    web01:
      ansible_host: 172.31.25.59
    web02:
      ansible_host: 172.31.16.174
    web03:
      ansible_host: 172.31.43.222
    db01:
      ansible_host: 172.31.27.54

  children:
    webservers:
      hosts:
        web01:
        web02:
        web03:
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



ubuntu@control:~/vprofile/exercice9$ ansible -m ping all
web03 | UNREACHABLE! => {
    "changed": false,
    "msg": "Failed to connect to the host via ssh: Warning: Permanently added '172.31.43.222' (ED25519) to the list of known hosts.\r\nec2-user@172.31.43.222: Permission denied (publickey).",
    "unreachable": true
}
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
ubuntu@control:~/vprofile/exercice9$ vim inventory
ubuntu@control:~/vprofile/exercice9$ cat inventory
all:
  hosts:
    web01:
      ansible_host: 172.31.25.59
    web02:
      ansible_host: 172.31.16.174
    web03:
      ansible_host: 172.31.43.222
      ansible_user: ubuntu
    db01:
      ansible_host: 172.31.27.54

  children:
    webservers:
      hosts:
        web01:
        web02:
        web03:
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



ubuntu@control:~/vprofile/exercice9$ ansible -m ping all
web01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
web02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
web03 | SUCCESS => {
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

ubuntu@control:~/vprofile/exercice9$ ansible-playbook print-facts.yaml

PLAY [Print facts] *****************************************************************

TASK [Gathering Facts] *************************************************************
ok: [web01]
ok: [web02]
ok: [web03]
ok: [db01]

TASK [Print OS name] ***************************************************************
ok: [web01] => {
    "ansible_distribution": "CentOS"
}
ok: [web02] => {
    "ansible_distribution": "CentOS"
}
ok: [web03] => {
    "ansible_distribution": "Ubuntu"
}
ok: [db01] => {
    "ansible_distribution": "CentOS"
}

PLAY RECAP *************************************************************************
db01                       : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web03                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice9$ vim print-facts.yaml
ubuntu@control:~/vprofile/exercice9$ cat print-facts.yaml
- name: Print facts
  hosts: all
    #gather_facts: False
  tasks:
    - name: Print OS name
      debug:
        var: ansible_distribution
    - name: Print selinux mode
      debug:
        var: ansible_selinux.mode
    - name: Print RAM memory
      debug:
        var: ansible_memory_mb.real.free
ubuntu@control:~/vprofile/exercice9$ ansible-playbook print-facts.yaml

PLAY [Print facts] *****************************************************************

TASK [Gathering Facts] *************************************************************
ok: [web01]
ok: [web02]
ok: [web03]
ok: [db01]

TASK [Print OS name] ***************************************************************
ok: [web01] => {
    "ansible_distribution": "CentOS"
}
ok: [web02] => {
    "ansible_distribution": "CentOS"
}
ok: [web03] => {
    "ansible_distribution": "Ubuntu"
}
ok: [db01] => {
    "ansible_distribution": "CentOS"
}

TASK [Print selinux mode] **********************************************************
ok: [web01] => {
    "ansible_selinux.mode": "enforcing"
}
ok: [web02] => {
    "ansible_selinux.mode": "enforcing"
}
ok: [web03] => {
    "ansible_selinux.mode": "VARIABLE IS NOT DEFINED!"
}
ok: [db01] => {
    "ansible_selinux.mode": "enforcing"
}

TASK [Print RAM memory] ************************************************************
ok: [web01] => {
    "ansible_memory_mb.real.free": "247"
}
ok: [web02] => {
    "ansible_memory_mb.real.free": "249"
}
ok: [web03] => {
    "ansible_memory_mb.real.free": "368"
}
ok: [db01] => {
    "ansible_memory_mb.real.free": "104"
}

PLAY RECAP *************************************************************************
db01                       : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web03                      : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```
* Print processor infos 
```
ubuntu@control:~/vprofile/exercice9$ vim print-facts.yaml
ubuntu@control:~/vprofile/exercice9$ cat print-facts.yaml
- name: Print facts
  hosts: all
    #gather_facts: False
  tasks:
    - name: Print OS name
      debug:
        var: ansible_distribution
    - name: Print selinux mode
      debug:
        var: ansible_selinux.mode
    - name: Print RAM memory
      debug:
        var: ansible_memory_mb.real.free
    - name: Print Processor Name
      debug:
        var: ansible_processor[2]
ubuntu@control:~/vprofile/exercice9$ ansible-playbook print-facts.yaml

PLAY [Print facts] *****************************************************************

TASK [Gathering Facts] *************************************************************
ok: [web01]
ok: [web02]
ok: [web03]
ok: [db01]

TASK [Print OS name] ***************************************************************
ok: [web01] => {
    "ansible_distribution": "CentOS"
}
ok: [web02] => {
    "ansible_distribution": "CentOS"
}
ok: [web03] => {
    "ansible_distribution": "Ubuntu"
}
ok: [db01] => {
    "ansible_distribution": "CentOS"
}

TASK [Print selinux mode] **********************************************************
ok: [web01] => {
    "ansible_selinux.mode": "enforcing"
}
ok: [web02] => {
    "ansible_selinux.mode": "enforcing"
}
ok: [web03] => {
    "ansible_selinux.mode": "VARIABLE IS NOT DEFINED!"
}
ok: [db01] => {
    "ansible_selinux.mode": "enforcing"
}

TASK [Print RAM memory] ************************************************************
ok: [web01] => {
    "ansible_memory_mb.real.free": "247"
}
ok: [web02] => {
    "ansible_memory_mb.real.free": "249"
}
ok: [web03] => {
    "ansible_memory_mb.real.free": "368"
}
ok: [db01] => {
    "ansible_memory_mb.real.free": "104"
}

TASK [Print Processor Name] ********************************************************
ok: [web01] => {
    "ansible_processor[2]": "Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz"
}
ok: [web02] => {
    "ansible_processor[2]": "Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz"
}
ok: [web03] => {
    "ansible_processor[2]": "Intel(R) Xeon(R) CPU E5-2676 v3 @ 2.40GHz"
}
ok: [db01] => {
    "ansible_processor[2]": "Intel(R) Xeon(R) CPU E5-2686 v4 @ 2.30GHz"
}

PLAY RECAP *************************************************************************
db01                       : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web01                      : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web02                      : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
web03                      : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```