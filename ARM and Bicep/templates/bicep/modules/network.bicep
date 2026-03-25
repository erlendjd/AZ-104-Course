targetScope = 'resourceGroup'

@description('Location for network resources')
param location string

param tags object = {}

@description('Virtual network name')
param vnetName string

@description('Address prefix for the virtual network')
param vnetAddressPrefix string

@description('Subnet name')
param subnetName string

@description('Address prefix for the subnet')
param subnetAddressPrefix string

@description('Allowed source IP or CIDR for inbound SSH (port 22)')
param sshAllowedSourceIp string

var nsgName = '${vnetName}-nsg'
var sshSourcePrefix = contains(sshAllowedSourceIp, '/') ? sshAllowedSourceIp : '${sshAllowedSourceIp}/32'

resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: nsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'Allow-SSH-From-Input-IP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: sshSourcePrefix
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: vnetName
  location: location
  tags: tags
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
    networkSecurityGroup: {
      id: nsg.id
    }
  }
}

output virtualNetworkId string = vnet.id
output subnetId string = subnet.id
