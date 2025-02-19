###############################################################################################
#
# Date:         14.02.2025
#
# Author:       Login Consultants Germany / Orange Business, Axel Broschinski (C) 2025
#
# FileName:     mdm-join.ps1
#
# Usage:       
#
# Version:      0.0.1.0
#
# Comment:      
#
# Arguments:    
#
# Changelog:    14.02.2025: 0.1.0.0 first release
#
###############################################################################################

###############################################################################################
# constants
###############################################################################################

###############################################################################################
## functions
################################################################################################

function IsUserAdmin () {
    # Get the current logged on user
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()

    # Create a principal object for the current user
    $userPrincipal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)

    # Check if the user is in the Administrators group
    if ($userPrincipal.IsInRole(
       [System.Security.Principal.WindowsBuiltInRole]::Administrator)
    ) {
        return $true
    } else {
        return $false
    }
}

function IsIntuneManaged () {
    if (Get-Service -Name 'IntuneManagementExtension' -ea SilentlyContinue) {
        return $true
    } else {
        return $false         
    }
}

function Log ($Message)
{
    $LogTime = get-date -format "dd.MM.yyyy HH:mm"
    Add-Content -Path $LogPath -Value "$($LogTime):[$env:USERNAME] $Message" -Encoding 'UTF8'
}

###############################################################################################
# main code
###############################################################################################

# get name of script
$ScriptName = $script:MyInvocation.MyCommand
# Determine script location for PowerShell
$ScriptDir = Split-Path $ScriptName.Path
$LogPath = "$ScriptDir\mdmjoin.log"
$URLFilePath = "$ScriptDir\mdmjoin.url"
$ServiceUIPath = "$ScriptDir\ServiceUI.exe"

Log "Start MDM Join Process ..."
Start-Process -FilePath $ServiceUIPath -ArgumentList "-process:explorer.exe explorer.exe $URLFilePath"
Log "MDM Join Process finished."
