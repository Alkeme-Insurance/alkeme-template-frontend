@description('Name of the Container Registry')
param name string

@description('Location for the Container Registry')
param location string = resourceGroup().location

@description('SKU for the Container Registry')
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param sku string = 'Basic'

@description('Enable admin user for the Container Registry')
param adminUserEnabled bool = true

@description('Tags for the Container Registry')
param tags object = {}

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  tags: tags
  properties: {
    adminUserEnabled: adminUserEnabled
    publicNetworkAccess: 'Enabled'
    policies: {
      quarantinePolicy: {
        status: 'Disabled'
      }
      trustPolicy: {
        type: 'Notary'
        status: 'Disabled'
      }
      retentionPolicy: {
        days: 7
        status: 'Disabled'
      }
    }
  }
}

@description('Login server for the Container Registry')
output loginServer string = containerRegistry.properties.loginServer

@description('Name of the Container Registry')
output name string = containerRegistry.name

@description('Resource ID of the Container Registry')
output id string = containerRegistry.id

