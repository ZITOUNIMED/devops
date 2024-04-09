# Provisioning Server
In this chapter we will learn how to provision a server.
We will setup these steps:
1. NTP service on multi OS
2. Users & groups
3. Configuration files
4. Decision Making
5. Loops
6. Templates
7. Handlers
8. Ansible Roles

```
ubuntu@control:~/vprofile/exercice9$ cd ..
ubuntu@control:~/vprofile$ cp -r exercice9 exercice10
ubuntu@control:~/vprofile$ ls
exercice1   exercice2  exercice4  exercice6  exercice8
exercice10  exercice3  exercice5  exercice7  exercice9
ubuntu@control:~/vprofile$ cd exercice10
ubuntu@control:~/vprofile/exercice10$ ls
ansible.cfg    group_vars  inventory         vars_precedence.yaml
clientkey.pem  host_vars   print-facts.yaml
ubuntu@control:~/vprofile/exercice10$ rm -rf print-facts.yaml vars_precedence.yaml
ubuntu@control:~/vprofile/exercice10$ ls
ansible.cfg  clientkey.pem  group_vars  host_vars  inventory
ubuntu@control:~/vprofile/exercice10$ ansible -m ping all
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
```

## Work 1: install ntp on all machines
```
ubuntu@control:~/vprofile/exercice10$ vim provisioning.yaml
ubuntu@control:~/vprofile/exercice10$ cat provisioning.yaml
- name: Provisioning servers
  hosts: all
  tasks:
    - name: Install ntp agent on centos
      yum:
        name: chrony
        state: present
      when: ansible_distribution = "CentOS"
    - name: Install ntp agent on ubuntu
      apt:
        name: ntp
        state: present
      when: ansible_distribution = "Ubuntu"

    - name: Start service on centos
      service:
        name: chronyd
        state: started
        enabled: yes
      when: ansible_distribution = "CentOS"

    - name: Start service on ubuntu
      service:
        name: ntp
        state: started
        enabled: yes
      when: ansible_distribution = "Ubuntu"


ubuntu@control:~/vprofile/exercice10$ ansible-playbook provisioning.yaml -C

PLAY [Provisioning servers] ********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]
ok: [web03]
ok: [db01]

TASK [Install ntp agent on centos] *************************************************
fatal: [web01]: FAILED! => {"msg": "The conditional check 'ansible_distribution = \"CentOS\"' failed. The error was: template error while templating string: expected token 'end of statement block', got '='. String: {% if ansible_distribution = \"CentOS\" %} True {% else %} False {% endif %}. expected token 'end of statement block', got '='\n\nThe error appears to be in '/home/ubuntu/vprofile/exercice10/provisioning.yaml': line 4, column 7, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n  tasks:\n    - name: Install ntp agent on centos\n      ^ here\n"}
fatal: [web02]: FAILED! => {"msg": "The conditional check 'ansible_distribution = \"CentOS\"' failed. The error was: template error while templating string: expected token 'end of statement block', got '='. String: {% if ansible_distribution = \"CentOS\" %} True {% else %} False {% endif %}. expected token 'end of statement block', got '='\n\nThe error appears to be in '/home/ubuntu/vprofile/exercice10/provisioning.yaml': line 4, column 7, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n  tasks:\n    - name: Install ntp agent on centos\n      ^ here\n"}
fatal: [web03]: FAILED! => {"msg": "The conditional check 'ansible_distribution = \"CentOS\"' failed. The error was: template error while templating string: expected token 'end of statement block', got '='. String: {% if ansible_distribution = \"CentOS\" %} True {% else %} False {% endif %}. expected token 'end of statement block', got '='\n\nThe error appears to be in '/home/ubuntu/vprofile/exercice10/provisioning.yaml': line 4, column 7, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n  tasks:\n    - name: Install ntp agent on centos\n      ^ here\n"}
fatal: [db01]: FAILED! => {"msg": "The conditional check 'ansible_distribution = \"CentOS\"' failed. The error was: template error while templating string: expected token 'end of statement block', got '='. String: {% if ansible_distribution = \"CentOS\" %} True {% else %} False {% endif %}. expected token 'end of statement block', got '='\n\nThe error appears to be in '/home/ubuntu/vprofile/exercice10/provisioning.yaml': line 4, column 7, but may\nbe elsewhere in the file depending on the exact syntax problem.\n\nThe offending line appears to be:\n\n  tasks:\n    - name: Install ntp agent on centos\n      ^ here\n"}

PLAY RECAP *************************************************************************
db01                       : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
web01                      : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
web02                      : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
web03                      : ok=1    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice10$ vim provisioning.yaml
ubuntu@control:~/vprofile/exercice10$ cat provisioning.yaml
- name: Provisioning servers
  hosts: all
  tasks:
    - name: Install ntp agent on centos
      yum:
        name: chrony
        state: present
      when: ansible_distribution == "CentOS"
    - name: Install ntp agent on ubuntu
      apt:
        name: ntp
        state: present
      when: ansible_distribution == "Ubuntu"

    - name: Start service on centos
      service:
        name: chronyd
        state: started
        enabled: yes
      when: ansible_distribution == "CentOS"

    - name: Start service on ubuntu
      service:
        name: ntp
        state: started
        enabled: yes
      when: ansible_distribution == "Ubuntu"


ubuntu@control:~/vprofile/exercice10$ ansible-playbook provisioning.yaml -C

PLAY [Provisioning servers] ********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]
ok: [web03]
ok: [db01]

TASK [Install ntp agent on centos] *************************************************
skipping: [web03]
ok: [web02]
ok: [web01]
ok: [db01]

TASK [Install ntp agent on ubuntu] *************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
fatal: [web03]: FAILED! => {"changed": false, "msg": "No package matching 'ntp' is available"}

TASK [Start service on centos] *****************************************************
ok: [web02]
ok: [web01]
ok: [db01]

TASK [Start service on ubuntu] *****************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=3    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web01                      : ok=3    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web02                      : ok=3    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web03                      : ok=1    changed=0    unreachable=0    failed=1    skipped=1    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice10$ vim provisioning.yaml
ubuntu@control:~/vprofile/exercice10$ cat provisioning.yaml
- name: Provisioning servers
  hosts: all
  tasks:
    - name: Install ntp agent on centos
      yum:
        name: chrony
        state: present
      when: ansible_distribution == "CentOS"
    - name: Install ntp agent on ubuntu
      apt:
        name: ntp
        state: present
        update_cache: yes
      when: ansible_distribution == "Ubuntu"

    - name: Start service on centos
      service:
        name: chronyd
        state: started
        enabled: yes
      when: ansible_distribution == "CentOS"

    - name: Start service on ubuntu
      service:
        name: ntp
        state: started
        enabled: yes
      when: ansible_distribution == "Ubuntu"


ubuntu@control:~/vprofile/exercice10$ ansible-playbook provisioning.yaml -C

PLAY [Provisioning servers] ********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web01]
ok: [web02]
ok: [web03]
ok: [db01]

TASK [Install ntp agent on centos] *************************************************
skipping: [web03]
ok: [web01]
ok: [web02]
ok: [db01]

TASK [Install ntp agent on ubuntu] *************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
fatal: [web03]: FAILED! => {"changed": false, "msg": "No package matching 'ntp' is available"}

TASK [Start service on centos] *****************************************************
ok: [web02]
ok: [web01]
ok: [db01]

TASK [Start service on ubuntu] *****************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=3    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web01                      : ok=3    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web02                      : ok=3    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web03                      : ok=1    changed=0    unreachable=0    failed=1    skipped=1    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice10$ ansible-playbook provisioning.yaml

PLAY [Provisioning servers] ********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web01]
ok: [web02]
ok: [web03]
ok: [db01]

TASK [Install ntp agent on centos] *************************************************
skipping: [web03]
ok: [web01]
ok: [web02]
ok: [db01]

TASK [Install ntp agent on ubuntu] *************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
changed: [web03]

TASK [Start service on centos] *****************************************************
skipping: [web03]
ok: [web02]
ok: [web01]
ok: [db01]

TASK [Start service on ubuntu] *****************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
ok: [web03]

PLAY RECAP *************************************************************************
db01                       : ok=3    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web01                      : ok=3    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web02                      : ok=3    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web03                      : ok=3    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

```

