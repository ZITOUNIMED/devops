# Vagrant
Vagrant is a tool used to auto manage VMs.
## Create VM
To create a centos VM and SSH into it follow these stepes:
* Open Vagrant cloud website and search a box with its name. Example search for centos 9. In the search result open eurolinux-vargant/centos-stream-9 and copy the name of the box.
* Init the VM
```
$ mkdir vargant-vms/centos
$ cd vargant-vms/centos
$ vargant init eurolinux-vargant/centos-stream-9
```
Result: this command will Create a Vagrantfile with the munimum configuration that we can update.
* Run the VM
```
$ vagrant up
```
Result: This command will download the box of centos if it is the first use of the bow and after that runs it.

* Check Vargant Vms and downloaded boxes
```
$ vargant box list
$ vargant status
```
Output: The first command will display all downloaded boxes and the second one will display the status of the running VM.

* SSH into the VM
```
$ vargant ssh
$ whoami
vargant
$ sudo -i
$ whoami
root
$ exit
$ exit
```
Result: these commands allows us to ssh into the running centos VM and display the current user vargant and change it to root and after that exit two times one to exit from the root user and the second to exit from the ssh.
* Shutdown the VM
```
$ vargant halt
```
* Reload the VM
```
$ vagrant reload
```
Result: this command allows to reload the VM. If the Fagrantfile was changed it will apply it but if the name of the box is changed than it will delete the VM and create a new one.

* Delete the VM
```
$ vagrant destroy
```
Result: this delete the vm.
* Display all Vm status
```
$ vagrant global-status
```
Output: unlike status that display the status of the VM of the current folder, the global-status command displays status of all VMs. 