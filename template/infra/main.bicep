@description('Base name for all resources (will be prefixed to resource names)')
param projectName string

@description('Environment name (dev, staging, prod)')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environmentName string = 'dev'

@description('Location for all resources')
param location string = resourceGroup().location

@description('Container image to deploy (full path including registry)')
param containerImage string

@description('Azure AD Client ID for MSAL authentication')
@secure()
param azureClientId string

@description('Azure AD Tenant ID for MSAL authentication')
@secure()
param azureTenantId string

@description('API Base URL for the frontend')
param apiBaseUrl string

@description('Azure AD API Scope for MSAL')
param azureApiScope string = ''

@description('Disable authentication in development')
param devNoAuth bool = false

@description('CPU cores for container')
param containerCpu string = '0.5'

@description('Memory for container')
param containerMemory string = '1Gi'

@description('Minimum replicas')
param minReplicas int = 1

@description('Maximum replicas')
param maxReplicas int = 3

@description('Container port')
param containerPort int = 80

@description('Enable Azure Front Door for global CDN and WAF')
param enableFrontDoor bool = false

@description('Azure Front Door SKU')
@allowed([
  'Standard_AzureFrontDoor'
  'Premium_AzureFrontDoor'
])
param frontDoorSku string = 'Standard_AzureFrontDoor'

@description('Custom domain name for Front Door (optional)')
param customDomainName string = ''

@description('Enable WAF for Front Door')
param enableWaf bool = true

// Generate unique names for resources
var uniqueSuffix = uniqueString(resourceGroup().id, projectName, environmentName)
var acrName = 'acr${replace(projectName, '-', '')}${uniqueSuffix}'
var logAnalyticsName = 'log-${projectName}-${environmentName}-${uniqueSuffix}'
var appInsightsName = 'ai-${projectName}-${environmentName}-${uniqueSuffix}'
var managedIdentityName = 'id-${projectName}-${environmentName}-${uniqueSuffix}'
var containerAppEnvName = 'cae-${projectName}-${environmentName}-${uniqueSuffix}'
var containerAppName = 'ca-${projectName}-${environmentName}'
var frontDoorName = 'fd-${projectName}-${environmentName}-${uniqueSuffix}'

// Common tags
var commonTags = {
  project: projectName
  environment: environmentName
  managedBy: 'bicep'
}

// Log Analytics Workspace
module logAnalytics 'modules/log-analytics.bicep' = {
  name: 'logAnalyticsDeploy'
  params: {
    name: logAnalyticsName
    location: location
    sku: 'PerGB2018'
    retentionInDays: 30
    tags: commonTags
  }
}

// Application Insights
module appInsights 'modules/app-insights.bicep' = {
  name: 'appInsightsDeploy'
  params: {
    name: appInsightsName
    location: location
    workspaceResourceId: logAnalytics.outputs.id
    applicationType: 'web'
    tags: commonTags
  }
}

// Container Registry
module containerRegistry 'modules/container-registry.bicep' = {
  name: 'containerRegistryDeploy'
  params: {
    name: acrName
    location: location
    sku: 'Basic'
    adminUserEnabled: true
    tags: commonTags
  }
}

// Managed Identity
module managedIdentity 'modules/managed-identity.bicep' = {
  name: 'managedIdentityDeploy'
  params: {
    name: managedIdentityName
    location: location
    tags: commonTags
  }
}

// Assign AcrPull role to Managed Identity
resource acrPullRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(containerRegistry.outputs.id, managedIdentity.outputs.principalId, 'AcrPull')
  scope: resourceGroup()
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // AcrPull role
    principalId: managedIdentity.outputs.principalId
    principalType: 'ServicePrincipal'
  }
}

// Container App with Environment
module containerApp 'modules/container-app.bicep' = {
  name: 'containerAppDeploy'
  params: {
    environmentName: containerAppEnvName
    name: containerAppName
    location: location
    containerImage: containerImage
    containerRegistryServer: containerRegistry.outputs.loginServer
    managedIdentityId: managedIdentity.outputs.id
    logAnalyticsWorkspaceId: logAnalytics.outputs.id
    appInsightsConnectionString: appInsights.outputs.connectionString
    cpu: containerCpu
    memory: containerMemory
    minReplicas: minReplicas
    maxReplicas: maxReplicas
    containerPort: containerPort
    externalIngress: true
    environmentVariables: [
      {
        name: 'APP_API_BASE_URL'
        value: apiBaseUrl
      }
      {
        name: 'APP_AZURE_CLIENT_ID'
        value: azureClientId
      }
      {
        name: 'APP_AZURE_TENANT_ID'
        value: azureTenantId
      }
      {
        name: 'APP_AZURE_API_SCOPE'
        value: azureApiScope
      }
      {
        name: 'APP_DEV_NO_AUTH'
        value: string(devNoAuth)
      }
    ]
    tags: commonTags
  }
  dependsOn: [
    acrPullRoleAssignment
  ]
}

// Azure Front Door (optional)
module frontDoor 'modules/front-door.bicep' = if (enableFrontDoor) {
  name: 'frontDoorDeploy'
  params: {
    name: frontDoorName
    sku: frontDoorSku
    originHostName: containerApp.outputs.fqdn
    customDomainName: customDomainName
    enableWaf: enableWaf
    tags: commonTags
  }
}

// Outputs
@description('URL of the deployed Container App')
output containerAppUrl string = containerApp.outputs.url

@description('FQDN of the deployed Container App')
output containerAppFqdn string = containerApp.outputs.fqdn

@description('Container Registry login server')
output containerRegistryLoginServer string = containerRegistry.outputs.loginServer

@description('Container Registry name')
output containerRegistryName string = containerRegistry.outputs.name

@description('Application Insights Instrumentation Key')
output appInsightsInstrumentationKey string = appInsights.outputs.instrumentationKey

@description('Application Insights Connection String')
output appInsightsConnectionString string = appInsights.outputs.connectionString

@description('Log Analytics Workspace ID')
output logAnalyticsWorkspaceId string = logAnalytics.outputs.id

@description('Managed Identity Client ID')
output managedIdentityClientId string = managedIdentity.outputs.clientId

@description('Container App Name')
output containerAppName string = containerApp.outputs.name

@description('Front Door endpoint URL (if enabled)')
output frontDoorUrl string = enableFrontDoor ? frontDoor.outputs.endpointUrl : ''

@description('Front Door endpoint hostname (if enabled)')
output frontDoorEndpointHostName string = enableFrontDoor ? frontDoor.outputs.endpointHostName : ''

@description('Front Door profile name (if enabled)')
output frontDoorProfileName string = enableFrontDoor ? frontDoor.outputs.profileName : ''

@description('Custom domain hostname (if configured)')
output customDomainHostName string = enableFrontDoor ? frontDoor.outputs.customDomainHostName : ''