Conditions:
* simple condition: 
```
when: var1 == value1
```
* multiple conditions form 1: 
```
when: (var1 == val1 and var2 == val2) or (var3 == val3 and var4 == val4)
```
* multiple conditions form 2: chain and conditions

```
when:
  - var1 == val1
  - var2 == val2
```
* multi conditions form 3:
```
when: var3 == val3 and var2 == val2 | var1 >= 23
```

Note: you can use in conditions: and, or, |, !=, ==, >, <, >=, <= 

## Work 2: Loops
```
ubuntu@control:~/vprofile/exercice11$ vim provisioning.yaml
ubuntu@control:~/vprofile/exercice11$ cat provisioning.yaml
- name: Provisioning servers
  hosts: all
  tasks:
    - name: Install requirements on centos
      yum:
        name: "{{item}}"
        state: present
      when: ansible_distribution == "CentOS"
      loop:
        - chrony
        - wget
        - git
        - zip
        - unzip
    - name: Install requirements on ubuntu
      apt:
        name: "{{item}}"
        state: present
        update_cache: yes
      when: ansible_distribution == "Ubuntu"
      loop:
        - ntp
        - wget
        - git
        - zip
        - unzip

    - name: Start service on centos
      service:
        name: chronyd
        state: started
        enabled: yes
      when: ansible_distribution == "CentOS"

    - name: Start service on ubuntu
      service:
        name: ntp
        state: started
        enabled: yes
      when: ansible_distribution == "Ubuntu"


ubuntu@control:~/vprofile/exercice11$ ansible-playbook provisioning.yaml

PLAY [Provisioning servers] ********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web01]
ok: [web02]
ok: [web03]
ok: [db01]

TASK [Install requirements on centos] **********************************************
skipping: [web03] => (item=chrony)
skipping: [web03] => (item=wget)
skipping: [web03] => (item=git)
skipping: [web03] => (item=zip)
skipping: [web03] => (item=unzip)
skipping: [web03]
ok: [web02] => (item=chrony)
ok: [web01] => (item=chrony)
ok: [db01] => (item=chrony)
changed: [web02] => (item=wget)
changed: [db01] => (item=wget)
changed: [web01] => (item=wget)
changed: [db01] => (item=git)
changed: [db01] => (item=zip)
changed: [web02] => (item=git)
ok: [db01] => (item=unzip)
changed: [web01] => (item=git)
changed: [web02] => (item=zip)
changed: [web01] => (item=zip)
ok: [web02] => (item=unzip)
ok: [web01] => (item=unzip)

TASK [Install requirements on ubuntu] **********************************************
skipping: [web01] => (item=ntp)
skipping: [web01] => (item=wget)
skipping: [web01] => (item=git)
skipping: [web02] => (item=ntp)
skipping: [web01] => (item=zip)
skipping: [web01] => (item=unzip)
skipping: [web02] => (item=wget)
skipping: [web02] => (item=git)
skipping: [web01]
skipping: [web02] => (item=zip)
skipping: [web02] => (item=unzip)
skipping: [web02]
skipping: [db01] => (item=ntp)
skipping: [db01] => (item=wget)
skipping: [db01] => (item=git)
skipping: [db01] => (item=zip)
skipping: [db01] => (item=unzip)
skipping: [db01]
ok: [web03] => (item=ntp)
ok: [web03] => (item=wget)
ok: [web03] => (item=git)
changed: [web03] => (item=zip)
ok: [web03] => (item=unzip)

TASK [Start service on centos] *****************************************************
skipping: [web03]
ok: [web02]
ok: [web01]
ok: [db01]

TASK [Start service on ubuntu] *****************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
ok: [web03]

PLAY RECAP *************************************************************************
db01                       : ok=3    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web01                      : ok=3    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web02                      : ok=3    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web03                      : ok=3    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

```

