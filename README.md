# ecr-ecs-tf
This repository contains code to launch ECR Repo and Create ECS Scheduled Task

Modules folder contains 3 directory with cloudnames such has aws, gcp and azure. Currently gcp and azure has a blank main.tf file while aws has code for ecr and ecs fargate.

There is a folder at root level with name as tf, which will be the parent folder.
Inside tf folder, we currently have aws code which calls the module and passes the values via variables.tf
Inside tf folder, there is again one folder with name tfvars, which has subfolders with client name, any client that comes in can have tfvars inside it.

The complete folder structure is created as below

![image](https://user-images.githubusercontent.com/72783904/135670248-9fd4669d-f9d9-48a8-9524-4090bb295a76.png)

Usage:

#initialize tf
```
terraform init
```

#plan
```
terraform plan -var-file=tf/tfvars/client1/ecr.tfvars
terraform plan -var-file=tf/tfvars/client1/ecs.tfvars
```

#apply
```
terraform apply -var-file=tf/tfvars/client1/ecr.tfvars
terraform apply -var-file=tf/tfvars/client1/ecs.tfvars
```

How it solves the problem:
1. Through the ECR code, we can add as many ecr repos as needed. We just have to add new ecr repo name in the ecr.tfvars
2. Through the ECS code, we are spinning up 14 resources which includes ecs service, ecs task-definition, ecs scheduled task, security groups, iam roles etc.
3. For security and considering the datasources might be at different subnet,vpcs or account. We are supplying values in tfvars for cidr_blocks as a type of list so that we can whitelist IP ranges of datasources in security group (We are using dynamic ingress block in sg)
4. For any datasource that requires specific connection, we just have to pass it in tfvars under ingress_ports and it whitelists the cidr range for that port.
5. for upgrading it as required, added a data block which will get the latest image from repository and update the cluster when deployment is triggered.

