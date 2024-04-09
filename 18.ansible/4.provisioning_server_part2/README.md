# Handlers
Handlers are like tasks but the only difference is they are not executed only if the are notified from other tasks.

```
ubuntu@control:~/vprofile/exercice13$ vim provisioning.yaml
ubuntu@control:~/vprofile/exercice13$ cat provisioning.yaml
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

    - name: Create a folder
      file:
        path: /opt/test21
        state: directory

    - name: Deploy ntp agent conf on centos
      template:
        src: templates/ntpconf_centos
        dest: /etc/chrony.conf
        backup: yes
      when: ansible_distribution == "CentOS"
      notify:
        - Restart service on centos

    - name: Deploy ntp agent conf on ubuntu
      template:
        src: templates/ntpconf_ubuntu
        dest: /etc/ntp.conf
        backup: yes
      when: ansible_distribution == "Ubuntu"
      notify:
        - Restart service on ubuntu

  handlers:
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

ubuntu@control:~/vprofile/exercice13$ ansible-playbook provisioning.yaml

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
ok: [web01] => (item=chrony)
ok: [web02] => (item=chrony)
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
ok: [web02]
ok: [web01]
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

TASK [Create a folder] *************************************************************
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
ok: [web03]

```

# Ansible roles
* roles are used to simply playbook
* playbook content
- global declaration
- variables
- tasks
- files
- templates
- handlers
...

## Example of roles:
* MySQL
* Tomcat
* Build Server
* Common Settings Post install steps
* Wordpress
* Apache

## Roles Directory Structure
see screenshot ansible-roles-directory-structure.png
note: to replace trainning spaces in the biginning of vim file use [echap] :%s/< number of spaces >// and [enter]
```
ubuntu@control:~/vprofile/exercice14$ vim provisioning.yaml
ubuntu@control:~/vprofile/exercice14$ cat provisioning.yaml
- name: Provisioning servers
  hosts: all
  vars:
    dir1: /opt/dir22
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

    - name: Create a folder
      file:
        path: "{{dir1}}"
        state: directory

    - name: Deploy ntp agent conf on centos
      template:
        src: templates/ntpconf_centos
        dest: /etc/chrony.conf
        backup: yes
      when: ansible_distribution == "CentOS"
      notify:
        - Restart service on centos

    - name: Deploy ntp agent conf on ubuntu
      template:
        src: templates/ntpconf_ubuntu
        dest: /etc/ntp.conf
        backup: yes
      when: ansible_distribution == "Ubuntu"
      notify:
        - Restart service on ubuntu

    - name: Dump file
      copy:
        src: files/myfile.txt
        dest: /tmp/myfile.txt
  handlers:
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

ubuntu@control:~/vprofile/exercice14$ mkdir files
ubuntu@control:~/vprofile/exercice14$ vim files/myfile.txt
ubuntu@control:~/vprofile/exercice14$ cat files/myfile.txt
ubuntu@control:~/vprofile/exercice14$ ansible-playbook provisioning.yaml

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
ok: [web01] => (item=chrony)
ok: [web02] => (item=chrony)
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
ok: [web02]
ok: [web01]
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

TASK [Create a folder] *************************************************************
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
ok: [web03]

TASK [Dump file] *******************************************************************
changed: [web03]
changed: [web02]
changed: [web01]
changed: [db01]

```

