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
- Azure CLI installed and signed in (`az login`)
- Bicep CLI available (`az bicep install`)
- A resource group for the labs

Optional checks:

```bash
az account show
az bicep version
```

## Suggested repository layout

You will add files over time. Use this structure as a guide:

```text
/templates
	/arm
		baseline-template.json
		parameters.json
	/bicep
		main.bicep
		main.bicepparam
/commands
	deployment-commands.md
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
3. Validate the template:

```bash
az deployment group validate \
	--resource-group <resource-group-name> \
	--template-file <path-to-template.json> \
	--parameters <path-to-parameters.json>
```

4. Run a what-if preview to inspect impact:

```bash
az deployment group what-if \
	--resource-group <resource-group-name> \
	--template-file <path-to-template.json> \
	--parameters <path-to-parameters.json>
```

## Lab 3: Modify an existing Bicep file

### Goal
Apply similar infrastructure changes using Bicep syntax.

### Steps
1. Open an existing Bicep file and choose one change:
	 - Add or edit a `param`
	 - Update a resource property (for example SKU)
	 - Add tags or outputs
2. Build/compile Bicep to ARM JSON (sanity check):

```bash
az bicep build --file <path-to-main.bicep>
```

3. Validate deployment:

```bash
az deployment group validate \
	--resource-group <resource-group-name> \
	--template-file <path-to-main.bicep> \
	--parameters <path-to-main.bicepparam>
```

4. Run what-if:

```bash
az deployment group what-if \
	--resource-group <resource-group-name> \
	--template-file <path-to-main.bicep> \
	--parameters <path-to-main.bicepparam>
```

## Lab 4: Deploy resources using ARM or Bicep

### Goal
Execute deployment to Azure from both template formats.

### ARM deployment

```bash
az deployment group create \
	--resource-group <resource-group-name> \
	--template-file <path-to-template.json> \
	--parameters <path-to-parameters.json>
```

### Bicep deployment

```bash
az deployment group create \
	--resource-group <resource-group-name> \
	--template-file <path-to-main.bicep> \
	--parameters <path-to-main.bicepparam>
```

### Post-deployment check
1. Verify resources in Azure Portal.
2. Review deployment output:

```bash
az deployment group show \
	--resource-group <resource-group-name> \
	--name <deployment-name>
```

## Lab 5: Export deployment as ARM template or convert ARM to Bicep

### Option A: Export an existing resource group to ARM template

```bash
az group export --name <resource-group-name> > exported-template.json
```

Review the exported file and identify reusable parameters/resources.

### Option B: Convert ARM template to Bicep

```bash
az bicep decompile --file <path-to-template.json>
```

After conversion:
1. Review generated Bicep for readability and naming.
2. Build to verify syntax:

```bash
az bicep build --file <generated-file.bicep>
```

## Where to add your course assets

When you provide files later, place them in this repository and update the placeholders:

- ARM templates: `templates/arm/`
- Bicep files: `templates/bicep/`
- Deployment command references: `commands/deployment-commands.md`

## Completion checklist

- [ ] Interpreted one ARM template and one Bicep file
- [ ] Modified and validated an ARM template
- [ ] Modified and validated a Bicep file
- [ ] Deployed resources from ARM and/or Bicep
- [ ] Exported a deployment to ARM or converted ARM to Bicep