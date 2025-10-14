@description('Name of the Managed Identity')
param name string

@description('Location for the Managed Identity')
param location string = resourceGroup().location

@description('Tags for the Managed Identity')
param tags object = {}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: name
  location: location
  tags: tags
}

@description('Resource ID of the Managed Identity')
output id string = managedIdentity.id

@description('Client ID of the Managed Identity')
output clientId string = managedIdentity.properties.clientId

@description('Principal ID of the Managed Identity')
output principalId string = managedIdentity.properties.principalId

@description('Name of the Managed Identity')
output name string = managedIdentity.name

