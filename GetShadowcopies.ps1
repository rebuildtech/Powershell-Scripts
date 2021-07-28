  #script to get the details of Shadow copy.
  

  $servers = gc -Path C:\path\serverlist.txt

  foreach ($s in $servers)
  Invoke-Command -ComputerName $s -ScriptBlock {

  #get the drive letter 
    $volumes = @{}
    $allvs = Get-WmiObject win32_volume
    foreach ($v in $allvs)
        {
            $volumes.add($v.DeviceID, $v.Name)
        }
 
  #get the ServerName . Volumename, Count and the Drive ID for those  

    foreach ($volume in $volumes)
    {
    Get-WmiObject Win32_shadowcopy  | Select OriginatingMachine, @{n="DriveID" ; E= {$volume.Values} } , VolumeName , Count 
    } 

    }

    Export-csv -Path C:\Users\test\output.csv -Delimiter ';' -Append
