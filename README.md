# AZ-104 Course: ARM Templates and Bicep

This repository is course material for practicing Azure infrastructure deployment with Azure Resource Manager (ARM) templates and Bicep.

## Learning objectives

By the end of this module, you should be able to:

1. Interpret an Azure Resource Manager template or a Bicep file
2. Modify an existing Azure Resource Manager template
3. Modify an existing Bicep file
4. Deploy resources by using an Azure Resource Manager template or a Bicep file
5. Export a deployment as an Azure Resource Manager template or convert an Azure Resource Manager template to a Bicep file

## Prerequisites

- Azure subscription with permissions to deploy resources
- Azure CLI installed and signed in (`az login`) — [install guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- Bicep CLI available (`az bicep install`)
- Two resource group for the labs, one for ARM and one for Bicep

Optional checks:

```powershell
az account show
az bicep version
```

## Review the example files in the repository

```text
/templates
	/arm
		main.json
		parameters.json
	/bicep
		main.bicep
		parameters.bicepparam
```

## Lab 1: Interpret an ARM template or Bicep file

### Goal
Understand what a template deploys and how it is parameterized.

### Steps
1. Open an existing ARM template (`*.json`) and identify:
	 - `$schema`
	 - `parameters`
	 - `variables` (if present)
	 - `resources`
	 - `outputs`
2. Open an existing Bicep file (`*.bicep`) and identify:
	 - `targetScope`
	 - `param` declarations
	 - `resource` declarations
	 - `module` declarations (if present)
	 - `output` declarations
3. Map each resource in the file to an Azure service (for example: Storage Account, Virtual Network, App Service).
4. Validate understanding by predicting what will be created before running deployment commands.

## Lab 2: Modify an existing ARM template

### Goal
Make a controlled change to an existing ARM template.

### Steps
1. Open the ARM template and choose one change, such as:
	 - Add or edit a parameter
	 - Update SKU/tier
	 - Add a resource tag
2. If parameters are externalized, update `parameters.json` accordingly.
3. Define variables to use later

```powershell
$resourceGroupName = 'rg-az104-demo-arm'
$templateFile = './templates/arm/main.json'
$parameterFile = './templates/arm/parameters.json'
$deploymentName = "az104-bicep"
```

4. Validate the template:

```powershell
az deployment group validate `
    --name "$deploymentName-validate" `
    --resource-group $resourceGroupName `
    --template-file $templateFile `
    --parameters $parameterFile
```

5. Run a what-if preview to inspect impact:

```powershell
az deployment group what-if `
    --name "$deploymentName-what-if" `
    --resource-group $resourceGroupName `
    --template-file $templateFile `
    --parameters $parameterFile
```

6. Run a deployment to deploy the resources:
```powershell
az deployment group create `
    --name "$deploymentName" `
    --resource-group $resourceGroupName `
    --template-file $templateFile `
    --parameters $parameterFile
```

## Lab 3: Modify an existing Bicep file

### Goal
Apply similar infrastructure changes using Bicep syntax.

### Steps
1. Open an existing Bicep file and choose one change:
	 - Add or edit a `param`
	 - Update a resource property (for example SKU)
	 - Add tags or outputs
2. Define variables to use later

```powershell
$resourceGroupName = 'rg-az104-demo-bicep'
$templateFile = './templates/bicep/main.bicep'
$parameterFile = './templates/bicep/parameters.bicepparam'
$deploymentName = "az104-bicep"
```

3. Build/compile Bicep to ARM JSON (sanity check):
```powershell
az bicep build --file $templateFile
```

4. Validate the template:

```powershell
az deployment group validate `
    --name "$deploymentName-validate" `
    --resource-group $resourceGroupName `
    --template-file $templateFile `
    --parameters $parameterFile
```

5. Run a what-if preview to inspect impact:

```powershell
az deployment group what-if `
    --name "$deploymentName-what-if" `
    --resource-group $resourceGroupName `
    --template-file $templateFile `
    --parameters $parameterFile
```

## Lab 4: Deploy resources using ARM or Bicep

### Goal
Execute deployment to Azure from both template formats.

### ARM deployment
1. Define variables (file paths and names)
```powershell
$resourceGroupName = 'rg-az104-demo-arm'
$templateFile = './templates/arm/main.json'
$parameterFile = './templates/arm/parameters.json'
$deploymentName = "az104-bicep"
```
2. Run deployment
```powershell
az deployment group create `
    --name "$deploymentName" `
    --resource-group $resourceGroupName `
    --template-file $templateFile `
    --parameters $parameterFile
```

### Bicep deployment
1. Define variables (file paths and names)
```powershell
$resourceGroupName = 'rg-az104-demo-bicep'
$templateFile = './templates/bicep/main.bicep'
$parameterFile = './templates/bicep/parameters.bicepparam'
$deploymentName = "az104-bicep"
```
2. Run deployment
```powershell
az deployment group create `
    --name "$deploymentName" `
    --resource-group $resourceGroupName `
    --template-file $templateFile `
    --parameters $parameterFile
```

### Post-deployment check
1. Verify resources in Azure Portal.
2. Review deployment output: ARM
```powershell
$resourceGroupName = 'rg-az104-demo-arm'
$deploymentName = "az104-bicep"
```
```powershell
az deployment group show `
	--resource-group $resourceGroupName `
	--name $deploymentName
```
3. Review deployment output: Bicep
```powershell
$resourceGroupName = 'rg-az104-demo-bicep'
$deploymentName = "az104-bicep"
```
```powershell
az deployment group show `
	--resource-group $resourceGroupName `
	--name $deploymentName
```


## Lab 5: Export deployment as ARM template and convert ARM to Bicep

### Task 2: Export an existing resource group to ARM template
```powershell
$resourceGroupName = 'rg-az104-demo-arm'
```
```powershell
az group export --name $resourceGroupName > exported-template.json
```

Review the exported file and identify reusable parameters/resources.

### Task 1: Convert ARM template to Bicep

```powershell
az bicep decompile --file 'exported-template.json'
```

After conversion:
1. Review generated Bicep for readability and naming.
2. Make necesarry changes to the generated bicep file.
3. Build to verify syntax:

```powershell
az bicep build --file 'exported-template.bicep'
```
