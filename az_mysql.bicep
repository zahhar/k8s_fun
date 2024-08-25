param administratorLogin string = 'nextcloud_admin'
param serverName string = 'nextcloud-mysqlsrv'
param databaseName string = 'nextcloud_db'
param masterIpAddress string

#disable-next-line secure-secrets-in-params
param administratorLoginPassword string

resource server 'Microsoft.DBforMySQL/flexibleServers@2023-06-30' = {
  location: resourceGroup().location
  name: serverName
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    version: '8.0.21'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    availabilityZone: ''
    highAvailability: {
      mode: 'Disabled'
      standbyAvailabilityZone: ''
    }
    storage: {
      storageSizeGB: 20
      iops: 360
      autoGrow: 'Disabled'
    }
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
  }
}

resource fwRule1 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2021-12-01-preview' = {
  parent: server
  name: 'k8s'
  properties: {
    startIpAddress: '185.4.72.4'
    endIpAddress: '185.4.72.4'
  }
}

resource fwRule2 'Microsoft.DBforMySQL/flexibleServers/firewallRules@2021-12-01-preview' = {
  parent: server
  name: 'master'
  properties: {
    startIpAddress: masterIpAddress       
    endIpAddress: masterIpAddress   
  }
}

resource database 'Microsoft.DBforMySQL/flexibleServers/databases@2023-06-30' = {
  parent: server
  name: databaseName
  properties: {
    charset: 'utf8'
    collation: 'utf8_general_ci'
  }
}

resource config 'Microsoft.DBforMySQL/flexibleServers/configurations@2023-06-30' = {
  name: 'require_secure_transport'
  parent: server
  properties: {
    currentValue: 'ON'
    source: 'user-override'
    value: 'OFF'
  }
}