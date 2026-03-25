# 🧪 AZ-104 Case Study: "Nordic Outdoor Gear AS"

## 📖 Scenario Overview

You are a consultant at a Norwegian IT services company. Your client, Nordic Outdoor Gear AS, is a small but growing e-commerce business based in Norway.

They currently run:
- A small on-premises file server
- Basic identity management (no cloud yet)
- A simple website hosted by a third party

They want to:
- Move to Microsoft Azure
- Improve security and identity management
- Host their own applications
- Enable remote work
- Ensure backup and monitoring are in place

Your job is to design and implement a secure, cost-effective Azure environment.

---

## 🎯 Learning Objectives (mapped to AZ-104)

Students should practice:

1. Azure Identities and Governance
	 - Microsoft Entra ID (Azure AD)
	 - RBAC
	 - Resource locks
	 - Tags
	 - Policies

2. Azure Storage
	 - Storage accounts
	 - File shares
	 - Blob storage
	 - Access control (SAS / RBAC)

3. Virtual Networking
	 - VNets and subnets
	 - NSGs
	 - Private vs public access
	 - DNS basics

4. Compute Resources
	 - Virtual Machines
	 - App Services (basic web app hosting)
	 - Scaling basics

5. Monitoring and Backup
	 - Azure Monitor
	 - Log Analytics
	 - Alerts
	 - Azure Backup / Recovery Services Vault

---

## 🧩 Case Structure (Student Assignment)

### Suggested Working Method

For each phase, students should:
- Create the resource in the Azure portal, Azure CLI, or PowerShell
- Check that the resource is placed in the correct resource group and region
- Test the configuration before moving to the next phase
- Write down why the chosen Azure service or setting is appropriate

Students should not only build the environment, but also be able to explain:
- Why a service was chosen
- How access is controlled
- What risk is reduced by the configuration
- How the solution can be operated and recovered

### Phase 1: Resource Groups and Governance

#### Task

Create the foundational Azure structure.

#### Requirements

- Create:
	- Resource Group structure:
		- `rg-nordic-prod`
		- `rg-nordic-dev`
- Apply:
	- Tags:
		- `Environment`
		- `Owner`
- Implement:
	- RBAC:
		- Admin group
		- Developer group (limited rights)
- Add:
	- Resource lock on production resources

#### Guidance

- Start by creating the two resource groups first, because almost every later resource depends on a clear placement strategy
- Put production-style resources in `rg-nordic-prod` and test or lower-risk resources in `rg-nordic-dev`
- Apply tags as early as possible so students can use them consistently on later resources
- Use a lock such as `CanNotDelete` on production resources to demonstrate protection against accidental removal

#### What to explain or verify

- Explain why separating dev and prod improves management and reduces operational risk
- Verify that tags appear on the resource groups
- Verify that the production lock prevents accidental deletion

#### Bonus

- Create a policy:
	- Restrict allowed regions (for example Norway East / West Europe)

---

### Phase 2: Virtual Network Design

#### Task

Design secure networking.

#### Requirements

- Create VNet:
	- `vnet-nordic`
- Subnets:
	- `subnet-vm`
	- `subnet-app`
	- `subnet-lb`
