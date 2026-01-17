targetScope = 'managementGroup'

// Custom policy definition
resource tagPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Finance-Required-Tag'
  properties: {
    displayName: 'Require department tag'
    description: 'Ensures all resources have department:finance tag'
    mode: 'Indexed'
    parameters: {}
    policyRule: {
      if: {
        field: 'tags.department'
        exists: 'false'
      }
      then: {
        effect: 'modify'
        details: {
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor role
          ]
          operations: [{
            operation: 'addOrReplace'
            field: 'tags.department'
            value: 'finance'
          }]
        }
      }
    }
  }
}

// Policy assignment with managed identity
resource tagPolicyAssignment 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: 'assign-department-tag'
  location: deployment().location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Auto-tag resources with department'
    description: 'Automatically adds department:finance tag to resources'
    policyDefinitionId: tagPolicyDefinition.id
    scope: managementGroup().id
    enforcementMode: 'Default'
  }
}

// Role assignment for the managed identity
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(tagPolicyAssignment.id, '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx', 'Contributor')
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
    principalId: tagPolicyAssignment.identity.principalId
    principalType: 'ServicePrincipal'
    scope: managementGroup().id
  }
}