* Different form of loops:
The basic one is:
```
loop:
  - example1
  - example2
```
Other form
```
with_items:
  - 1
  - [2,3]
  - 4
```
Or from a variable list
```
loop: "{{somelist}}"
```

* Loop items can be dictionary
```
- name: test
  ansible.builtin.users:
    name: "{{item.name}}"
    state: present
    groups: "{{item.groups}}"
  loop:
    - { name: 'user1', groups: 'group1'}
    - { name: 'user2', groups: 'group2'}
```

## Work 3: Files modules
Search on google for Files modules
```
ubuntu@control:~/vprofile/exercice12$ vim provisioning.yaml
ubuntu@control:~/vprofile/exercice12$ cat provisioning.yaml
- name: Provisioning servers
  hosts: all
  tasks:
    - name: Install requirements on centos
      yum:
        name: "{{item}}"
        state: present
      when: ansible_distribution == "CentOS"
      loop:
        - chrony
        - wget
        - git
        - zip
        - unzip
    - name: Install requirements on ubuntu
      apt:
        name: "{{item}}"
        state: present
        update_cache: yes
      when: ansible_distribution == "Ubuntu"
      loop:
        - ntp
        - wget
        - git
        - zip
        - unzip

    - name: Start service on centos
      service:
        name: chronyd
        state: started
        enabled: yes
      when: ansible_distribution == "CentOS"

    - name: Start service on ubuntu
      service:
        name: ntp
        state: started
        enabled: yes
      when: ansible_distribution == "Ubuntu"

    - name: Banner file
      copy:
        content: '# This server is managed by ansible. No manual changes please.'
        dest: /etc/motd
ubuntu@control:~/vprofile/exercice12$ ansible-playbook provisioning.yaml

PLAY [Provisioning servers] ********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web01]
ok: [web02]
ok: [web03]
ok: [db01]

TASK [Install requirements on centos] **********************************************
skipping: [web03] => (item=chrony)
skipping: [web03] => (item=wget)
skipping: [web03] => (item=git)
skipping: [web03] => (item=zip)
skipping: [web03] => (item=unzip)
skipping: [web03]
ok: [web02] => (item=chrony)
ok: [web01] => (item=chrony)
ok: [db01] => (item=chrony)
ok: [web02] => (item=wget)
ok: [web01] => (item=wget)
ok: [db01] => (item=wget)
ok: [web01] => (item=git)
ok: [web02] => (item=git)
ok: [db01] => (item=git)
ok: [web02] => (item=zip)
ok: [web01] => (item=zip)
ok: [db01] => (item=zip)
ok: [web01] => (item=unzip)
ok: [web02] => (item=unzip)
ok: [db01] => (item=unzip)

TASK [Install requirements on ubuntu] **********************************************
skipping: [web01] => (item=ntp)
skipping: [web01] => (item=wget)
skipping: [web01] => (item=git)
skipping: [web02] => (item=ntp)
skipping: [web02] => (item=wget)
skipping: [web01] => (item=zip)
skipping: [web01] => (item=unzip)
skipping: [web02] => (item=git)
skipping: [web01]
skipping: [web02] => (item=zip)
skipping: [web02] => (item=unzip)
skipping: [web02]
skipping: [db01] => (item=ntp)
skipping: [db01] => (item=wget)
skipping: [db01] => (item=git)
skipping: [db01] => (item=zip)
skipping: [db01] => (item=unzip)
skipping: [db01]
ok: [web03] => (item=ntp)
ok: [web03] => (item=wget)
ok: [web03] => (item=git)
ok: [web03] => (item=zip)
ok: [web03] => (item=unzip)

TASK [Start service on centos] *****************************************************
skipping: [web03]
ok: [web02]
ok: [web01]
ok: [db01]

TASK [Start service on ubuntu] *****************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
ok: [web03]

TASK [Banner file] *****************************************************************
changed: [web03]
changed: [web02]
changed: [web01]
changed: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web01                      : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web02                      : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0
web03                      : ok=4    changed=1    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

ubuntu@control:~/vprofile/exercice12$ ls
ansible.cfg  clientkey.pem  group_vars  host_vars  inventory  provisioning.yaml
ubuntu@control:~/vprofile/exercice12$ cat inventory
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

ubuntu@control:~/vprofile/exercice12$ ssh -i clientkey.pem ec2-user@172.31.27.54
# This server is managed by ansible. No manual changes please.
Last login: Tue Apr  9 13:12:24 2024 from 172.31.25.35
[ec2-user@ip-172-31-27-54 ~]$ sudo -i

```
* change chrony config file
```
[root@ip-172-31-27-54 ~]# cat /etc/chrony.conf
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (https://www.pool.ntp.org/join.html).
pool 2.centos.pool.ntp.org iburst

# Use NTP servers from DHCP.
sourcedir /run/chrony-dhcp

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
makestep 1.0 3

# Enable kernel synchronization of the real-time clock (RTC).
rtcsync

# Enable hardware timestamping on all interfaces that support it.
#hwtimestamp *

# Increase the minimum number of selectable sources required to adjust
# the system clock.
#minsources 2

# Allow NTP client access from local network.
#allow 192.168.0.0/16

# Serve time even if not synchronized to a time source.
#local stratum 10

# Require authentication (nts or key option) for all NTP sources.
#authselectmode require

# Specify file containing keys for NTP authentication.
keyfile /etc/chrony.keys

# Save NTS keys and cookies.
ntsdumpdir /var/lib/chrony

# Insert/delete leap seconds by slewing instead of stepping.
#leapsecmode slew

# Get TAI-UTC offset and leap seconds from the system tz database.
leapsectz right/UTC

# Specify directory for log files.
logdir /var/log/chrony

# Select which information is logged.
#log measurements statistics tracking

# Amazon Time Sync Service
server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4
```
* Copy the content of chrony.conf file and paste it into a a new conf file under ansible control machine as a template
```
[root@ip-172-31-27-54 ~]# exit
logout
[ec2-user@ip-172-31-27-54 ~]$ exit
logout
Connection to 172.31.27.54 closed.
ubuntu@control:~/vprofile/exercice12$ ls
ansible.cfg  clientkey.pem  group_vars  host_vars  inventory  provisioning.yaml
ubuntu@control:~/vprofile/exercice12$ mkdir templates
ubuntu@control:~/vprofile/exercice12$ vim templates/ntpconf_centos
ubuntu@control:~/vprofile/exercice12$ vim templates/ntpconf_centos
ubuntu@control:~/vprofile/exercice12$ cat templates/ntpconf_centos
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (https://www.pool.ntp.org/join.html).
pool 2.centos.pool.ntp.org iburst

# Use NTP servers from DHCP.
sourcedir /run/chrony-dhcp

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
makestep 1.0 3

# Enable kernel synchronization of the real-time clock (RTC).
rtcsync

# Enable hardware timestamping on all interfaces that support it.
#hwtimestamp *

# Increase the minimum number of selectable sources required to adjust
# the system clock.
#minsources 2

# Allow NTP client access from local network.
#allow 192.168.0.0/16

# Serve time even if not synchronized to a time source.
#local stratum 10

# Require authentication (nts or key option) for all NTP sources.
#authselectmode require

# Specify file containing keys for NTP authentication.
keyfile /etc/chrony.keys

# Save NTS keys and cookies.
ntsdumpdir /var/lib/chrony

# Insert/delete leap seconds by slewing instead of stepping.
#leapsecmode slew

# Get TAI-UTC offset and leap seconds from the system tz database.
leapsectz right/UTC

# Specify directory for log files.
logdir /var/log/chrony

# Select which information is logged.
#log measurements statistics tracking

# Amazon Time Sync Service
server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4
```
* Do the same work for ubuntu: ssh into ubuntu and copy ntp conf file and paste its content into a template file under ansible control macine.
```
ubuntu@control:~/vprofile/exercice12$ ls
ansible.cfg    group_vars  inventory          templates
clientkey.pem  host_vars   provisioning.yaml
ubuntu@control:~/vprofile/exercice12$ cat inventory
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



ubuntu@control:~/vprofile/exercice12$ ssh -i clientkey.pem ubuntu@172.31.43.222
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 6.5.0-1014-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

  System information as of Tue Apr  9 13:28:31 UTC 2024

  System load:  0.0               Processes:             96
  Usage of /:   23.2% of 7.57GB   Users logged in:       0
  Memory usage: 22%               IPv4 address for eth0: 172.31.43.222
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

46 updates can be applied immediately.
30 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


# This server is managed by ansible. No manual changes please.
Last login: Tue Apr  9 13:12:24 2024 from 172.31.25.35
ubuntu@ip-172-31-43-222:~$ sudo -i
root@ip-172-31-43-222:~# cat /etc/ntp.conf
# /etc/ntp.conf, configuration for ntpd; see ntp.conf(5) for help

driftfile /var/lib/ntp/ntp.drift

# Leap seconds definition provided by tzdata
leapfile /usr/share/zoneinfo/leap-seconds.list

# Enable this if you want statistics to be logged.
#statsdir /var/log/ntpstats/

statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable

# Specify one or more NTP servers.

# Use servers from the NTP Pool Project. Approved by Ubuntu Technical Board
# on 2011-02-08 (LP: #104525). See http://www.pool.ntp.org/join.html for
# more information.
pool 0.ubuntu.pool.ntp.org iburst
pool 1.ubuntu.pool.ntp.org iburst
pool 2.ubuntu.pool.ntp.org iburst
pool 3.ubuntu.pool.ntp.org iburst

# Use Ubuntu's ntp server as a fallback.
pool ntp.ubuntu.com

# Access control configuration; see /usr/share/doc/ntp-doc/html/accopt.html for
# details.  The web page <http://support.ntp.org/bin/view/Support/AccessRestrictions>
# might also be helpful.
#
# Note that "restrict" applies to both servers and clients, so a configuration
# that might be intended to block requests from certain clients could also end
# up blocking replies from your own upstream servers.

# By default, exchange time with everybody, but don't allow configuration.
restrict -4 default kod notrap nomodify nopeer noquery limited
restrict -6 default kod notrap nomodify nopeer noquery limited

# Local users may interrogate the ntp server more closely.
restrict 127.0.0.1
restrict ::1

# Needed for adding pool entries
restrict source notrap nomodify noquery

# Clients from this (example!) subnet have unlimited access, but only if
# cryptographically authenticated.
#restrict 192.168.123.0 mask 255.255.255.0 notrust


# If you want to provide time to your local subnet, change the next line.
# (Again, the address is an example only.)
#broadcast 192.168.123.255

# If you want to listen to time broadcasts on your local subnet, de-comment the
# next lines.  Please do this only if you trust everybody on the network!
#disable auth
#broadcastclient
root@ip-172-31-43-222:~# exit
logout
ubuntu@ip-172-31-43-222:~$ exit
logout
Connection to 172.31.43.222 closed.
ubuntu@control:~/vprofile/exercice12$ vim templates/ntpconf_ubuntu
ubuntu@control:~/vprofile/exercice12$ cat templates/ntpconf_ubuntu

# /etc/ntp.conf, configuration for ntpd; see ntp.conf(5) for help

driftfile /var/lib/ntp/ntp.drift

# Leap seconds definition provided by tzdata
leapfile /usr/share/zoneinfo/leap-seconds.list

# Enable this if you want statistics to be logged.
#statsdir /var/log/ntpstats/

statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable

# Specify one or more NTP servers.

# Use servers from the NTP Pool Project. Approved by Ubuntu Technical Board
# on 2011-02-08 (LP: #104525). See http://www.pool.ntp.org/join.html for
# more information.
pool 0.ubuntu.pool.ntp.org iburst
pool 1.ubuntu.pool.ntp.org iburst
pool 2.ubuntu.pool.ntp.org iburst
pool 3.ubuntu.pool.ntp.org iburst

# Use Ubuntu's ntp server as a fallback.
pool ntp.ubuntu.com

# Access control configuration; see /usr/share/doc/ntp-doc/html/accopt.html for
# details.  The web page <http://support.ntp.org/bin/view/Support/AccessRestrictions>
# might also be helpful.
#
# Note that "restrict" applies to both servers and clients, so a configuration
# that might be intended to block requests from certain clients could also end
# up blocking replies from your own upstream servers.

# By default, exchange time with everybody, but don't allow configuration.
restrict -4 default kod notrap nomodify nopeer noquery limited
restrict -6 default kod notrap nomodify nopeer noquery limited

# Local users may interrogate the ntp server more closely.
restrict 127.0.0.1
restrict ::1

# Needed for adding pool entries
restrict source notrap nomodify noquery

# Clients from this (example!) subnet have unlimited access, but only if
# cryptographically authenticated.
#restrict 192.168.123.0 mask 255.255.255.0 notrust


# If you want to provide time to your local subnet, change the next line.
# (Again, the address is an example only.)
#broadcast 192.168.123.255

# If you want to listen to time broadcasts on your local subnet, de-comment the
# next lines.  Please do this only if you trust everybody on the network!
#disable auth
#broadcastclient
```
* Update the playbook to use templates
```
ubuntu@control:~/vprofile/exercice12$ vim provisioning.yaml
ubuntu@control:~/vprofile/exercice12$ cat provisioning.yaml
- name: Provisioning servers
  hosts: all
  tasks:
    - name: Install requirements on centos
      yum:
        name: "{{item}}"
        state: present
      when: ansible_distribution == "CentOS"
      loop:
        - chrony
        - wget
        - git
        - zip
        - unzip
    - name: Install requirements on ubuntu
      apt:
        name: "{{item}}"
        state: present
        update_cache: yes
      when: ansible_distribution == "Ubuntu"
      loop:
        - ntp
        - wget
        - git
        - zip
        - unzip

    - name: Start service on centos
      service:
        name: chronyd
        state: started
        enabled: yes
      when: ansible_distribution == "CentOS"

    - name: Start service on ubuntu
      service:
        name: ntp
        state: started
        enabled: yes
      when: ansible_distribution == "Ubuntu"

    - name: Banner file
      copy:
        content: '# This server is managed by ansible. No manual changes please.'
        dest: /etc/motd

    - name: Deploy ntp agent conf on centos
      template:
        src: templates/ntpconf_centos
        dest: /etc/chrony.conf
        backup: yes
      when: ansible_distribution == "CentOS"

    - name: Deploy ntp agent conf on ubuntu
      template:
        src: templates/ntpconf_ubuntu
        dest: /etc/ntp.conf
        backup: yes
      when: ansible_distribution == "Ubuntu"

    - name: Restart service on centos
      service:
        name: chronyd
        state: restarted
        enabled: yes
      when: ansible_distribution == "CentOS"

    - name: Restart service on ubuntu
      service:
        name: ntp
        state: restarted
        enabled: yes
      when: ansible_distribution == "Ubuntu"

ubuntu@control:~/vprofile/exercice12$ ansible-playbook provisioning.yaml

PLAY [Provisioning servers] ********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]
ok: [web03]
ok: [db01]

TASK [Install requirements on centos] **********************************************
skipping: [web03] => (item=chrony)
skipping: [web03] => (item=wget)
skipping: [web03] => (item=git)
skipping: [web03] => (item=zip)
skipping: [web03] => (item=unzip)
skipping: [web03]
ok: [web01] => (item=chrony)
ok: [web02] => (item=chrony)
ok: [db01] => (item=chrony)
ok: [web01] => (item=wget)
ok: [web02] => (item=wget)
ok: [db01] => (item=wget)
ok: [web01] => (item=git)
ok: [web02] => (item=git)
ok: [db01] => (item=git)
ok: [web02] => (item=zip)
ok: [web01] => (item=zip)
ok: [db01] => (item=zip)
ok: [web02] => (item=unzip)
ok: [web01] => (item=unzip)
ok: [db01] => (item=unzip)

TASK [Install requirements on ubuntu] **********************************************
skipping: [web01] => (item=ntp)
skipping: [web01] => (item=wget)
skipping: [web01] => (item=git)
skipping: [web02] => (item=ntp)
skipping: [web01] => (item=zip)
skipping: [web02] => (item=wget)
skipping: [web01] => (item=unzip)
skipping: [web02] => (item=git)
skipping: [web01]
skipping: [web02] => (item=zip)
skipping: [web02] => (item=unzip)
skipping: [web02]
skipping: [db01] => (item=ntp)
skipping: [db01] => (item=wget)
skipping: [db01] => (item=git)
skipping: [db01] => (item=zip)
skipping: [db01] => (item=unzip)
skipping: [db01]
ok: [web03] => (item=ntp)
ok: [web03] => (item=wget)
ok: [web03] => (item=git)
ok: [web03] => (item=zip)
ok: [web03] => (item=unzip)

TASK [Start service on centos] *****************************************************
skipping: [web03]
ok: [web01]
ok: [web02]
ok: [db01]

TASK [Start service on ubuntu] *****************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
ok: [web03]

TASK [Banner file] *****************************************************************
ok: [web03]
ok: [web02]
ok: [web01]
ok: [db01]

TASK [Deploy ntp agent conf on centos] *********************************************
skipping: [web03]
ok: [web02]
ok: [web01]
ok: [db01]

TASK [Deploy ntp agent conf on ubuntu] *********************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
changed: [web03]

TASK [Restart service on centos] ***************************************************
skipping: [web03]
changed: [web01]
changed: [web02]
changed: [db01]

TASK [Restart service on ubuntu] ***************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
changed: [web03]

PLAY RECAP *************************************************************************
db01                       : ok=6    changed=1    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
web01                      : ok=6    changed=1    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
web02                      : ok=6    changed=1    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
web03                      : ok=6    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

```

