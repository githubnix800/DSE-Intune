###############################################################################################
#
# Date:         14.02.2025
#
# Author:       Login Consultants Germany / Orange Business, Axel Broschinski (C) 2025
#
# FileName:     Create-MDM-Join-Task.ps1
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
# parameters
###############################################################################################

param (
    $ComputerName = ""
)

###############################################################################################
# constants
###############################################################################################

$ServiceUIPath = "$env:windir\system32"
$TaskName = "JoinMDM"
$TaskPath = "\DSE\"
$TaskDelay = 2

$ScriptDir = "C:\Scripts\Intune"
$ScriptFile = "$ScriptDir\mdm-join.ps1"
$URLFileName = "$ScriptDir\mdmjoin.url"


###############################################################################################
## functions
################################################################################################

function IsUserAdmin ([boolean]$ShowAllProperties = $false) {
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
function Log ($Message)
{
    $LogTime = get-date -format "dd.MM.yyyy HH:mm"
    Add-Content -Path $LogPath -Value "$($LogTime):[$env:USERNAME] $Message" -Encoding 'UTF8'
}

###############################################################################################
# main code
###############################################################################################

$TaskTrigger = New-ScheduledTaskTrigger -AtLogOn
$TaskTrigger.Delay = 'PT2M'                # Task delay: 2 Minutes
$TaskAction = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File $ScriptFile"

$ScriptBlock = {
    param (
        $TaskName,
        $TaskPath,
        $TaskAction,
        $TaskTrigger,
        $ScriptDir
    )
    $ComputerName = $env:COMPUTERNAME

    If (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -Confirm:$false
        Write-Host "Task $TaskName removed from $ComputerName"
    }
    
    Register-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath -User "System" -Action $TaskAction -Trigger $TaskTrigger -RunLevel Highest
    #Disable-ScheduledTask -TaskName $TaskName -TaskPath $TaskPath
    Write-Host "Task $TaskName registered on $ComputerName"

    # Create Script Directory if not exists
    if (!(Get-Item $ScriptDir)) {
        New-Item -Path $ScriptDir -ItemType "directory"
    }
}

Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock -ArgumentList $TaskName, $TaskPath, $TaskAction, $TaskTrigger, $ScriptDir

#Finally copy Script files
$ScriptName = $script:MyInvocation.MyCommand
$LocalScriptDir = Split-Path $ScriptName.Path

$PS = New-PSSession $ComputerName
Copy-Item -ToSession $PS $URLFileName -Destination "$ScriptDir\mdmjoin.url"
Copy-Item -ToSession $PS "$LocalScriptDir\mdm-join.ps1" -Destination "$ScriptDir\mdm-join.ps1"
Copy-Item -ToSession $PS "$LocalScriptDir\ServiceUI.exe" -Destination "$ScriptDir\ServiceUI.exe"
Remove-PSSession $PS
