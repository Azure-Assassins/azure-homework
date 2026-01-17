targetScope = 'managementGroup'


resource financeTagPolicyDefinition 'Microsoft.Authorization/policyDefinitions@2020-03-01' = {
  name: 'Modify Department Tag'
  properties: {
    description: 'Appends the specified tag and value when any resource which is missing this tag is created or updated.'
    policyType: 'Custom'
    mode: 'All'
    parameters: {
      tagName: {
        type: 'String'
        metadata: {
          displayName: 'department'
          description: 'Tag name'
        }
      }
      tagValue: {
        type: 'String'
        metadata: {
          description: 'Tag value'
          displayName: 'finance'
        }
      }
    }
    policyRule: {
      if: {
        field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
        exists: false
      }
      then: {
        effect: 'modify'
        details: {
          roleDefinitionIds: [
            '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          operations: [
            {
              operation: 'add'
              field: '[concat(\'tags[\', parameters(\'tagName\'), \']\')]'
              value: '[parameters(\'tagValue\')]'
            }
          ]
        }
      }
    }
  }
}

resource financeTagPolicyAssignment 'Microsoft.Authorization/policyAssignments@2020-03-01' = {
  name: 'Finance-tag-assignment'
  location: 'eastus'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    policyDefinitionId: financeTagPolicyDefinition.id
    parameters: {
      tagName: {
        value: 'department'
      }
      tagValue: {
        value: 'finance'
      }
    }
  }
}

resource financeRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(tenantResourceId('Microsoft.Management/managementGroups', managementGroup().name),
    'finance-tag-modifier',
    financeTagPolicyAssignment.name) 
  properties: {
    principalId: financeTagPolicyAssignment.identity.principalId
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
}
