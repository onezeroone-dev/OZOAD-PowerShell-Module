# Get-OZOADBitLockerRecovery
This function is part of the [OZOAD PowerShell Module](https://github.com/onezeroone-dev/OZOAD-PowerShell-Module/blob/main/README.md).

## Description
Returns BitLocker recovery information for a given AD computer object.

## Syntax
```
Get-OZOADBitLockerRecovery
    -ComputerName <String>
```
## Parameters
|Parameter|Description|
|---------|-----------|
|`ComputerName`|The AD computer to query for BitLocker recovery information.|

## Examples
```powershell
Get-OZOADBitLockerRecovery -ComputerName "DESKTOP-OZO80202"
```
