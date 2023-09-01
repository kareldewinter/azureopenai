// Reference: https://github.com/Azure-Samples/react-component-toolkit-openai-demo/tree/main

targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Label used to generate a short unique hash used in all resources.')
param environmentName string = 'kdwt1'

@minLength(1)
@description('Primary location for all resources')
param location string = 'eastus'

param resourceGroupName string = 'rg-openai-01'

param openAiSkuName string = 'S0'
param openAiServiceName string = 'kdwtoai01'

param chatGptDeploymentName string = 'chat'
param chatGptModelName string = 'gpt-35-turbo'
param chatGptDeploymentCapacity int = 30

var abbrs = loadJsonContent('./abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))
var tags = { 'env-name': environmentName }

// Organize resources in a resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: !empty(resourceGroupName) ? resourceGroupName : '${abbrs.resourcesResourceGroups}${environmentName}'
  location: location
  tags: tags
}

module openAi './openai.bicep' = {
  name: 'openai'
  scope: resourceGroup
  params: {
    name: !empty(openAiServiceName) ? openAiServiceName : '${abbrs.cognitiveServicesAccounts}${resourceToken}'
    location: location
    tags: tags
    sku: {
      name: openAiSkuName

    }
    deployments: [
      {
        name: chatGptDeploymentName
        model: {
          format: 'OpenAI'
          name: chatGptModelName
          version: '0301'
        }
        scaleSettings: {
          scaleType: 'Standard'
        }
        sku: {
          capacity: chatGptDeploymentCapacity
        }
      }
    ]
  }
}

// Deployment outputs
output AOI_ENDPOINT string = openAi.outputs.endpoint
output AOI_DEPLOYMENT string = chatGptDeploymentName
