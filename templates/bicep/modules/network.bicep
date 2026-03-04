targetScope = 'resourceGroup'

@description('Location for network resources')
param location string

@description('Virtual network name')
param vnetName string

@description('Address prefix for the virtual network')
param vnetAddressPrefix string

@description('Subnet name')
param subnetName string

@description('Address prefix for the subnet')
param subnetAddressPrefix string

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: subnetAddressPrefix
  }
}

output virtualNetworkId string = vnet.id
output subnetId string = subnet.id
