@description('Name of the Azure Front Door profile')
param name string

@description('Location for Azure Front Door (must be global)')
param location string = 'global'

@description('SKU for Azure Front Door')
@allowed([
  'Standard_AzureFrontDoor'
  'Premium_AzureFrontDoor'
])
param sku string = 'Standard_AzureFrontDoor'

@description('Backend origin hostname (Container App FQDN)')
param originHostName string

@description('Custom domain name (optional)')
param customDomainName string = ''

@description('Enable WAF')
param enableWaf bool = true

@description('Tags for the Front Door resources')
param tags object = {}

// Front Door Profile
resource frontDoorProfile 'Microsoft.Cdn/profiles@2023-05-01' = {
  name: name
  location: location
  sku: {
    name: sku
  }
  tags: tags
}

// Front Door Endpoint
resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2023-05-01' = {
  name: '${name}-endpoint'
  parent: frontDoorProfile
  location: location
  properties: {
    enabledState: 'Enabled'
  }
}

// Origin Group
resource originGroup 'Microsoft.Cdn/profiles/originGroups@2023-05-01' = {
  name: '${name}-origin-group'
  parent: frontDoorProfile
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/health'
      probeRequestType: 'GET'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
    sessionAffinityState: 'Disabled'
  }
}

// Origin (Container App)
resource origin 'Microsoft.Cdn/profiles/originGroups/origins@2023-05-01' = {
  name: '${name}-origin'
  parent: originGroup
  properties: {
    hostName: originHostName
    httpPort: 80
    httpsPort: 443
    originHostHeader: originHostName
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    enforceCertificateNameCheck: true
  }
}

// Route (maps endpoint to origin group)
resource route 'Microsoft.Cdn/profiles/afdEndpoints/routes@2023-05-01' = {
  name: '${name}-route'
  parent: frontDoorEndpoint
  properties: {
    customDomains: customDomainName != '' ? [
      {
        id: customDomain.id
      }
    ] : []
    originGroup: {
      id: originGroup.id
    }
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }
  dependsOn: [
    origin
  ]
}

// Custom Domain (if provided)
resource customDomain 'Microsoft.Cdn/profiles/customDomains@2023-05-01' = if (customDomainName != '') {
  name: replace(customDomainName, '.', '-')
  parent: frontDoorProfile
  properties: {
    hostName: customDomainName
    tlsSettings: {
      certificateType: 'ManagedCertificate'
      minimumTlsVersion: 'TLS12'
    }
  }
}

// WAF Policy (if enabled and Premium SKU)
resource wafPolicy 'Microsoft.Network/FrontDoorWebApplicationFirewallPolicies@2022-05-01' = if (enableWaf && sku == 'Premium_AzureFrontDoor') {
  name: '${replace(name, '-', '')}waf'
  location: 'global'
  sku: {
    name: sku
  }
  tags: tags
  properties: {
    policySettings: {
      enabledState: 'Enabled'
      mode: 'Prevention'
      requestBodyCheck: 'Enabled'
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'Microsoft_DefaultRuleSet'
          ruleSetVersion: '2.1'
          ruleSetAction: 'Block'
        }
        {
          ruleSetType: 'Microsoft_BotManagerRuleSet'
          ruleSetVersion: '1.0'
        }
      ]
    }
    customRules: {
      rules: [
        {
          name: 'RateLimitRule'
          priority: 100
          ruleType: 'RateLimitRule'
          rateLimitDurationInMinutes: 1
          rateLimitThreshold: 100
          matchConditions: [
            {
              matchVariable: 'RequestUri'
              operator: 'Contains'
              matchValue: [
                '/'
              ]
            }
          ]
          action: 'Block'
        }
      ]
    }
  }
}

// Security Policy (links WAF to endpoint)
resource securityPolicy 'Microsoft.Cdn/profiles/securityPolicies@2023-05-01' = if (enableWaf && sku == 'Premium_AzureFrontDoor') {
  name: '${name}-security-policy'
  parent: frontDoorProfile
  properties: {
    parameters: {
      type: 'WebApplicationFirewall'
      wafPolicy: {
        id: wafPolicy.id
      }
      associations: [
        {
          domains: [
            {
              id: frontDoorEndpoint.id
            }
          ]
          patternsToMatch: [
            '/*'
          ]
        }
      ]
    }
  }
}

@description('Front Door endpoint hostname')
output endpointHostName string = frontDoorEndpoint.properties.hostName

@description('Front Door endpoint URL')
output endpointUrl string = 'https://${frontDoorEndpoint.properties.hostName}'

@description('Front Door profile ID')
output profileId string = frontDoorProfile.id

@description('Front Door profile name')
output profileName string = frontDoorProfile.name

@description('Custom domain hostname (if configured)')
output customDomainHostName string = customDomainName != '' ? customDomainName : ''

@description('WAF policy ID (if enabled)')
output wafPolicyId string = enableWaf && sku == 'Premium_AzureFrontDoor' ? wafPolicy.id : ''

