# Create MDM URL File to join Intune

# ----------------- Constants -----------------------
$AADJoinMode = "MDM"
$AADTenantID = ""
$AADDomainSuffix = "@um-orange.com"
$MDMManagementServer = "enterpriseenrollment.manage.microsoft.com"
$MDMEnrollmentMode = 2                   # 2=Personal Device / 3=Company Device

$ScriptDir = "C:\Scripts\Intune"
$URLFileName = "$ScriptDir\mdmjoin.url"

# ------------------ Script ------------------------
# Create URL Link File
$JoinCommand = "ms-device-enrollment:?mode=$AADJoinMode&username=$AADDomainSuffix&servername=$MDMManagementServer&ownership=$MDMEnrollmentMode"

# Create Script Directory if not exists
if (!(Get-Item $ScriptDir)) {
    New-Item -Path $ScriptDir -ItemType "directory"
}

$WshShell = New-Object -COMObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut($URLFileName)
$Shortcut.TargetPath = "$JoinCommand"
$Shortcut.Save()
