# HySecure Multi-Zone AWS Infrastructure – Terraform

## Overview

This repository contains **Terraform Infrastructure as Code (IaC)** used to deploy the **HySecure Gateway infrastructure on AWS across multiple Availability Zones**.

This setup **uses existing AWS resources** (VPC, subnets, security group, key pair) and provisions:

* EC2 Instances (Active / Standby / Real Node)
* External Network Load Balancer (NLB)
* Internal Network Load Balancer (NLB)
* Target Groups & Listeners (IP-based)
* VIP Network Interfaces (ENI for failover)
* Outputs for integration and validation

This architecture provides **high availability (HA)** for HySecure deployment.

---

# Architecture

Internet
│
▼
External Network Load Balancer (Port 443)
│
▼
HySecure Cluster

* Active Node (ap-south-1a)
* Standby Node (ap-south-1b)
* Real Node (ap-south-1a)

│
▼
Internal Network Load Balancer (Only Active and Standby node)

Ports:

* 3306 → Database communication
* 939  → InfoAgent communication

---

# Repository Structure

hysecure-prod-terraform
│
├── provider.tf        # Provider configuration
├── variables.tf       # Input variables           # Existing AWS resources
├── main.tf            # Derived values
│
├── ec2.tf             # EC2 instances
├── vip.tf             # VIP ENI
│
├── targetgroup.tf     # Target groups & attachments
├── nlb-external.tf    # External NLB
├── nlb-internal.tf    # Internal NLB
│
├── outputs.tf         # Outputs
│
├── terraform.tfvars   # Environment config
└── README.md

---

#  Infrastructure Components

## Existing AWS Resources (Prerequisite)

This Terraform **does NOT create**:

* VPC
* Subnets
* Security Group
* Key Pair

These must already exist and are referenced via `terraform.tfvars`.

---

## 🔹 EC2 Instances

Three HySecure nodes are deployed:

| Instance | AZ          | Role            |
| -------- | ----------- | --------------- |
| Active   | ap-south-1a | Primary Gateway |
| Standby  | ap-south-1b | Secondary Node  |
| Real     | ap-south-1a | Additional Node |

### Configuration:

* Private networking 
* gp3 root volume
* Existing SSH key pair

---

## External Network Load Balancer

* Purpose: User login traffic
* Port: **443**
* Protocol: **TCP (pass-through)**

Routes traffic to EC2 instances via target group.

---

## Internal Network Load Balancer

Used for internal cluster communication:

| Port | Purpose   |
| ---- | --------- |
| 3306 | Database  |
| 939  | InfoAgent |

---

## Target Groups

* Type: **IP-based**
* Health Checks:

* HTTPS checks on port 443
* Attached to EC2 private IPs

---

## VIP (Elastic Network Interfaces)

* One ENI per AZ
* Provides **static private IP**
* Used for:

  * failover
  * cluster communication
  

---

# Security Group Requirements

Ensure the Security Group allows:

| Port  | Protocol | Purpose               |
| ----- | -------- | --------------------- |
| 443   | TCP      | HySecure login        |
| 22    | TCP      | SSH                   |
| 3306  | TCP      | Database              |
| 939   | TCP      | InfoAgent             |
| 5536  | TCP      | File sync             |
| 51234 | TCP      | Remote meeting        |
| 4002  | TCP/UDP  | Log sync              |
| 539   | TCP/UDP  | Cluster communication |

Outbound: Allow All

---

# Configuration

Update `terraform.tfvars`:

aws_region = "ap-south-1"

vpc_id = "vpc-xxxx"

subnet_ids = {
az1 = "subnet-xxx"
az2 = "subnet-yyy"
}

security_group_id = "sg-xxxx"
key_pair_name     = "your-key"

instance_az_map = {
active  = "ap-south-1a"
standby = "ap-south-1b"
real-1  = "ap-south-1a"
}

ami_id           = "ami-xxxx"
instance_type    = "t3.medium"
root_volume_size = 65
project_name     = "hysecure-prod"

---

#  Prerequisites

Install the following tools:

* Terraform >= 1.5
* AWS CLI

##  Check Installed Versions

Run:

terraform -v
aws --version

## Configure AWS Credentials

Run:

aws configure

Provide the required details:

AWS Access Key ID: AKIAxxxxxxxxxxxx
AWS Secret Access Key: xxxxxxxxxxxxx
Default region name: ap-south-1
Default output format: json

## Verify AWS Configuration

Run :

aws sts get-caller-identity

Expected Output
{
  "UserId": "XXXXXXXXXXXX",
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/your-user"
}


# Deployment Steps

terraform init
terraform validate
terraform plan
terraform apply

# Outputs

After deployment:

* vpc_id
* subnet_ids
* instance_ids
* private_ips
* external_nlb_dns
* internal_nlb_dns
* vip_ips

# Destroy Infrastructure

terraform destroy