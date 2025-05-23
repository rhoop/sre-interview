# Welcome to the test Infra Repo!!

## Overview

Welcome! This repository contains infrastructure as code (IaC) written in Terraform and Helm for provisioning and managing test's cloud resources.

## Terraform

### Normal Folder Contents in Terraform

1. `main.tf`: This file contains the main Terraform configuration defining the infrastructure resources to be provisioned.
2. `variables.tf`: Contains variable declarations used throughout the Terraform configuration. Modify these variables as needed to customize the infrastructure.
3. `terraform.tfvars`: This file is used to set variable values. Make sure to fill in the required variables with appropriate values before running Terraform commands.
4. `outputs.tf`: Defines the output values that will be displayed after Terraform applies the configuration. This can include important information such as resource IDs or endpoints.
5. `README.md`: Documentation providing an overview of the repository and instructions for usage.
6. `.gitignore`: Specifies files and directories that should be ignored by Git, such as Terraform state files.
7. `.terraform`: Directory where Terraform stores its state and plugins. This directory is typically generated automatically by Terraform and should not be committed to version control.
8. (Optional) modules/`: Directory containing reusable Terraform modules. If used, each module should have its own README file providing instructions for usage.

### Prerequisites

Before using this Terraform configuration, ensure you have the following prerequisites installed:

- [Terraform](https://www.terraform.io/downloads.html) (version X.X.X or higher)
- Cloud provider CLI (e.g., AWS CLI, Azure CLI, Google Cloud SDK) configured with appropriate credentials
- (Optional) Git for version control

### Usage

Follow these steps to use the Terraform configuration:

```bash
# Navigate into the cloned repository directory (for example the global variables).

cd terraform/globals/variables

# Modify the variables.tf and terraform.tfvars files to customize the configuration according to your requirements.

# Initialize the Terraform configuration.
terraform init

# Preview the changes Terraform will make.
terraform plan

# Apply the Terraform configuration to provision the infrastructure.
terraform apply
```

After Terraform applies the configuration, review the outputs displayed in the console. These outputs may include important information such as resource IDs or endpoints.

To clean up and destroy the provisioned infrastructure when no longer needed, run:

```bash
terraform destroy
```

#### State

Terraform maintains a state file in S3 that keeps track of the resources it manages. It is versioned and each folder has it's own state file.
I have not introduced state locking but this would be the logic next step for teams.

## EKS

### Providing IAM Access to a cluster

There are a few manual steps you need to perform to complete a cluster before use

#### Apply the auth ConfigMap so that was can access the nodes easily

> **_NOTE:_** I edited the auth manually for expediency. Not best practice.

```bash
kubectl apply -f k8/preload/aws-auth-cm.yaml
aws eks update-kubeconfig --region us-east-2 --name test-production-eks
```

#### Turn on the metrics Service

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

#### Install NGINX controller

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0/deploy/static/provider/aws/deploy.yaml
```

#### Install datadog

Helm is a pretty straight forward system. Below is how you would deploy a datadog agent on each node in a cluster

```bash

# export your secrets
export DATADOG_API_KEY="<api_key>"
export DATADOG_APP_KEY="<app_key>"
export DATADOG_AGENT_SECRET_TOKEN="<agent_token>"
export DOPPLER_SERVICE_TOKEN="<service_token>"

# setup datadog on the cluster
helm repo add datadog https://helm.datadoghq.com
helm repo update
helm install datadog-monitoring \
    --set datadog.apiKey=$DATADOG_API_KEY  \
    --set datadog.appKey=$DATADOG_APP_KEY \
    --set clusterAgent.enabled=true \
    --set clusterAgent.metricsProvider.enabled=true \
    --set clusterAgent.token=$DATADOG_AGENT_SECRET_TOKEN \
    --set clusterAgent.replicas=2 \
    --set clusterAgent.createPodDisruptionBudge=true \
    datadog/datadog
```

## Installing the test App

```bash
helm upgrade --install test helm -f helm/values.yaml --install --set tag=17 -n api
```

### To scale api instances

```bash
kubectl scale --replicas=3 deployment  app-api -n api
```

## Accessing Logs

All logs are in https://us5.datadoghq.com/logs
