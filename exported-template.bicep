param networkInterfaces_az104_vm01_nic_name string
param publicIPAddresses_az104_vm01_pip_name string
param virtualMachines_az104_vm01_name string
param virtualNetworks_az104_vnet01_name string

resource publicIPAddresses_az104_vm01_pip_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  location: 'norwayeast'
  name: publicIPAddresses_az104_vm01_pip_name
  properties: {
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
    idleTimeoutInMinutes: 4
    ipAddress: '20.251.9.73'
    ipTags: []
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
  }
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
}

resource virtualNetworks_az104_vnet01_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  location: 'norwayeast'
  name: virtualNetworks_az104_vnet01_name
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    enableDdosProtection: false
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        id: virtualNetworks_az104_vnet01_name_default.id
        name: 'default'
        properties: {
          addressPrefix: '10.0.1.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
  }
}

resource virtualMachines_az104_vm01_name_resource 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  location: 'norwayeast'
  name: virtualMachines_az104_vm01_name
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2als_v2'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_az104_vm01_nic_name_resource.id
          properties: {
            primary: true
          }
        }
      ]
    }
    osProfile: {
      adminUsername: 'azureuser'
      allowExtensionOperations: true
      computerName: virtualMachines_az104_vm01_name
      linuxConfiguration: {
        disablePasswordAuthentication: false
        patchSettings: {
          assessmentMode: 'ImageDefault'
          patchMode: 'ImageDefault'
        }
        provisionVMAgent: true
      }
      requireGuestProvisionSignal: true
      secrets: []
    }
    storageProfile: {
      dataDisks: []
      diskControllerType: 'SCSI'
      imageReference: {
        offer: '0001-com-ubuntu-server-jammy'
        publisher: 'Canonical'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        caching: 'ReadWrite'
        createOption: 'FromImage'
        deleteOption: 'Detach'
        diskSizeGB: 30
        managedDisk: {
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_az104_vm01_name}_OsDisk_1_8cba9f2898ac40cbb258add290a37503'
          )
          storageAccountType: 'StandardSSD_LRS'
        }
        name: '${virtualMachines_az104_vm01_name}_OsDisk_1_8cba9f2898ac40cbb258add290a37503'
        osType: 'Linux'
      }
    }
  }
}

resource virtualNetworks_az104_vnet01_name_default 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_az104_vnet01_name}/default'
  properties: {
    addressPrefix: '10.0.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_az104_vnet01_name_resource
  ]
}

resource networkInterfaces_az104_vm01_nic_name_resource 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  kind: 'Regular'
  location: 'norwayeast'
  name: networkInterfaces_az104_vm01_nic_name
  properties: {
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
    disableTcpStateTracking: false
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    ipConfigurations: [
      {
        id: '${networkInterfaces_az104_vm01_nic_name_resource.id}/ipConfigurations/ipconfig1'
        name: 'ipconfig1'
        properties: {
          primary: true
          privateIPAddress: '10.0.1.4'
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_az104_vm01_pip_name_resource.id
          }
          subnet: {
            id: virtualNetworks_az104_vnet01_name_default.id
          }
        }
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
      }
    ]
    nicType: 'Standard'
  }
}
