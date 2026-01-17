targetScope = 'managementGroup'

resource regionPolicy 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'restrict-to-eastus'
  properties: {
    displayName: 'Allow only East US region'
    description: 'Restricts Finance Dev/Test to East US only'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
    parameters: {
      listOfAllowedLocations: {
        value: [
          'eastus'
        ]
      }
    }
  }
}
