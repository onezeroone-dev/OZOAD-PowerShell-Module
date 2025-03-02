# Get-OZOADComputers
This function is part of the [OZOAD PowerShell Module](https://github.com/onezeroone-dev/OZOAD-PowerShell-Module/blob/main/README.md).

## Description
Returns an array of AD computers including specified properties.

## Syntax
```
Get-OZOADComputers
    -ComputerFile       <String>
    -ComputerList       <Array>
    -ComputerProperties <Array>
    -Enabled
```
## Parameters
|Parameter|Description|
|---------|-----------|
|`ComputerFile`|A file containing computers to query (one per line). May be combined with ComputerList. Returns all computers when ComputerFile and ComputerList are not provided.|
|`ComputerList`|A comma-separated list of computers to query. May be combined with ComputerFile. Returns all computers when ComputerFile and ComputerList are omitted.|
|`ComputerProperties`|A comma-separated list of properties to return. When omitted, returns all properties.|
|`Enabled`|Return only enabled computers.|

## Examples
### Example 1
```powershell
Get-OZOADComputers -ComputerList "DESKTOP-OZO80202","DESKTOP-OZO80203" -Properties "ManagedBy","PrimaryGroup" | Format-Table
```
### Example 2
```powershell
Get-OZOADComputers -ComputerFile "C:\Temp\computers.txt" -Properties "ManagedBy","PrimaryGroup" | Export-Csv -Path "C:\Temp\ozoADComputers.csv"
```
