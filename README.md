# powershell-collection

This is a collection of PowerShell scripts that I created to have a nicer experience on Windows.


## setup guide for beginners

For a simple, yet nice PowerShell experience on Windows, I recommend:  
* WinGet for installing and updating software: https://learn.microsoft.com/en-us/windows/package-manager/winget/
* Windows Terminal: https://github.com/microsoft/terminal
* starship prompt: https://github.com/starship/starship

To try out the scripts, you can run them using the `pwsh` command.  
To run the scripts using a custom name, you can extend your PowerShell profile with aliases. Check out [PowerShell_profile-Examples.ps1](./PowerShell_profile-Examples.ps1) for some examples. To edit your profile, e.g. using vscode, use `code $PROFILE`.


## running Windows Terminal with PcInfo on Windows startup

I like to have Windows Terminal set up as startup application, in order to quickly run the programs I need using [RunApps](./RunApps/README.md), depending on what I plan to do.  
To make the first startup after reboot to also show [PcInfo](./PcInfo/README.md) as a greeting screen, but prevent subsequent startups of Windows Terminal to display PcInfo, you can do the following:  
* set up an additional PowerShell profile in Windows Terminal that runs PowerShell and additionally runs PcInfo:
  * clone the default PowerShell profile, and in the new profile, change the command line value to something like `"C:\Program Files\PowerShell\7\pwsh.exe" -NoExit -File "C:\Users\%USERNAME%\Projects\powershell-collection\PcInfo\PcInfo.ps1"` (adapt paths so they match your system)
* create a shortcut to Windows Terminal in your startup folder that runs the new profile
  * get to your startup folder: press WIN+R and run `shell:startup`
  * create a shortcut to Windows Terminal that runs the profile: set `C:\Users\%USERNAME%\AppData\Local\Microsoft\WindowsApps\wt.exe -p "PowerShell+"` as the target of the shortcut (adapt to your system and replace the profile name `PowerShell+` with your new profile's name)
* leave the default Windows Terminal profile (or any other profile that you like), so that PcInfo is only run on the first startup after reboot
