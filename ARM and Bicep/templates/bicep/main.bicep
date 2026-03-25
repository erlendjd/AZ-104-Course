targetScope = 'resourceGroup'

@description('Location for all resources')
param location string = resourceGroup().location

param tags object = {}

@description('Number of virtual machines to create')
param vmCount int

@description('Virtual machine name')
param vmName string = 'az104-vm01'

@description('Admin username for the virtual machine')
param adminUsername string = 'azureuser'

@description('Admin password for the virtual machine')
@secure()
param adminPassword string

@description('SKU for the OS disk managed storage account type')
@allowed([
  'Standard_LRS'
  'StandardSSD_LRS'
  'Premium_LRS'
])
param sku string = 'StandardSSD_LRS'

@description('Size of the virtual machine')
param vmSize string = 'Standard_B2s'

@description('Address prefix for the virtual network')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Address prefix for the subnet')
param subnetAddressPrefix string = '10.0.1.0/24'

@description('Virtual network name')
param vnetName string = 'az104-vnet01'

@description('Subnet name')
param subnetName string = 'default'

@description('Allowed source IP or CIDR for inbound SSH (port 22)')
param sshAllowedSourceIp string

module networkModule './modules/network.bicep' = {
  params: {
    location: location
    vnetName: vnetName
    vnetAddressPrefix: vnetAddressPrefix
    subnetName: subnetName
    subnetAddressPrefix: subnetAddressPrefix
    sshAllowedSourceIp: sshAllowedSourceIp
    tags: tags
  }
}

module availabilitySetModule './modules/availabilitySet.bicep' = {
  params: {
    location: location
    availabilitySetName: '${vmName}-avset'
    tags: tags
  }
}

module vmModule './modules/vm.bicep' = [
  for i in range(0, vmCount): {
    name: 'vmModule${i}'
    params: {
      location: location
      vmName: '${vmName}-0${i}'
      adminUsername: adminUsername
      adminPassword: adminPassword
      sku: sku
      vmSize: vmSize
      subnetId: networkModule.outputs.subnetId
      availabilitySetId: availabilitySetModule.outputs.availabilitySetId
      tags: tags
    }
  }
]

output virtualNetworkId string = networkModule.outputs.virtualNetworkId
