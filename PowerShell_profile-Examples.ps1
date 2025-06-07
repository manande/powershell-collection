<#
This is a collection of command shortcuts and aliases that can be used in $PROFILE.
#>

# get the full paths to all files in the given directory
Function LsPath {Get-ChildItem | Select-Object -ExpandProperty FullName}
# create a new file using the touch command
Set-Alias -Name touch -Value New-Item

# aliases for the scripts included in this repo
# adapt the paths as needed
Set-Alias -Name pcinfo -Value "C:\Users\%USERNAME%\Projects\powershell-collection\PcInfo\PcInfo.ps1"
Set-Alias -Name runapps -Value "C:\Users\%USERNAME%\Projects\powershell-collection\RunApps\RunApps.ps1"
