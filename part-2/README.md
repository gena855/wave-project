eks cluster deploy

for this deploy i used terraform for deploy the infrastructure
i use terraform becouse it open sorce, and supports many providers
and its easy to manipulate resorces with this tool

the second tool that you will need is aws cli to get config file for connecting to cluster via kubectl and mange objects

the tird is tool is kubectl itself

1. download the repo "git clone git@github.com:gena855/wave-project.git"

2. you should run "terraform apply -auto-approve" from wave-project/part-2/infrastructure

by runing terraform, we deploy infrastructure for eks cluster.

you should run "terraform apply -auto-approve" from part-2 directory

we create:
vpc
subnets 2 private and 2 public in 2 AZ
nat
route tables
eks cluster
autoscaling node group for workers
rols and  policis

3. run aws eks --region us-east-1 update-kubeconfig --name eks
for geting the kubeconfig file for connecting to eks via kubectl

then you can manage eks objects by kubectl
