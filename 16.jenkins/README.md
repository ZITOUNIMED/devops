# Jenkins
## CI: Continuous Integration
jenkins CI automatizes the process of build, evaluate report and notify, etc after each push of developers on source code remote repo.
![alt text](./img/jenkins-CI.PNG)
### Features
* Open Source
* Extensible:
Because of its OpenSource jenkins it is extensible. It integrates many plugins such as:
- VCS Plugin: Plugin for version control system to integrate jenkins with all vesion cntrl systems
- Build Plugin: you can build java, node, .NET, ... any source code by their build tools.
- Cloud Plugin
- Testing Plugin
- Etc.

### Installations
Prerequis:
- Java JRE and JDK
- Any OS
Go to "https://www.jenkins.io/" and choose "/Documentations/Install Jenkins section"
```
#!/bin/bash

sudo apt update

sudo apt install openjdk-11-jdk -y

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update

sudo apt-get install jenkins -y
```
* Go to AWS console EC2
* Create new EC2 instance with this config
- name: Jenkinsserver
- AMI: Ubuntu 20.04 TLS free tier
- Instance Type: t2.micro 1vCPU 1Gi Free tier
- Create new key pair with name jenkins-key
- Edit network settings: 
- create new security group named jenkins-SG and inbound rule SSH from MY IP and new inbound rule: type custom TCP, port 8080 from MY IP
- use the script above as User Data to install jenkins on the instance
- launch the instance

* SSH to the instance
When the instance is ready in a running state copy the public IP and use it to ssh into the instance.
```
$ ssh -i jenkins-key.pem ubuntu@<public-ip>
```
* Check installed java and jenkins
```
$ java -version
java 11 jdk installed ...
$ systemctl status jenkins
active state ...
# Check jenkins home directory
$ ls /var/lib/jenkins
# Check jenkins user
$ id jenkins
uid=114(jenkins) gid=120(jenkins) groups=120(jenkins)
```
### Use jenkins
* Access jenkins from a browser: copy its public IP and set it with the default port 8080 <public-id>:8080 in browser search input and hit enter.
* copy the password from installed jenkins server
```
$ sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
* paste the password and connect
* choose select plugin to install
* read all plugin that will be installed, unselect Ant plagin and click install
* create new user
admin
admin12345
Admin ADL
admin@mydevops.com
* save
### Job Types in Jenkins
* Freestype
* Pipeline As A Code
