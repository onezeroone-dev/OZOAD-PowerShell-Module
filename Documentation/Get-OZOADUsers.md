# Get-OZOADUsers
This function is part of the [OZOAD PowerShell Module](https://github.com/onezeroone-dev/OZOAD-PowerShell-Module/blob/main/README.md).

## Description
Returns an array of AD users including specified properties.

## Syntax
```
Get-OZOADUsers
    -UserFile       <String>
    -UserList       <Array>
    -UserProperties <Array>
```
## Parameters
|Parameter|Description|
|---------|-----------|
|`UserFile`|A file containing users to query (one per line). May be combined with UserList. Returns all users when UserFile and UserList are not provided.|
|`UserList`|A comma-separated list of users to query. May be combined with UserFile. Returns all users when UserFile and UserList are omitted.|
|`UserProperties`|A comma-separated list of properties to return. When omitted, returns all properties.|
|`Enabled`|Return only enabled users.|

## Examples
### Example 1
```powershell
Get-OZOADUsers -UserList "msantos","gkaplan" -Properties "DisplayName","EmailAddress" | Format-Table
```
### Example 2
```powershell
Get-OZOADUsers -UserFile "C:\Temp\users.txt" -Properties "DisplayName","EmailAddress" | Export-Csv -Path "C:\Temp\ozoADUsers.csv"
```