* Use variables in templates

```
ubuntu@control:~/vprofile/exercice12$ vim templates/ntpconf_centos
ubuntu@control:~/vprofile/exercice12$ cat templates/ntpconf_centos
# Use public servers from the pool.ntp.org project.
# Please consider joining the pool (https://www.pool.ntp.org/join.html).
pool "{{ntp0}}" iburst
pool "{{ntp1}}" iburst
pool "{{ntp2}}" iburst
pool "{{ntp3}}" iburst

# Use NTP servers from DHCP.
sourcedir /run/chrony-dhcp

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
makestep 1.0 3

# Enable kernel synchronization of the real-time clock (RTC).
rtcsync

# Enable hardware timestamping on all interfaces that support it.
#hwtimestamp *

# Increase the minimum number of selectable sources required to adjust
# the system clock.
#minsources 2

# Allow NTP client access from local network.
#allow 192.168.0.0/16

# Serve time even if not synchronized to a time source.
#local stratum 10

# Require authentication (nts or key option) for all NTP sources.
#authselectmode require

# Specify file containing keys for NTP authentication.
keyfile /etc/chrony.keys

# Save NTS keys and cookies.
ntsdumpdir /var/lib/chrony

# Insert/delete leap seconds by slewing instead of stepping.
#leapsecmode slew

# Get TAI-UTC offset and leap seconds from the system tz database.
leapsectz right/UTC

# Specify directory for log files.
logdir /var/log/chrony

# Select which information is logged.
#log measurements statistics tracking

# Amazon Time Sync Service
server 169.254.169.123 prefer iburst minpoll 4 maxpoll 4
ubuntu@control:~/vprofile/exercice12$ vim templates/ntpconf_ubuntu
ubuntu@control:~/vprofile/exercice12$ cat templates/ntpconf_ubuntu

# /etc/ntp.conf, configuration for ntpd; see ntp.conf(5) for help

driftfile /var/lib/ntp/ntp.drift

# Leap seconds definition provided by tzdata
leapfile /usr/share/zoneinfo/leap-seconds.list

# Enable this if you want statistics to be logged.
#statsdir /var/log/ntpstats/

statistics loopstats peerstats clockstats
filegen loopstats file loopstats type day enable
filegen peerstats file peerstats type day enable
filegen clockstats file clockstats type day enable

# Specify one or more NTP servers.

# Use servers from the NTP Pool Project. Approved by Ubuntu Technical Board
# on 2011-02-08 (LP: #104525). See http://www.pool.ntp.org/join.html for
# more information.
pool "{{ntp0}}" iburst
pool "{{ntp1}}" iburst
pool "{{ntp2}}" iburst
pool "{{ntp3}}" iburst

# Use Ubuntu's ntp server as a fallback.
pool ntp.ubuntu.com

# Access control configuration; see /usr/share/doc/ntp-doc/html/accopt.html for
# details.  The web page <http://support.ntp.org/bin/view/Support/AccessRestrictions>
# might also be helpful.
#
# Note that "restrict" applies to both servers and clients, so a configuration
# that might be intended to block requests from certain clients could also end
# up blocking replies from your own upstream servers.

# By default, exchange time with everybody, but don't allow configuration.
restrict -4 default kod notrap nomodify nopeer noquery limited
restrict -6 default kod notrap nomodify nopeer noquery limited

# Local users may interrogate the ntp server more closely.
restrict 127.0.0.1
restrict ::1

# Needed for adding pool entries
restrict source notrap nomodify noquery

# Clients from this (example!) subnet have unlimited access, but only if
# cryptographically authenticated.
#restrict 192.168.123.0 mask 255.255.255.0 notrust


# If you want to provide time to your local subnet, change the next line.
# (Again, the address is an example only.)
#broadcast 192.168.123.255

# If you want to listen to time broadcasts on your local subnet, de-comment the
# next lines.  Please do this only if you trust everybody on the network!
#disable auth
#broadcastclient
ubuntu@control:~/vprofile/exercice12$ vim provisioning
ubuntu@control:~/vprofile/exercice12$ vim provisioning.yaml
ubuntu@control:~/vprofile/exercice12$ ansible-playbook provisioning.yaml

PLAY [Provisioning servers] ********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]
ok: [web03]
ok: [db01]

TASK [Install requirements on centos] **********************************************
skipping: [web03] => (item=chrony)
skipping: [web03] => (item=wget)
skipping: [web03]
ok: [web02] => (item=chrony)
ok: [web01] => (item=chrony)
ok: [db01] => (item=chrony)
ok: [web02] => (item=wget)
ok: [web01] => (item=wget)
ok: [db01] => (item=wget)

TASK [Install requirements on ubuntu] **********************************************
skipping: [web01] => (item=ntp)
skipping: [web01] => (item=wget)
skipping: [web02] => (item=ntp)
skipping: [web02] => (item=wget)
skipping: [web01]
skipping: [web02]
skipping: [db01] => (item=ntp)
skipping: [db01] => (item=wget)
skipping: [db01]
ok: [web03] => (item=ntp)
ok: [web03] => (item=wget)

TASK [Start service on centos] *****************************************************
skipping: [web03]
ok: [web01]
ok: [web02]
ok: [db01]

TASK [Start service on ubuntu] *****************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
ok: [web03]

TASK [Banner file] *****************************************************************
ok: [web03]
ok: [web01]
ok: [web02]
ok: [db01]

TASK [Deploy ntp agent conf on centos] *********************************************
skipping: [web03]
changed: [web02]
changed: [web01]
changed: [db01]

TASK [Deploy ntp agent conf on ubuntu] *********************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
changed: [web03]

TASK [Restart service on centos] ***************************************************
skipping: [web03]
changed: [web02]
changed: [web01]
changed: [db01]

TASK [Restart service on ubuntu] ***************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
changed: [web03]

PLAY RECAP *************************************************************************
db01                       : ok=6    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
web01                      : ok=6    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
web02                      : ok=6    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
web03                      : ok=6    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

```
* Create a folder 
```
ubuntu@control:~/vprofile/exercice12$ vim provisioning.yaml
ubuntu@control:~/vprofile/exercice12$ cat provisioning.yaml
- name: Provisioning servers
  hosts: all
  tasks:
    - name: Install requirements on centos
      yum:
        name: "{{item}}"
        state: present
      when: ansible_distribution == "CentOS"
      loop:
        - chrony
        - wget
    - name: Install requirements on ubuntu
      apt:
        name: "{{item}}"
        state: present
        update_cache: yes
      when: ansible_distribution == "Ubuntu"
      loop:
        - ntp
        - wget

    - name: Start service on centos
      service:
        name: chronyd
        state: started
        enabled: yes
      when: ansible_distribution == "CentOS"

    - name: Start service on ubuntu
      service:
        name: ntp
        state: started
        enabled: yes
      when: ansible_distribution == "Ubuntu"

    - name: Banner file
      copy:
        content: '# This server is managed by ansible. No manual changes please.'
        dest: /etc/motd

    - name: Deploy ntp agent conf on centos
      template:
        src: templates/ntpconf_centos
        dest: /etc/chrony.conf
        backup: yes
      when: ansible_distribution == "CentOS"

    - name: Deploy ntp agent conf on ubuntu
      template:
        src: templates/ntpconf_ubuntu
        dest: /etc/ntp.conf
        backup: yes
      when: ansible_distribution == "Ubuntu"

    - name: Restart service on centos
      service:
        name: chronyd
        state: restarted
        enabled: yes
      when: ansible_distribution == "CentOS"

    - name: Restart service on ubuntu
      service:
        name: ntp
        state: restarted
        enabled: yes
      when: ansible_distribution == "Ubuntu"

    - name: Create a folder
      file:
        path: /opt/test21
        state: directory
ubuntu@control:~/vprofile/exercice12$ ansible-playbook provisioning.yaml

PLAY [Provisioning servers] ********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web01]
ok: [web02]
ok: [web03]
ok: [db01]

TASK [Install requirements on centos] **********************************************
skipping: [web03] => (item=chrony)
skipping: [web03] => (item=wget)
skipping: [web03]
ok: [web02] => (item=chrony)
ok: [web01] => (item=chrony)
ok: [db01] => (item=chrony)
ok: [web02] => (item=wget)
ok: [web01] => (item=wget)
ok: [db01] => (item=wget)

TASK [Install requirements on ubuntu] **********************************************
skipping: [web01] => (item=ntp)
skipping: [web01] => (item=wget)
skipping: [web01]
skipping: [web02] => (item=ntp)
skipping: [web02] => (item=wget)
skipping: [web02]
skipping: [db01] => (item=ntp)
skipping: [db01] => (item=wget)
skipping: [db01]
ok: [web03] => (item=ntp)
ok: [web03] => (item=wget)

TASK [Start service on centos] *****************************************************
skipping: [web03]
ok: [web01]
ok: [db01]
ok: [web02]

TASK [Start service on ubuntu] *****************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
ok: [web03]

TASK [Banner file] *****************************************************************
ok: [web03]
ok: [web02]
ok: [web01]
ok: [db01]

TASK [Deploy ntp agent conf on centos] *********************************************
skipping: [web03]
ok: [web01]
ok: [web02]
ok: [db01]

TASK [Deploy ntp agent conf on ubuntu] *********************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
ok: [web03]

TASK [Restart service on centos] ***************************************************
skipping: [web03]
changed: [web01]
changed: [web02]
changed: [db01]

TASK [Restart service on ubuntu] ***************************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
changed: [web03]

TASK [Create a folder] *************************************************************
changed: [web03]
changed: [web01]
changed: [web02]
changed: [db01]

PLAY RECAP *************************************************************************
db01                       : ok=7    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
web01                      : ok=7    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
web02                      : ok=7    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0
web03                      : ok=7    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

```