# Azure Event Hubs with Blob Capture using Terraform
<img width="1500" height="882" alt="AeventHub" src="https://github.com/user-attachments/assets/fff9cc41-bab2-426a-ab97-2b0760733cd2" />

## Overview

This Terraform project deploys:

- Azure Event Hubs Namespace
- Event Hub
- Azure Storage Account
- Blob Storage Container
- Event Capture to Blob Storage
- Shared Access Policies

This project demonstrates how to stream and archive event data into Azure Blob Storage using Infrastructure as Code (IaC).

---

# Architecture

```text
Event Producer
       │
       ▼
Azure Event Hub
       │
       ▼
Blob Capture (.avro files)
       │
       ▼
Azure Storage Account
```

---

# Services Used

- Azure Event Hubs
- Azure Blob Storage
- Terraform
- Azure CLI

---

# Prerequisites

Install:

## Terraform

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

Verify:

```bash
terraform version
```

---

## Azure CLI

```bash
brew install azure-cli
```

Verify:

```bash
az version
```

Login:

```bash
az login
```

---

# Project Files

```text
EventHub-Terraform/
│
├── providers.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── README.md
```

---

# Deployment Steps

## Step 1: Initialize Terraform

```bash
terraform init
```

---

## Step 2: Format Terraform Files

```bash
terraform fmt
```

---

## Step 3: Validate Terraform

```bash
terraform validate
```

---

## Step 4: Create Terraform Plan

```bash
terraform plan \
-var="resource_group_name=rg_eastus_XXXXX"
```

---

## Step 5: Deploy Infrastructure

```bash
terraform apply \
-var="resource_group_name=rg_eastus_XXXXX"
```

Type:

```text
yes
```

when prompted.

---

# Resources Created

## Event Hub Namespace

Creates:

- Standard SKU namespace
- 2 throughput units

---

## Event Hub

Creates:

- Event Hub named `events`
- Event Capture enabled
- AVRO formatting enabled

---

## Storage Account

Creates:

- Standard LRS Storage Account
- Blob storage enabled
- Public blob access enabled

---

## Blob Container

Creates:

```text
events
```

container for AVRO event storage.

---

# Retrieve Outputs

View deployment outputs:

```bash
terraform output
```

Sensitive outputs:

```bash
terraform output primary_key
```

---

# Send Events to Event Hub

Install scripts:

```powershell
Install-Script get-blobevents, send-blobevents
```

If prompted:

```text
Y
```

---

# Set PowerShell Execution Policy

```powershell
Set-ExecutionPolicy RemoteSigned
```

---

# Send Test Events

Run:

```powershell
send-blobevents
```

Enter:

## primaryKey

Use Terraform output:

```bash
terraform output primary_key
```

---

## Eventhubnamespace

Use:

```bash
terraform output eventhub_namespace_name
```

---

## Eventhub

Use:

```bash
terraform output eventhub_name
```

---

## numberOfEvents

```text
10
```

---

# Review Events in Blob Storage

Navigate to:

```text
Azure Portal
→ Storage Account
→ Containers
→ events
```

You should see:

```text
.avro
```

files generated automatically.

---

# Query Blob Events

Run:

```powershell
get-blobevents
```

Enter:

## blobName

Use:

```bash
terraform output storage_account_name
```

---

## containerName

```text
events
```

---

# Expected Result

You should see:

- AVRO event files
- Captured Event Hub messages
- Blob storage event archives

---

# Cleanup

Destroy all resources:

```bash
terraform destroy \
-var="resource_group_name=rg_eastus_XXXXX"
```

---

# Troubleshooting

## Azure Login Errors

Run:

```bash
az login
```

---

## Terraform Provider Errors

Use:

```hcl
provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}
```

---

# Skills Demonstrated

This project demonstrates:

- Azure Event Hubs
- Event Streaming
- Blob Storage
- Terraform
- Infrastructure as Code
- Event Capture
- Azure Monitoring
- Cloud Automation