* Install tree on ansible control machine to better see the project folder structure
```
ubuntu@control:~/vprofile/exercice14$ sudo apt install tree -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following NEW packages will be installed:
....
$ ubuntu@control:~/vprofile/exercice14$ cd ..
ubuntu@control:~/vprofile$ tree exercice14
exercice14
├── ansible.cfg
├── clientkey.pem
├── files
│   └── myfile.txt
├── group_vars
│   ├── all
│   └── webservers
├── host_vars
│   └── web02
├── inventory
├── provisioning.yaml
└── templates
    ├── ntpconf_centos
    └── ntpconf_ubuntu

4 directories, 10 files

```
* Create role
```
ubuntu@control:~/vprofile/exercice14$ mkdir roles
ubuntu@control:~/vprofile/exercice14$ cd roles
ubuntu@control:~/vprofile/exercice14/roles$ ansible-galaxy init post-install
- Role post-install was created successfully
ubuntu@control:~/vprofile/exercice14/roles$ ls
post-install
ubuntu@control:~/vprofile/exercice14/roles$ tree
.
└── post-install
    ├── README.md
    ├── defaults
    │   └── main.yml
    ├── files
    ├── handlers
    │   └── main.yml
    ├── meta
    │   └── main.yml
    ├── tasks
    │   └── main.yml
    ├── templates
    ├── tests
    │   ├── inventory
    │   └── test.yml
    └── vars
        └── main.yml

9 directories, 8 files
ubuntu@control:~/vprofile/exercice14/roles$ cd ..
ubuntu@control:~/vprofile/exercice14$ cat group_vars/all
USRNM: commonuser
COMM: variable from groupvars_all file
ntp0: 0.fr.pool.ntp.org
ntp1: 1.fr.pool.ntp.org
ntp2: 2.fr.pool.ntp.org
ntp3: 3.fr.pool.ntp.org
dir1: /opt/dir22
ubuntu@control:~/vprofile/exercice14$ rm -rf group_vars host_vars
ubuntu@control:~/vprofile/exercice14$ ls
ansible.cfg  clientkey.pem  files  inventory  provisioning.yaml  roles  templates
ubuntu@control:~/vprofile/exercice14$ cp files/* roles/post-install/files/
ubuntu@control:~/vprofile/exercice14$ cp templates/* roles/post-install/templates/
ubuntu@control:~/vprofile/exercice14$ cat provisioning.yaml
- name: Provisioning servers
  hosts: all
  vars:
    dir1: /opt/dir22
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

    - name: Create a folder
      file:
        path: "{{dir1}}"
        state: directory

    - name: Deploy ntp agent conf on centos
      template:
        src: templates/ntpconf_centos
        dest: /etc/chrony.conf
        backup: yes
      when: ansible_distribution == "CentOS"
      notify:
        - Restart service on centos

    - name: Deploy ntp agent conf on ubuntu
      template:
        src: templates/ntpconf_ubuntu
        dest: /etc/ntp.conf
        backup: yes
      when: ansible_distribution == "Ubuntu"
      notify:
        - Restart service on ubuntu

    - name: Dump file
      copy:
        src: files/myfile.txt
        dest: /tmp/myfile.txt
  handlers:
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

ubuntu@control:~/vprofile/exercice14$ vim roles/post-install/handlers/main.yml
ubuntu@control:~/vprofile/exercice14$ cat roles/post-install/handlers/main.yml
---
# handlers file for post-install
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

ubuntu@control:~/vprofile/exercice14$ vim roles/post-install/tasks/main.yml
ubuntu@control:~/vprofile/exercice14$ cat roles/post-install/tasks/main.yml
---
# tasks file for post-install
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

- name: Create a folder
  file:
    path: "{{dir1}}"
    state: directory

- name: Deploy ntp agent conf on centos
  template:
    src: templates/ntpconf_centos
    dest: /etc/chrony.conf
    backup: yes
  when: ansible_distribution == "CentOS"
  notify:
    - Restart service on centos

- name: Deploy ntp agent conf on ubuntu
  template:
    src: templates/ntpconf_ubuntu
    dest: /etc/ntp.conf
    backup: yes
  when: ansible_distribution == "Ubuntu"
  notify:
    - Restart service on ubuntu

- name: Dump file
  copy:
    src: files/myfile.txt
    dest: /tmp/myfile.txt

ubuntu@control:~/vprofile/exercice14$ vim provisioning.yaml
ubuntu@control:~/vprofile/exercice14$ cat provisioning.yaml
- name: Provisioning servers
  hosts: all
  roles:
    - post-install

ubuntu@control:~/vprofile/exercice14$ rm -rf files templates
```

* remove template/ and files/ from role tasks main.yml file and change extension of templates file to .j2
```
ubuntu@control:~/vprofile/exercice14$ vim roles/post-install/tasks/main.yml
ubuntu@control:~/vprofile/exercice14$ cat roles/post-install/tasks/main.yml
---
# tasks file for post-install
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

- name: Create a folder
  file:
    path: "{{dir1}}"
    state: directory

- name: Deploy ntp agent conf on centos
  template:
    src: ntpconf_centos.j2
    dest: /etc/chrony.conf
    backup: yes
  when: ansible_distribution == "CentOS"
  notify:
    - Restart service on centos

- name: Deploy ntp agent conf on ubuntu
  template:
    src: ntpconf_ubuntu.j2
    dest: /etc/ntp.conf
    backup: yes
  when: ansible_distribution == "Ubuntu"
  notify:
    - Restart service on ubuntu

- name: Dump file
  copy:
    src: myfile.txt
    dest: /tmp/myfile.txt
ubuntu@control:~/vprofile/exercice14$ cd roles/post-install/templates/
ubuntu@control:~/vprofile/exercice14/roles/post-install/templates$ mv ntpconf_centos ntpconf_centos.j2
ubuntu@control:~/vprofile/exercice14/roles/post-install/templates$ mv ntpconf_ubuntu ntpconf_ubuntu.j2

```

* execute the playbook
```
ubuntu@control:~/vprofile/exercice14/roles/post-install/templates$ ls
ntpconf_centos.j2  ntpconf_ubuntu.j2
ubuntu@control:~/vprofile/exercice14/roles/post-install/templates$ cd ../../..
ubuntu@control:~/vprofile/exercice14$ ansible-playbook provisioning.yaml

PLAY [Provisioning servers] ********************************************************

TASK [Gathering Facts] *************************************************************
ok: [web02]
ok: [web01]
ok: [web03]
ok: [db01]

TASK [post-install : Install requirements on centos] *******************************
skipping: [web03] => (item=chrony)
skipping: [web03] => (item=wget)
skipping: [web03]
ok: [web02] => (item=chrony)
ok: [web01] => (item=chrony)
ok: [db01] => (item=chrony)
ok: [web01] => (item=wget)
ok: [web02] => (item=wget)
ok: [db01] => (item=wget)

TASK [post-install : Install requirements on ubuntu] *******************************
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

TASK [post-install : Start service on centos] **************************************
skipping: [web03]
ok: [web02]
ok: [db01]
ok: [web01]

TASK [post-install : Start service on ubuntu] **************************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
ok: [web03]

TASK [post-install : Banner file] **************************************************
ok: [web03]
ok: [web01]
ok: [web02]
ok: [db01]

TASK [post-install : Create a folder] **********************************************
ok: [web03]
ok: [web01]
ok: [web02]
ok: [db01]

TASK [post-install : Deploy ntp agent conf on centos] ******************************
skipping: [web03]
ok: [web02]
ok: [web01]
ok: [db01]

TASK [post-install : Deploy ntp agent conf on ubuntu] ******************************
skipping: [web01]
skipping: [web02]
skipping: [db01]
ok: [web03]

TASK [post-install : Dump file] ****************************************************
ok: [web03]
ok: [web01]
ok: [web02]
```
