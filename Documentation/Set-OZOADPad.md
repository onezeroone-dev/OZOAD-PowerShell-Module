# Set-OZOADPad
This function is part of the [OZOAD PowerShell Module](https://github.com/onezeroone-dev/OZOAD-PowerShell-Module/blob/main/README.md).

## Description
Enables or disables _Protection from Accidental Deletion_ for a given OU and all child OUs. Default action is Enable.

## Syntax
```
Set-OZOADPad
    -OrganizationalUnitDN <String>
    -Disable
```
## Parameters
|Parameter|Description|
|---------|-----------|
|`OrganizationalUnitDN`|The distinguished name of the organizational unit to process.|
|`Disable`|Disable Protection from Accidental Deletion for the OU and all child OUs.|

## Examples
### Example 1
```powershell
Set-OZOADPad -OrganizationalUnitDN "OU=People,DC=contoso,DC=com"
```
### Example 2
```powershell
Set-OZOADPad -OrganizationalUnitDN "OU=People,DC=contoso,DC=com" -Disable
```
