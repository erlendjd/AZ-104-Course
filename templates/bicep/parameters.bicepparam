using './main.bicep'

param location = 'norwayeast'
param vmName = 'az104-vm01'
param adminUsername = 'azureuser'
param adminPassword = readEnvironmentVariable('ADMIN_PASSWORD', 'ChangeM3-Now!')
param sku = 'StandardSSD_LRS'
param vmSize = 'Standard_B2als_v2'
param vnetAddressPrefix = '10.0.0.0/16'
param subnetAddressPrefix = '10.0.1.0/24'
param vnetName = 'az104-vnet01'
param subnetName = 'default'
param rdpAllowedSourceIp = '104.30.177.238/32'
