// ----------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES
// OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
// ----------------------------------------------------------------------------------

targetScope = 'managementGroup'

/*
@description('Top Level Management Group Name')
@minLength(2)
@maxLength(10)
param topLevelManagementGroupName string
*/

@description('Parent Management Group used to create all management groups, including Top Level Management Group.')
param parentManagementGroupId string

// Telemetry - Azure customer usage attribution
// Reference:  https://docs.microsoft.com/azure/marketplace/azure-partner-customer-usage-attribution
var telemetry = json(loadTextContent('../config/telemetry.json'))
module telemetryCustomerUsageAttribution '../azresources/telemetry/customer-usage-attribution-management-group.bicep' = if (telemetry.customerUsageAttribution.enabled) {
  name: 'pid-${telemetry.customerUsageAttribution.modules.managementGroups}'
}

// Level 1
resource topLevel 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG01'
  scope: tenant()
  properties: {
    displayName: 'Government of Alberta'
    details: {
      parent: {
        id: tenantResourceId('Microsoft.Management/managementGroups', parentManagementGroupId)
      }
    }
  }
}

// Level 2
resource platform 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG02'
  scope: tenant()
  properties: {
    displayName: 'Platform'
    details: {
      parent: {
        id: topLevel.id
      }
    }
  }
}

resource landingzones 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG03'
  scope: tenant()
  properties: {
    displayName: 'Landing Zones'
    details: {
      parent: {
        id: topLevel.id
      }
    }
  }
}

resource decommissioned 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG04'
  scope: tenant()
  properties: {
    displayName: 'Decommissioned'
    details: {
      parent: {
        id: topLevel.id
      }
    }
  }
}

resource nonproduction 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG05'
  scope: tenant()
  properties: {
    displayName: 'Non-Production'
    details: {
      parent: {
        id: topLevel.id
      }
    }
  }
}



resource westworld 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG13'
  scope: tenant()
  properties: {
    displayName: 'WestWorld'
    details: {
      parent: {
        id: topLevel.id
      }
    }
  }
}


// Level 3 - Platform
resource platformIdentity 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG06'
  scope: tenant()
  properties: {
    displayName: 'Identity'
    details: {
      parent: {
        id: platform.id
      }
    }
  }
}

resource platformManagement 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG07'
  scope: tenant()
  properties: {
    displayName: 'Management'
    details: {
      parent: {
        id: platform.id
      }
    }
  }
}

resource platformConnectivity 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG08'
  scope: tenant()
  properties: {
    displayName: 'Connectivity'
    details: {
      parent: {
        id: platform.id
      }
    }
  }
}

// Level 3 - Landing Zones

resource landingzonesIT 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG09'
  scope: tenant()
  properties: {
    displayName: 'IT'
    details: {
      parent: {
        id: landingzones.id
      }
    }
  }
}

resource landingzonesMinistries 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG10'
  scope: tenant()
  properties: {
    displayName: 'Ministries'
    details: {
      parent: {
        id: landingzones.id
      }
    }
  }
}


// Level 3 - Non-Production

resource nonprodSandbox 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG11'
  scope: tenant()
  properties: {
    displayName: 'Sandbox'
    details: {
      parent: {
        id: nonproduction.id
      }
    }
  }
}

resource nonprodDev 'Microsoft.Management/managementGroups@2020-05-01' = {
  name: 'MG12'
  scope: tenant()
  properties: {
    displayName: 'Development'
    details: {
      parent: {
        id: nonproduction.id
      }
    }
  }
}
