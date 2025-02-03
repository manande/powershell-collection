<#
  .SYNOPSIS
  Runs programs or groups of programs.

  .DESCRIPTION
  This script can be used to run programs or groups of programs.
  The programs can be specified in the file "config.json" in the same directory as this script.
  To configure an app, choose a name, the path to its executable, and optional parameters for the program.
  After configuring, programs can be started by simply running this script and passing one or more
  of the configured program names as arguments to the script.
  Program names can be assigned to groups, which can be started using the group name as argument, just like the
  app names. Group names and app names can be mixed in the invocation of the script.
  One app will not be started twice in a single call to the script. Thus, if you are using an app and a group
  that the app is referenced in, then the app is only started once.
  For apps that are installed via the Microsoft Store source, Windows sometimes assigns a new command that points
  to the executable of that app. An example is Firefox: After installing it via MS Store, it can be launched
  using just "firefox" from PowerShell. This name can be used as a substitute of the actual path in the config.
  Alternatively, you can use "Get-Command firefox" to get the path to the executable that the command points to.

  .PARAMETER RequestedItems
  The app and group names which should be started.

  .INPUTS
  None. You can't pipe objects to this script.

  .OUTPUTS
  Basic output on which programs are started or errors that occurred.

  .EXAMPLE
  PS> .\RunApps.ps1 vscode spotify

  .EXAMPLE
  PS> .\RunApps.ps1 gaming

  .EXAMPLE
  PS> .\RunApps.ps1 coding spotify
#>

param (
    [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
    [string[]]$RequestedItems
)

$configPath = "$PSScriptRoot\config.json"

function Invoke-ConfigError {
    param (
        [string]$Message
    )
    Write-Host "Config-Error: $Message `n($configPath)" -ForegroundColor Red
    exit 1
}

# load the config file
if (!(Test-Path $configPath)) {
    Invoke-ConfigError "Configuration file not found.
    Please ensure that there is a proper configuration file:
      1. rename `"config.json.example`" to `"config.json`"
      2. adapt the config to your needs"
}
$config = Get-Content -Raw -Path $configPath | ConvertFrom-Json -AsHashtable

$appConfigs = $config.apps
$appGroups = $config.groups
$allNames = $appConfigs.Keys + $appGroups.Keys

# ensure that there are no name conflicts in the config
$duplicateNames = $allNames | Group-Object | Where-Object { $_.Count -gt 1 } | Select-Object -ExpandProperty Name
if ($duplicateNames.Count -gt 0) {
    Invoke-ConfigError ("There are name conflicts in the config file. Please make sure that apps and groups have " +
    "unique names.`nDuplicates were found here: $($duplicateNames -join ', ')")
}
# ensure that apps referenced in groups exist
foreach ($group in $appGroups.GetEnumerator()) {
    foreach ($app in $group.Value) {
        if ($appConfigs.Keys -notcontains $app) {
            Invoke-ConfigError "App `"$app`" is referenced in group `"$($group.Key)`", but it is not configured."
        }
    }
}
# ensure that the requested items exist in the config
$unknownItems = $RequestedItems | Where-Object { -not $allNames.Contains($_) }
if ($unknownItems) {
    Invoke-ConfigError "The following apps or groups are not set up: $($unknownItems -join ', ')."
}

# compose unique set of apps that should be launched
$apps = New-Object System.Collections.Generic.HashSet[System.String]
foreach ($item in $RequestedItems) {
    if ($appGroups.Keys -contains $item) {
        foreach ($app in $appGroups.$item) {
            $null = $apps.Add($app)
        }
    } else {
        $null = $apps.Add($item)
    }
}
if ($apps.Count -eq 0) {
    Invoke-ConfigError "The given app groups are empty. Please ensure that there's at least one app to start."
}

# run apps
Write-Host "Running $($apps -join ', ')..."
foreach ($app in $apps) {
    $appConfig = $appConfigs.$app
    $appPath = [System.Environment]::ExpandEnvironmentVariables($appConfig.path)

    if ($appConfig.Contains("args")) {
        Start-Process -FilePath $appPath -ArgumentList $appConfig.args -RedirectStandardError "NUL"
    } else {
        Start-Process -FilePath $appPath -RedirectStandardError "NUL"
    }
}
