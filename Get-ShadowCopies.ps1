# This script lists Shadow Copies on specified servers created over past 30 days
# Author: Sai Phaneendra A

#get the content of the server name and also set the number of days we need to check for shadowcopies
$computers = gc -Path C:\username\doc\serverlist.txt
$checkdays = 30


# Using WMI Win32_Volume to get drive letter from device id
Function Get-DriveLetters($server)
{
    $volumes = @{}
    $allvs = Get-WmiObject win32_volume  -Property DeviceID, Name
    foreach ($v in $allvs)
        {
            $volumes.add($v.DeviceID, $v.Name)
        }
    $volumes
}

Function Get-ShadowCopies
{
<# 
.SYNOPSIS
Checks Shadow Copy Status of specified servers for past 30 days.
.DESCRIPTION
Checks Shadow Copy Status on specified servers for past 30 days. You may push this script via Taskschuler in GPO or from SCCM PS feature.
.EXAMPLE
powershell.exe Get-ShadowCopies.ps1
No parameters required.
#>
    $copies = @()
    Foreach ($server in $computers)
        {
            $driveletters = Get-DriveLetters $server
            $shadowcopies = Get-WmiObject -Class "Win32_ShadowCopy" 
                Foreach ($copy in $shadowcopies)
                    {
                        $shadowcopy = New-Object System.Object

                        $date = [datetime]::ParseExact($copy.InstallDate.Split(".")[0], "yyyyMMddHHmmss", $null)

                        $shadowcopy | Add-Member -Type NoteProperty -Name Server -Value $server
                        $shadowcopy | Add-Member -Type NoteProperty -Name Date -Value $date
                        $shadowcopy | Add-Member -Type NoteProperty -Name Drive -Value $driveletters.Item($copy.VolumeName)
                        $shadowcopy | Add-Member -Type NoteProperty -Name Count -Value $copy.count
                        $shadowcopy | Add-Member -Type NoteProperty -Name Device -Value $copy.DeviceObject


                        If ($date -gt (Get-Date).AddDays(-$checkdays))
                            {
                                $copies += $shadowcopy
                            }
                    }
        }

#sorting the shadowcopies in descending order for easier visibility.

    $copies | Sort-Object Date -Descending
}
