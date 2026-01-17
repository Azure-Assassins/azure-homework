targetScope = 'managementGroup'

// @description('Target Management Group')
// param targetMG string

@description('An array of the allowed locations, all other locations will be denied by the created policy.')
param allowedLocations array = [
  'eastus'
]

var mgScope = tenantResourceId('Microsoft.Management/managementGroups', 'Finance-NonProd')
var policyDefinitionName = 'LocationRestriction'

resource policyDefinition 'Microsoft.Authorization/policyDefinitions@2020-03-01' = {
  name: policyDefinitionName
  properties: {
    displayName: 'Finance Standard: Location Restriction'
    description: 'Finance Standard: Only allow eastus'
    policyType: 'Custom'
    mode: 'All'
    parameters: {}
    policyRule: {
      if: {
        not: {
          field: 'location'
          in: allowedLocations
        }
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource policyAssignment 'Microsoft.Authorization/policyAssignments@2020-03-01' = {
  name: 'Finance-location-lock'
  properties: {
    scope: mgScope
    policyDefinitionId: extensionResourceId(mgScope, 'Microsoft.Authorization/policyDefinitions', policyDefinition.name)
  }
}