- Configure NSG:
	- Allow RDP/SSH only from specific IP (student's IP) to Load Balancer frontend
- Add an outbound NAT Gateway:
	- Associate with VM subnet for controlled outbound internet access

#### Guidance

- Create the VNet before the VM so the server can be deployed directly into the correct subnet
- Keep the subnets logically separated by role: VM workload, app workload, and load balancer-related components
- Use the NSG to limit management access as tightly as possible
- The NAT Gateway should be used for predictable outbound connectivity from the VM subnet instead of relying on default outbound access

#### What to explain or verify

- Explain the difference between inbound access and outbound internet access
- Verify that the VM subnet is associated with the expected NSG and NAT Gateway path
- Explain why limiting RDP/SSH to a known source IP is better than opening management access to the internet

#### Bonus

- Discuss private endpoints vs public endpoints

---

### Phase 3: Virtual Machine Deployment

#### Task

Deploy a server workload in Azure.

#### Requirements

- Deploy a VM:
	- Windows Server or Linux
	- Place it in `subnet-vm`
	- Do not assign a Public IP to the VM NIC

#### Guidance

- Choose Windows Server if the lab focuses on RDP and Azure Files mounting with SMB from a familiar interface
- Choose Linux if the lab should also test SSH and manual mounting steps
- Confirm during deployment that the NIC is connected to `subnet-vm` and that no direct Public IP is created
- Keep the VM size modest unless there is a specific application need, since this is a training environment

#### What to explain or verify

- Verify the VM can start successfully without a Public IP
- Explain why removing the Public IP reduces direct exposure to the internet
- Verify the operating system and administrator access method match the lab design

---

### Phase 4: Load Balancer for Remote Access

#### Task

Publish secure administrative access to the VM.

#### Requirements

- Add an Azure Load Balancer:
	- Frontend Public IP for RDP/SSH access
	- Backend pool with VM NIC
	- Inbound NAT rule for RDP (or SSH for Linux)
- Ensure VM management traffic goes through the Load Balancer frontend IP

#### Guidance

- Create the Load Balancer only after the VM exists, so the VM NIC can be added to the backend pool
- Use an inbound NAT rule rather than assigning a Public IP directly to the VM
- Test connectivity using the Load Balancer frontend IP and the correct management port
- Make sure the NSG still allows only the approved source IP to reach the management port

#### What to explain or verify

- Explain why the Load Balancer is being used as the public entry point instead of a Public IP on the server
- Verify that RDP or SSH works through the Load Balancer frontend IP
- Verify that direct internet access to the VM NIC is not possible

---

### Phase 5: Storage Account, File Share, and Blob

#### Task

Replace the on-prem file server and enable object storage.

#### Requirements

- Create a Storage Account
- Create:
	- Azure File Share (`files-nordic`)
- Configure:
	- Access using storage account access key
- Create a Blob container:
	- For product images (`product-images`)

#### Guidance

- Use a general-purpose storage account that supports both Azure Files and Blob storage
- Create the file share for department or server-style file access and the blob container for application content such as product images
- Since identity-based access is out of scope for this lab, retrieve the storage account key and document where it is used
- Students should note that access keys are powerful and should be handled carefully even in a lab scenario

#### What to explain or verify

- Explain the difference between Azure Files and Blob storage
- Verify that both `files-nordic` and `product-images` exist in the same storage account
- Explain why SAS is appropriate for temporary upload access to the marketing team

#### Scenario Twist

Marketing team needs temporary access to upload images.

Students must:
- Create a SAS token, or
- Assign RBAC correctly

---

### Phase 6: Mount File Share on the VM

#### Task

Connect the VM to Azure Files.

#### Requirements

- Mount/connect `files-nordic` from the VM
- Verify read/write access using storage account key authentication

#### Guidance

- Use the connection or mounting instructions provided by the Azure portal for the file share
- On Windows, students can map the share as a network drive
- On Linux, students can mount the share using SMB/CIFS with the storage account name and key
- After mounting, create a test file and confirm it persists in the share

#### What to explain or verify

- Verify that the file share is reachable from the VM
- Verify that a file created from the VM is visible in the Azure File Share
- Explain that this setup replaces a simple on-prem file server scenario

---

### Phase 7: Identity Implementation

#### Task

Set up identity for employees.

#### Requirements

- Create users:
	- `admin@nordicoutdoor.no`
	- `dev@nordicoutdoor.no`
- Create groups:
	- `IT-Admins`
	- `Developers`
- Assign roles:
	- `IT-Admins` -> Contributor (subscription or RG)
	- `Developers` -> limited access (for example VM Operator or Reader)

#### Guidance

- Keep the identity task focused on users, groups, and role assignments rather than advanced conditional access design
- Assign roles to groups instead of directly to users where possible, because this scales better operationally
- Use the smallest role that still allows the required task

#### What to explain or verify

- Explain the difference between authentication and authorization
- Verify that users are members of the correct groups
- Verify that role assignments are attached to the correct scope

#### Bonus

- Enable MFA (conceptual or actual if lab allows)
- Discuss Conditional Access (optional design task)

---

### Phase 8: Compute Resources (Web Application)

#### Task

Deploy a basic web workload.

#### Requirements

- Deploy an Azure App Service:
	- Host a simple website (can be sample app)
- Configure:
	- Public access via URL

#### Guidance

- Keep the web app simple so the focus stays on Azure administration rather than application development
- Use the default public App Service URL unless a custom domain is part of an extra exercise
- Test that the application is reachable in a browser after deployment

#### What to explain or verify

- Explain why App Service is usually easier to manage than hosting a website directly on a VM
- Verify that the app is reachable from the public URL
- Explain when scaling would be needed for seasonal demand

#### Scenario Twist

The company expects seasonal spikes.

Students must:
- Configure scaling (manual or auto-scale conceptually)

---

### Phase 9: Monitoring

#### Task

Implement monitoring across resources.

#### Requirements

- Enable:
	- Azure Monitor
- Create:
	- Log Analytics Workspace
- Connect:
	- VM to Log Analytics
- Configure alert:
	- CPU > 80%
- View:
	- Metrics and logs

#### Guidance

- Create the Log Analytics Workspace before connecting the VM so monitoring data has a destination
- Enable monitoring on the VM and confirm that heartbeat or performance data is arriving
- Create an alert rule that is realistic and easy to demonstrate in the lab

#### What to explain or verify

- Explain the difference between metrics, logs, and alerts
- Verify that the VM appears as connected to the monitoring workspace
- Verify that students can find CPU-related metrics or log data

---

### Phase 10: Backup and Recovery

#### Task

Ensure business continuity.

#### Requirements

- Create:
	- Recovery Services Vault
- Configure:
	- Backup for VM
	- Backup for Azure File Share (`files-nordic`)
- Define:
	- Backup policy (daily)

#### Guidance

- Use the Recovery Services Vault as the central backup component for both compute and file share protection in this lab
- Configure backup policies that are simple enough to explain, for example a daily backup schedule
- Students should review available restore options after enabling backup, not only enable the policy

#### What to explain or verify

- Explain the difference between protecting a VM and protecting a file share
- Verify that both the VM and `files-nordic` are registered for backup
- Explain what recovery option would be used for accidental file deletion versus full VM failure

#### Scenario Twist

CEO asks:

"What happens if we delete a file or the VM crashes?"

Students must explain:
- File recovery
- VM restore options
- File Share restore options (share-level or item-level where applicable)
