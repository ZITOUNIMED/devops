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
Ansible uses SSH or winrm or API or physical cables to connect to systems:
* SSH: for Linux
* winrm: for windows
* API: for cloud
* cables: routers, switches, any server
## Ansible architecture