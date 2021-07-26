#Install Hyperv Role

Install-WindowsFeature -Name Hyper-v -IncludeManagementTools

#Create External Virtual Switch

Import-Module Hyper-V

$Private = Get-NetAdapter -Name Private

$Public = Get-NetAdapter -Name Public

 

New-VMSwitch -Name Private -NetAdapterName $Private.Name -AllowManagementOS $true 

New-VMSwitch -Name Public -NetAdapterName $Public.Name -AllowManagementOS $false 

 
