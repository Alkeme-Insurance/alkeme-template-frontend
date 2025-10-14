@description('Name of the Application Insights instance')
param name string

@description('Location for the Application Insights instance')
param location string = resourceGroup().location

@description('Resource ID of the Log Analytics Workspace')
param workspaceResourceId string

@description('Application type')
@allowed([
  'web'
  'other'
])
param applicationType string = 'web'

@description('Tags for the Application Insights instance')
param tags object = {}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: applicationType
  tags: tags
  properties: {
    Application_Type: applicationType
    WorkspaceResourceId: workspaceResourceId
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

@description('Resource ID of the Application Insights instance')
output id string = applicationInsights.id

@description('Instrumentation Key of the Application Insights instance')
output instrumentationKey string = applicationInsights.properties.InstrumentationKey

@description('Connection String of the Application Insights instance')
output connectionString string = applicationInsights.properties.ConnectionString

@description('Name of the Application Insights instance')
output name string = applicationInsights.name

