eks cluster deploy

download the repo "git clone git@github.com:gena855/wave-project.git"

you should run "terraform apply -auto-approve" from wave-project/part-2/infrastructure

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
