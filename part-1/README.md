part 1

for this deploy i used terraform for deploy the infrastructure,
and ansible for instances configuration

download the repo "git clone git@github.com:gena855/wave-project.git"

you should run the setup.sh script from wave-project/part-1/infrastructure

1. by running the scrypt, you make infrastructure by terraform and configure instances to run docker with nginx web server.

2. the first step is crate the vpc, subnets, security groups, igw, nat, iam role, route tables, key for connecting the servers.
we create the key from our local keys, and copy private key to ansible-controler instance for connecting to web servers

3. we create 2 public subnets in 2 AZ and 2 private subnets in 2 AZ
the public subnets for ansible-control instance, for connecting from the internet and for ALB.
the private subnets for web servers.

4. after the instances creation, with attachet ec2 iam role for reaching the aws api, for geting automaticly the private ip addreses buy ansible module. we copy the ansible role, playbook and script.

5. the next step is run ansible, that run the attachet script, and is instaling all necessary packages for running a docker
* note that running a script can take about 3-5 min
after the script, we generate a web page, and put it in folder that we going to attach to docker as bind.

6. running docker and bind to folder with web page.

7. the final step is creatin alb, target groups and attach our web servers instances to the target group.

8. by the end of running terraform we are get output of ALB dns name and we can reach the servers by in browser this name.
*note that it can take aout 5 mins the web page is shown
