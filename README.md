# AZ-104: Microsoft Azure Administrator — Course Repository

This repository contains course materials and hands-on labs for the **AZ-104 Microsoft Azure Administrator** certification exam.

## Repository Structure

```text
/
├── ARM and Bicep/          # Infrastructure-as-Code labs and templates
│   ├── templates/
│   │   ├── arm/            # ARM template (JSON) and parameter file
│   │   └── bicep/          # Bicep main file, parameter file, and modules
│   └── README.md           # Lab instructions for ARM and Bicep
│
└── Case study/             # End-to-end scenario: Boller og Brus
    └── readme.md           # Full case study description and phased tasks
```

## Modules

### ARM and Bicep

Hands-on labs covering Azure infrastructure deployment using ARM templates and Bicep.

**Topics covered:**
- Interpreting and modifying ARM templates (JSON)
- Interpreting and modifying Bicep files
- Deploying resources via ARM and Bicep
- Exporting deployments and converting ARM templates to Bicep

See [ARM and Bicep/README.md](ARM%20and%20Bicep/README.md) for full lab instructions.

### Case Study: Boller og Brus

An end-to-end scenario where students design and implement a secure Azure environment for a fictional Norwegian e-commerce company migrating to the cloud.

**AZ-104 topics covered:**
- Azure Identities and Governance (Entra ID, RBAC, policies, resource locks)
- Azure Storage (storage accounts, file shares, blob storage, access control)
- Virtual Networking (VNets, subnets, NSGs, DNS)
- Compute Resources (Virtual Machines, App Services, scaling)
- Monitoring and Backup (Azure Monitor, Log Analytics, alerts, Azure Backup)

See [Case study/readme.md](Case%20study/readme.md) for the full scenario and phased tasks.

## Prerequisites

- Azure subscription with permissions to deploy resources
- Azure CLI installed and signed in (`az login`) — [install guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Bicep CLI available (`az bicep install`)

## Resources

- [AZ-104 exam page](https://learn.microsoft.com/en-us/credentials/certifications/azure-administrator/)
- [Azure documentation](https://learn.microsoft.com/en-us/azure/)
- [Bicep documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
