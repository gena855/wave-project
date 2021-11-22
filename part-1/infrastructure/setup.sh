#!/bin/bash
chmod 0400 ~/.ssh/id_rsa
terraform init
terraform apply -auto-approve
