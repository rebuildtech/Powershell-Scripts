#This script is used to get CPU Load data and remove the logs older than 30 days

$time = Get-Date -Format "MMddyyyyHHmm"
Get-Process -IncludeUserName | Select Handles,WS,CPU,Id,SI,ProcessName,UserName,path | 
Sort-Object CPU -Descending | 
Format-Table -AutoSize  | 
Out-File "C:\Scripts\CPULoad\$time.txt"
Get-ChildItem –Path  "C:\Scripts\CPULoad\$time.txt" –Recurse | Where-Object { $_.CreationTime –lt (Get-Date).AddDays(-30) } | Remove-Item
