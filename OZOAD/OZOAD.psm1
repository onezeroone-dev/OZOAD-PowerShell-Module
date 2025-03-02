Function Get-OZOADBitLockerRecovery {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns BitLocker recovery information for a given AD computer object.
        .PARAMETER ComputerName
        The AD computer to query for BitLocker recovery information.
        .EXAMPLE
        Get-OZOADBitLockerRecovery -ComputerName "DESKTOP-OZO80202"
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZOADBitLockerRecovery.md
    #>
    param(
        [Parameter(Mandatory=$true,HelpMessage="Computer name")][String]$ComputerName
    )
    Get-ADObject -Filter 'objectClass -eq "msFVE-RecoveryInformation"' -SearchBase (Get-ADComputer -Identity $ComputerName -ErrorAction Stop).DistinguishedName -Properties CN,whenCreated,msFVE-RecoveryPassword | Sort-Object whenCreated -Descending | Select-Object @{Name="Created";Expression={$_.whenCreated}},@{Name="PasswordID";Expression={[regex]::Matches($_.CN, '(?<={).+?(?=})').Value}},@{Name="Password";Expression={$_."msFVE-RecoveryPassword"}}
}

Function Get-OZOADComputers {
    param (
        [Parameter(Mandatory=$false,HelpMessage='List of computers')][System.Collections.Generic.List[String]]$ComputerList = @(),
        [Parameter(Mandatory=$false,HelpMessage='File containing computers')][String]$ComputerFile = $null,
        [Parameter(Mandatory=$false,HelpMessage='List of properties to obtain for each computer')][Array]$ComputerProperties = "*",
        [Switch]$Enabled
    )
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns an array of AD computers including specified properties.
        .PARAMETER UserFile
        A file containing computers to query (one per line). May be combined with ComputerList. Returns all computers when ComputerFile and ComputerList are not provided.
        .PARAMETER UserList
        A comma-separated list of computers to query. May be combined with ComputerFile. Returns all computers when ComputerFile and ComputerList are omitted.
        .PARAMETER UserProperties
        A comma-separated list of properties to return. When omitted, returns all properties.
        .PARAMETER Enabled
        Return only enabled computers.
        .EXAMPLE
        Get-OZOADComputers -ComputerList "DESKTOP-OZO80202","DESKTOP-OZO80203" -Properties "ManagedBy","PrimaryGroup" | Format-Table
        .EXAMPLE
        Get-OZOADComputers -ComputerFile "C:\Temp\users.txt" -Properties "ManagedBy","PrimaryGroup" | Export-Csv -Path "C:\Temp\ozoADComputers.csv"
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZOADUsers.md
    #>
    # Declare variables
    [System.Collections.Generic.List[PSCustomObject]] $ozoADComputers = @()
    # Determine if ComputerFile is provided
    If ([String]::IsNullOrEmpty($ComputerFile) -eq $false) {
        # ComputerFile is provided; append contents to ComputerList
        $ComputerList.Add((Get-Content -Path $ComputerFile -ErrorAction Stop))
    }
    # Determine if ComputerList has content
    If ($ComputerList.Count -gt 0) {
        # ComputerList has content; query identified users
        ForEach ($computer in ($ComputerList | Select-Object -Unique)) {
            $ozoADComputers.Add((Get-AdComputer -Identity $computer -Properties $ComputerProperties -ErrorAction Stop))
        }
    } Else {
        # ComputerList does not have content; query all computers
        $ozoADComputers = (Get-ADComputer -Filter * -ResultSetSize $null -Properties $ComputerProperties)
    }
    # Determine if Enabled is specified
    If ($Enabled -eq $true) {
        # Enabled is specified; return only enabled computers
        return $PSCmdlet.WriteObject(($ozoADComputers | Where-Object {$_.Enabled -eq $true} | Select-Object -Property $ComputerProperties))
    } Else {
        # Enabled is not specified; return all computers
        return $PSCmdlet.WriteObject(($ozoADComputers | Select-Object -Property $ComputerProperties))
    }
}

