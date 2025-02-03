<#
Simple output of system's hardware and OS meta data.
Will only work properly on Windows.

Uses nerd font symbols (https://www.nerdfonts.com/#home).
If the symbols don't render properly, please install and set up a nerd font or remove the symbols from the output.
#>

$cpu = Get-CimInstance Win32_Processor | Select-Object -ExpandProperty Name
$gpu = (Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name -Unique) -join ", "
$memory = [math]::Round((Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB, 3)

$disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
$totalDiskSpace = [math]::Round(($disks | Measure-Object -Property Size -Sum).Sum / 1GB, 3)
$usedDiskSpace = $totalDiskSpace - [math]::Round(($disks | Measure-Object -Property FreeSpace -Sum).Sum / 1GB, 3)

$windowsInfo = Get-CimInstance Win32_OperatingSystem
$windowsVersion = $windowsInfo.Caption
$windowsUpdateVersion = $windowsInfo.BuildNumber

Write-Output ""
Write-Output "󰟀 pcinfo -----------------------------------------------------------"
Write-Output " CPU:      $cpu"
Write-Output " GPU:      $gpu"
Write-Output " Memory:   $memory GB total"
Write-Output " Disk:     $usedDiskSpace GB / $totalDiskSpace GB (used / total)"
Write-Output " OS:       $windowsVersion, Build $windowsUpdateVersion"
Write-Output "--------------------------------------------------------------------"
Write-Output ""