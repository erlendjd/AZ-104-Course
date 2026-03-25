param location string
param availabilitySetName string
param faultDomainCount int = 2
param updateDomainCount int = 5
param tags object = {}

resource availabilitySet 'Microsoft.Compute/availabilitySets@2021-07-01' = {
  name: availabilitySetName
  location: location
  tags: tags
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformFaultDomainCount: faultDomainCount
    platformUpdateDomainCount: updateDomainCount
  }
}

output availabilitySetId string = availabilitySet.id
output availabilitySetName string = availabilitySet.name
