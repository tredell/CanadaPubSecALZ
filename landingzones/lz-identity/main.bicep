// Private Dns Zones
@description('Boolean flag to determine whether Private DNS Zones will be centrally managed in the Hub.')
param deployPrivateDnsZones bool

@description('Private DNS Zone Resource Group Name.')
param rgPrivateDnsZonesName string


targetScope = 'subscription'


// Create Private DNS Zone Resource Group - optional
resource rgPrivateDnsZones 'Microsoft.Resources/resourceGroups@2020-06-01' = if (deployPrivateDnsZones) {
  name: rgPrivateDnsZonesName
  location: deployment().location
  //tags: resourceTags
}



// Private DNS Zones - optional
module privatelinkDnsZones '../../azresources/network/private-dns-zone-privatelinks.bicep' = if (deployPrivateDnsZones) {
  name: 'deploy-privatelink-private-dns-zones'
  scope: rgPrivateDnsZones
  params: {
    vnetId: 'Goa-cc-ident-vnet-10.112.176.0-255'
    dnsCreateNewZone: true
    dnsLinkToVirtualNetwork: true

    // Not required since the private dns zones will be created and linked to hub virtual network.
    dnsExistingZoneSubscriptionId: ''
    dnsExistingZoneResourceGroupName: ''
  }
}
