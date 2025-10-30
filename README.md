# Terraform-AWS-EKS-Pipeline

> **Enterprise-Grade Kubernetes Infrastructure Automation on AWS**

A production-ready Infrastructure as Code (IaC) solution for provisioning and managing Amazon Elastic Kubernetes Service (EKS) clusters using Terraform and automated CI/CD pipelines with GitHub Actions.

---

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Key Features](#key-features)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [CI/CD Pipeline](#cicd-pipeline)
- [Infrastructure Components](#infrastructure-components)
- [Security Features](#security-features)
- [Monitoring & Observability](#monitoring--observability)
- [Cost Optimization](#cost-optimization)
- [Troubleshooting](#troubleshooting)

---

## Overview

CloudOps-EKS-Pipeline is a comprehensive DevOps solution that automates the entire lifecycle of AWS EKS cluster deployment. This project demonstrates industry best practices for:

- **Infrastructure as Code (IaC)** using Terraform for reproducible infrastructure
- **GitOps Methodology** with GitHub Actions for automated deployments
- **Multi-Environment Management** supporting dev, staging, and production environments
- **Security Hardening** with IAM roles, security groups, and network policies
- **High Availability** with multi-AZ deployments and auto-scaling capabilities

This project is ideal for DevOps Engineers, Cloud Architects, and SREs looking to implement enterprise-grade Kubernetes infrastructure on AWS.

---

## Architecture
---
flowchart TD
    %% === REPOSITORY ===
    A[GitHub Repo<br>(Workflows, Terraform, Manifests)]

    %% === CI/CD PIPELINE ===
    B[GitHub Actions<br>Trigger Workflow]
    C[Terraform Init → Plan → Apply]
    D[Deploy Apps to EKS]

    %% === AWS INFRASTRUCTURE ===
    E[VPC (Multi-AZ)]
    F[EKS Control Plane]
    G[EKS Worker Nodes]
    H[App Pods]
    I[Load Balancer]
    J[CloudWatch Logs]
    K[S3 (State) & DynamoDB (Lock)]

    %% === USERS ===
    L[kubectl CLI]
    M[AWS Console]
    N[App Users]

    %% === FLOW ===
    A --> B
    B --> C
    C --> D
    D --> E
    E --> F
    F --> G
    G --> H
    H --> I
    I --> N
    F --> J
    G --> J
    C --> K

    %% === ACCESS PATHS ===
    L --> F
    M --> F

    %% === STYLING ===
    style A fill:#4CAF50,stroke:#333,color:#fff
    style C fill:#2196F3,stroke:#333,color:#fff
    style F fill:#FF9800,stroke:#333,color:#fff
    style I fill:#9C27B0,stroke:#333,color:#fff
    style K fill:#F44336,stroke:#333,color:#fff
---

### Architecture Components

**GitHub Layer:**
- Version-controlled infrastructure code
- Automated CI/CD workflows
- Pull request validations

**Network Layer:**
- Custom VPC with public and private subnets across multiple AZs
- NAT Gateways for outbound internet connectivity
- Internet Gateway for public subnet access
- Network ACLs and Security Groups for traffic control

**Compute Layer:**
- EKS managed control plane (highly available)
- Worker node groups with auto-scaling
- Mix of On-Demand and Spot instances for cost optimization

**Security Layer:**
- IAM roles with least privilege access
- OIDC provider for service account authentication
- Encrypted data at rest and in transit
- Bastion host for secure SSH access

**Operations Layer:**
- CloudWatch for logging and monitoring
- S3 backend for Terraform state management
- DynamoDB for state locking
- Application Load Balancer for traffic distribution

---

## Key Features

### Infrastructure Automation
- Fully Automated EKS Cluster Provisioning - Zero manual intervention required
- Multi-Environment Support - Separate configurations for dev, staging, and production
- State Management - Remote state storage in S3 with DynamoDB locking
- Modular Terraform Code - Reusable modules for VPC, EKS, IAM, and networking

### High Availability & Scalability
- Multi-AZ Deployment - Cluster spans multiple availability zones
- Auto-Scaling Node Groups - Automatic scaling based on workload demands
- Cluster Autoscaler - Kubernetes-native pod and node autoscaling
- Load Balancing - AWS Application Load Balancer integration

### Security & Compliance
- IAM Role-Based Access Control - Granular permissions for cluster and node groups
- Private Subnets - Worker nodes deployed in private subnets
- Security Groups - Network-level access control
- OIDC Integration - Secure authentication for Kubernetes service accounts
- Secrets Management - AWS Secrets Manager and Parameter Store integration

### CI/CD & GitOps
- GitHub Actions Workflows - Automated testing, planning, and deployment
- Pull Request Validation - Automated Terraform plan on PRs
- Environment Promotion - Safe promotion from dev to production
- Rollback Capabilities - Easy infrastructure rollback on failures

### Cost Optimization
- Spot Instance Support - Up to 90% cost savings for non-critical workloads
- Right-Sized Node Groups - Optimized instance types and sizes
- Resource Tagging - Cost allocation and tracking
- Automated Cleanup - Scheduled destroy workflows for dev environments

---

## Technology Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Cloud Provider** | AWS | Infrastructure hosting |
| **Container Orchestration** | Amazon EKS (Kubernetes) | Containerized application management |
| **Infrastructure as Code** | Terraform | Infrastructure provisioning and management |
| **CI/CD** | GitHub Actions | Automated deployment pipelines |
| **State Management** | S3 + DynamoDB | Terraform state storage and locking |
| **Networking** | AWS VPC, NAT Gateway, IGW | Network infrastructure |
| **Security** | IAM, Security Groups, OIDC | Access control and authentication |
| **Monitoring** | CloudWatch, Prometheus | Logging and metrics |
| **Load Balancing** | AWS ALB | Traffic distribution |

---

## Prerequisites

Before getting started, ensure you have the following:

### Required Tools
```bash
# AWS CLI (v2.x or later)
aws --version

# Terraform (v1.5.x or later)
terraform version

# kubectl (compatible with your EKS version)
kubectl version --client

# Git
git --version
```

### AWS Account Setup
- AWS Account with administrative access
- AWS CLI configured with appropriate credentials
- S3 bucket for Terraform state (will be created if using bootstrap script)
- DynamoDB table for state locking (will be created if using bootstrap script)

### GitHub Setup
- GitHub account and repository
- GitHub Actions enabled
- Required GitHub Secrets configured:
  - `AWS_REGION`
  - `AWS_ACCOUNT_ID`
  - IAM OIDC provider configured for GitHub Actions

### Knowledge Requirements
- Basic understanding of Kubernetes concepts
- Familiarity with Terraform and IaC principles
- Experience with AWS services (VPC, EC2, IAM)
- Understanding of CI/CD pipelines

---

## Project Structure

```
CloudOps-EKS-Pipeline/
├── .github/
│   └── workflows/
│       ├── terraform-plan.yml          # PR validation workflow
│       ├── terraform-apply.yml         # Deploy workflow
│       └── terraform-destroy.yml       # Cleanup workflow
│
├── terraform/
│   ├── modules/
│   │   ├── vpc/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── eks/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   ├── iam/
│   │   │   ├── main.tf
│   │   │   ├── variables.tf
│   │   │   └── outputs.tf
│   │   └── security-groups/
│   │       ├── main.tf
│   │       ├── variables.tf
│   │       └── outputs.tf
│   │
│   ├── environments/
│   │   ├── dev/
│   │   │   ├── main.tf
│   │   │   ├── backend.tf
│   │   │   ├── variables.tf
│   │   │   └── terraform.tfvars
│   │   ├── staging/
│   │   │   └── ...
│   │   └── production/
│   │       └── ...
│   │
│   └── scripts/
│       ├── bootstrap.sh                # Initial setup script
│       └── configure-kubectl.sh        # kubectl configuration
│
├── k8s/
│   ├── deployments/
│   │   └── sample-app.yaml
│   ├── services/
│   │   └── sample-service.yaml
│   └── ingress/
│       └── alb-ingress.yaml
│
├── docs/
│   ├── ARCHITECTURE.md
│   ├── DEPLOYMENT.md
│   └── TROUBLESHOOTING.md
│
├── .gitignore
├── README.md
└── LICENSE
```

---

## Getting Started

### Step 1: Clone the Repository

```bash
git clone https://github.com/yourusername/CloudOps-EKS-Pipeline.git
cd CloudOps-EKS-Pipeline
```

### Step 2: Configure AWS Credentials

```bash
# Option 1: Using AWS CLI profile
export AWS_PROFILE=your-profile-name

# Option 2: Using environment variables
export AWS_ACCESS_KEY_ID=your-access-key
export AWS_SECRET_ACCESS_KEY=your-secret-key
export AWS_DEFAULT_REGION=us-east-1
```

### Step 3: Initialize Terraform Backend

```bash
# Run bootstrap script to create S3 bucket and DynamoDB table
cd terraform/scripts
./bootstrap.sh

# Navigate to your environment
cd ../environments/dev
```

### Step 4: Update Configuration

Edit `terraform.tfvars` with your specific values:

```hcl
project_name     = "cloudops-eks"
environment      = "dev"
aws_region       = "us-east-1"
vpc_cidr         = "10.0.0.0/16"
cluster_version  = "1.28"

# Node group configuration
node_group_config = {
  desired_size = 2
  min_size     = 1
  max_size     = 5
  instance_types = ["t3.medium"]
}

# Tags
tags = {
  Environment = "dev"
  Project     = "CloudOps-EKS"
  ManagedBy   = "Terraform"
}
```

### Step 5: Deploy Infrastructure

```bash
# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Apply the configuration
terraform apply
```

### Step 6: Configure kubectl

```bash
# Update kubeconfig
aws eks update-kubeconfig \
  --region us-east-1 \
  --name cloudops-eks-dev

# Verify connection
kubectl get nodes
kubectl get pods --all-namespaces
```

### Step 7: Deploy Sample Application

```bash
# Deploy sample application
kubectl apply -f ../../k8s/deployments/sample-app.yaml
kubectl apply -f ../../k8s/services/sample-service.yaml

# Check deployment status
kubectl get deployments
kubectl get services
```

---

## CI/CD Pipeline

### Workflow Overview

The project includes three main GitHub Actions workflows:

#### 1. **Terraform Plan** (Pull Request Validation)
- Triggers on pull requests to main branch
- Runs `terraform fmt`, `terraform validate`, and `terraform plan`
- Posts plan output as PR comment
- Ensures code quality before merge

#### 2. **Terraform Apply** (Deployment)
- Triggers on push to main branch or manual dispatch
- Authenticates using OIDC (no static credentials)
- Deploys infrastructure changes
- Updates Kubernetes manifests

#### 3. **Terraform Destroy** (Cleanup)
- Manual workflow dispatch only
- Requires approval for production
- Safely tears down infrastructure
- Useful for dev/test environments

### Setting Up GitHub Actions

1. **Configure OIDC Provider in AWS:**

```bash
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list 6938fd4d98bab03faadb97b34396831e3780aea1
```

2. **Create IAM Role for GitHub Actions:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
          "token.actions.githubusercontent.com:sub": "repo:YOUR_ORG/YOUR_REPO:ref:refs/heads/main"
        }
      }
    }
  ]
}
```

3. **Add GitHub Secrets:**
   - Navigate to Settings → Secrets and variables → Actions
   - Add required secrets (AWS_REGION, AWS_ROLE_ARN, etc.)

---

## Infrastructure Components

### VPC & Networking
- **CIDR Block:** Configurable (default: 10.0.0.0/16)
- **Subnets:** 
  - Public subnets (2 AZs) for NAT Gateways and Bastion
  - Private subnets (2 AZs) for EKS worker nodes
- **Route Tables:** Separate for public and private subnets
- **NAT Gateways:** High availability with one per AZ
- **Internet Gateway:** For public subnet internet access

### EKS Cluster
- **Control Plane:** Fully managed by AWS across multiple AZs
- **Kubernetes Version:** 1.28 (configurable)
- **Add-ons:** 
  - VPC CNI
  - CoreDNS
  - kube-proxy
  - EBS CSI Driver
  - AWS Load Balancer Controller

### Node Groups
- **On-Demand Nodes:** For critical production workloads
- **Spot Instances:** For cost-optimized non-critical workloads
- **Auto-Scaling:** Based on CPU/Memory metrics
- **AMI:** AWS EKS-optimized Amazon Linux 2

### IAM Roles
- **Cluster Role:** Permissions for EKS control plane
- **Node Role:** Permissions for worker nodes
- **Service Account Roles:** For Kubernetes workloads (IRSA)

---

## Security Features

### Network Security
- Worker nodes in private subnets (no direct internet access)
- Security groups with least privilege rules
- Network ACLs for additional layer of protection
- Bastion host for secure SSH access

### Access Control
- IAM roles and policies with least privilege
- OIDC provider for service account authentication
- Kubernetes RBAC for fine-grained access control
- AWS Systems Manager Session Manager (no SSH keys)

### Data Protection
- Encryption at rest for EBS volumes
- Encryption in transit (TLS)
- Secrets stored in AWS Secrets Manager
- Parameter Store for configuration

### Compliance
- CloudTrail enabled for audit logging
- VPC Flow Logs for network monitoring
- CloudWatch Logs for centralized logging
- Tagging strategy for resource tracking

---

## Monitoring & Observability

### CloudWatch Integration
```bash
# View cluster logs
aws logs tail /aws/eks/cloudops-eks-dev/cluster --follow

# View node logs
kubectl logs -n kube-system -l app=aws-node
```

### Metrics Server
```bash
# Install metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# View resource usage
kubectl top nodes
kubectl top pods -A
```

### Container Insights
- Cluster-level metrics
- Pod and node performance
- Application logs
- Custom metrics

---

## Cost Optimization

### Strategies Implemented
1. **Spot Instances:** Up to 90% savings for fault-tolerant workloads
2. **Right-Sizing:** T3 instances with burstable performance
3. **Auto-Scaling:** Scale down during low traffic periods
4. **Reserved Instances:** For predictable production workloads
5. **Resource Tagging:** Track costs by environment and project

### Cost Monitoring
```bash
# Enable cost allocation tags
aws ce get-cost-and-usage \
  --time-period Start=2024-10-01,End=2024-10-31 \
  --granularity MONTHLY \
  --metrics BlendedCost \
  --group-by Type=TAG,Key=Environment
```

---

## Troubleshooting

### Common Issues

#### Issue 1: Cluster Creation Timeout
```bash
# Check CloudFormation events
aws cloudformation describe-stack-events \
  --stack-name eksctl-cloudops-eks-dev-cluster

# Check EKS cluster status
aws eks describe-cluster --name cloudops-eks-dev --query cluster.status
```

#### Issue 2: Nodes Not Joining Cluster
```bash
# Check node IAM role
aws iam get-role --role-name cloudops-eks-dev-node-role

# Check security group rules
aws ec2 describe-security-groups \
  --filters Name=tag:Name,Values=cloudops-eks-dev-*

# View node logs
kubectl logs -n kube-system -l k8s-app=aws-node
```

#### Issue 3: Terraform State Lock
```bash
# Force unlock (use with caution)
terraform force-unlock LOCK_ID

# Check DynamoDB lock table
aws dynamodb scan --table-name terraform-state-lock
```

### Debug Commands
```bash
# Terraform debug logging
export TF_LOG=DEBUG
terraform apply

# Kubernetes troubleshooting
kubectl describe nodes
kubectl get events --all-namespaces --sort-by='.lastTimestamp'
kubectl get pods -A -o wide
```

---

## Learning Resources

- [AWS EKS Best Practices Guide](https://aws.github.io/aws-eks-best-practices/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/home/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

## Project Status

![GitHub last commit](https://img.shields.io/github/last-commit/yourusername/CloudOps-EKS-Pipeline)
![GitHub issues](https://img.shields.io/github/issues/yourusername/CloudOps-EKS-Pipeline)
![GitHub stars](https://img.shields.io/github/stars/yourusername/CloudOps-EKS-Pipeline)
![License](https://img.shields.io/github/license/yourusername/CloudOps-EKS-Pipeline)

---

*Last Updated: October 2024*
