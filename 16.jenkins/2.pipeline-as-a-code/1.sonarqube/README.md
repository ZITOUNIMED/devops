
# SonarQube
* Step 1: Create EC2 instance
Name: SonarServer
AMI: Ubuntu 20.04
Instance Type: t2.meduim 2vcpu 4 Gi
keybair: sonar-key.pem
Security Group: sonar-sg
Inboud rule 1: SSH 22 from my IP
Inbound rule 2: Custom TCP from My IP port 80
Inbound rule 3: Custom TCP from jenkins-sg port 80
User data: sonar-setup.sh
* Step 2: Access sonarqube from a browser
Copy public ip of Ec2 instance and open it in a browser without specifying any port
![alt text](./img/sonar_1.PNG)
* Step 3: Login
Click on the button at the top right 'Sign In' and use default user/password: admin/admin
![alt text](./img/sonar_2.PNG)

## Install SonarQube Scanner tool
![alt text](./img/sonar_tool_0.PNG)
![alt text](./img/sonar_tool_1.PNG)
![alt text](./img/sonar_tool_2.PNG)
![alt text](./img/sonar_tool_3.PNG)
![alt text](./img/sonar_tool_4.PNG)
Copy the generated token
![alt text](./img/sonar_tool_5.PNG)
![alt text](./img/sonar_tool_6.PNG)
![alt text](./img/sonar_tool_7.PNG)

## Checkstyle pipeline
* Step create new pipeline 
![alt text](./img/checkstyle_pipeline_1.PNG)
* Copy script from /samples/Jenkinsfile2 and paste it into "Script" section and save.
![alt text](./img/checkstyle_pipeline_2.PNG)
![alt text](./img/checkstyle_pipeline_3.PNG)
![alt text](./img/checkstyle_pipeline_4.PNG)
![alt text](./img/checkstyle_pipeline_5.PNG)

## Quality Gate
Setup the server
* Step 1: Create quality gate rule 
![alt text](./img/quality_gate_1)
![alt text](./img/quality_gate_2)
![alt text](./img/quality_gate_3)
![alt text](./img/quality_gate_4)
* Step 2: Link the quality gate to the project on sonar
![alt text](./img/quality_gate_5)
![alt text](./img/quality_gate_6)
![alt text](./img/quality_gate_7)
* Step 3: Send the information to jenkins, create a webhook
![alt text](./img/quality_gate_8)
Copy jenkins ec2 instance private IP and use it in the url of the webhook
![alt text](./img/quality_gate_9)
Note: if jenkins-sg does not allow http on port 8080 from anywhere we should add inbound rule to allow from sonarqube sg
![alt text](./img/quality_gate_10)
* Step 4: Update jenkins pipeline script and run build.
Use script in file /samples/Jenkinsfile
* Step 5: check the result
![alt text](./img/quality_gate_11)
![alt text](./img/quality_gate_12)