Function Get-OZOADUsers {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns an array of AD users including specified properties.
        .PARAMETER UserFile
        A file containing users to query (one per line). May be combined with UserList. Returns all users when UserFile and UserList are not provided.
        .PARAMETER UserList
        A comma-separated list of users to query. May be combined with UserFile. Returns all users when UserFile and UserList are omitted.
        .PARAMETER UserProperties
        A comma-separated list of properties to return. When omitted, returns all properties.
        .PARAMETER Enabled
        Return only enabled users.
        .EXAMPLE
        Get-OZOADUsers -UserList "msantos","gkaplan" -Properties "DisplayName","EmailAddress" | Format-Table
        .EXAMPLE
        Get-OZOADUsers -UserFile "C:\Temp\users.txt" -Properties "DisplayName","EmailAddress" | Export-Csv -Path "C:\Temp\ozoADUsers.csv"
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Get-OZOADUsers.md
    #>
    param (
        [Parameter(Mandatory=$false,HelpMessage='List of users')][System.Collections.Generic.List[String]]$UserList = @(),
        [Parameter(Mandatory=$false,HelpMessage='File containing users')][String]$UserFile = $null,
        [Parameter(Mandatory=$false,HelpMessage='List of properties to obtain for each user')][Array]$UserProperties = "*",
        [Switch]$Enabled
    )

    # Declare variables
    [System.Collections.Generic.List[PSCustomObject]] $ozoADUsers = @()
    # Determine if UserFile is provided
    If ([String]::IsNullOrEmpty($UserFile) -eq $false) {
        # UserFile is provided; append contents to UserList
        $UserList.Add((Get-Content -Path $UserFile -ErrorAction Stop))
    }
    # Determine if UserList has content
    If ($UserList.Count -gt 0) {
        # UserList has content; query identified users
        ForEach ($user in ($UserList | Select-Object -Unique)) {
            $ozoADUsers.Add((Get-AdUser -Identity $user -Properties $UserProperties -ErrorAction Stop))
        }
    } Else {
        # UserList does not have content; query all users
        $ozoADUsers = (Get-ADUser -Filter * -ResultSetSize $null -Properties $UserProperties)
    }
    # Determine if Enabled is specified
    If ($Enabled -eq $true) {
        # Enabled is specified; return only enabled users
        return $PSCmdlet.WriteObject(($ozoADUsers | Where-Object {$_.Enabled -eq $true} | Select-Object -Property $UserProperties))
    } Else {
        # Enabled is not specified; return all users
        return $PSCmdlet.WriteObject(($ozoADUsers | Select-Object -Property $UserProperties))
    }
}

Function New-OZOADExtendedRightsMap {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Creates a extended rights map which can be used for AD delegation tasks.
        .EXAMPLE
        [Hashtable]$erMap = (New-ADDExtendedRightsMap)
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/New-OZOADExtendedRightsMap.md
    #>
    # Declare variables
    [PSCustomObject] $rootdse = Get-ADRootDSE
    [Hashtable] $extendedrightsmap = @{}
    # Define parameters
    $ExtendedMapParams = @{
        SearchBase = ($rootdse.ConfigurationNamingContext)
        LDAPFilter = "(&(objectclass=controlAccessRight)(rightsguid=*))"
        Properties = ("displayName", "rightsGuid")
    }
    # Populate the hashtable
    Get-ADObject @ExtendedMapParams | ForEach-Object { $extendedrightsmap[$_.displayName] = [System.GUID]$_.rightsGuid }
    # Return
    return $extendedrightsmap
}

Function New-OZOADGuidMap {
    <#
        .SYNOPSIS
        See description
        .DESCRIPTION
        Returns aa GUID map which can be used for AD delegation tasks.
        .EXAMPLE
        [Hashtable]$guidMap = (New-OZOADDGuidMap)
        .OUTPUTS
        Hashtable
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/New-OZOADGuidMap.md
    #>
    # Declare variables
    [PsCustomObject] $rootdse = Get-ADRootDSE
    [Hashtable] $guidmap = @{}
    # Define parameters
    $GuidMapParams = @{
        SearchBase = ($rootdse.SchemaNamingContext)
        LDAPFilter = "(schemaidguid=*)"
        Properties = ("lDAPDisplayName", "schemaIDGUID")
    }
    # Populate the hashtable
    Get-ADObject @GuidMapParams | ForEach-Object { $guidmap[$_.lDAPDisplayName] = [System.GUID]$_.schemaIDGUID }
    # Return
    return $guidmap
}

Function Set-OZOADPad {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Enables or disables Protection from Accidental Deletion for a given OU and all child OUs. Default action is Enable.
        .PARAMETER OrganizationalUnitDN
        The distinguished name of the organizational unit to process.
        .PARAMETER Disable
        Disable Protection from Accidental Deletion for the OU and all child OUs.
        .EXAMPLE
        Set-OZOADPad -OrganizationalUnitDN "OU=People,DC=contoso,DC=com"
        .EXAMPLE
        Set-OZOADPad -OrganizationalUnitDN "OU=People,DC=contoso,DC=com" -Disable
        .LINK
        https://github.com/onezeroone-dev/OZO-PowerShell-Module/blob/main/Documentation/Set-OZOADPad.md
    #>
    param(
        [Parameter(Mandatory=$true,HelpMessage="The distinguished name of the organizational unit to process")][String]$OrganizationalUnitDN,
        [Parameter(Mandatory=$true,HelpMessage="Enable or disable Protection from Accidental Deletion")][Switch]$Disable
    )
    # Declare variables
    [Boolean] $Enable = $true
    # Determine if Disable is specified
    If ($Disable -eq $true) { $Enable = $false }
    # Set the flag
    Get-ADOrganizationalUnit -Filter * -SearchBase $OrganizationalUnitDN -SearchScope Subtree | ForEach-Object { Set-ADOrganizationalUnit -Identity $_.DistinguishedName -ProtectedFromAccidentalDeletion $Enable }
}

Export-ModuleMember -Function Get-OZOADBitLockerRecovery,Get-OZOADComputers,Get-OZOADUsers,New-OZOADExtendedRightsMap,New-OZOADGuidMap,Set-OZOADPad
