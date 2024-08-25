targetScope='subscription'

param masterIp string

#disable-next-line secure-secrets-in-params
param admPwd string

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'nextcloud'
  location: 'westeurope'
}

module db 'az_mysql.bicep' = {
  name: 'mysql_db'
  scope: rg
  params: {
    administratorLoginPassword: admPwd
    masterIpAddress: masterIp
  }
}