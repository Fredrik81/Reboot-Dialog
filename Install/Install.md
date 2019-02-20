# Install Instructions

## Manual installation
---
1. Copy the files Reboot Dialog.exe, Reboot Dialog.exe.conf (and Picture.png if you have that) into a folder on the computer (in this example C:\Program Files\RebootDialog)<br/>
2. Add it to registry so it will start automatically (require admin rights)<br/>
   CMD window (as Admin: reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v RebootDialog /t REG_SZ /d "\\"C:\Program Files\RebootDialog\Reboot Dialog.exe\\"" /f<br/>
   or<br/>
   Powershell (also as admin): New-ItemProperty -Path HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name RebootDialog -Value '"C:\Program Files\RebootDialog\Reboot Dialog.exe"' -Force<br/>

## Automatic installation
1. Grab the powershell script from: [Install.ps1](https://github.com/Fredrik81/Reboot-Dialog/raw/master/Install/Install.ps1)
1. Put the powershell script in a folder together with the program files Reboot Dialog.exe, Reboot Dialog.exe.conf (and Picture.png if you have that)
1. Execute the Powershell script
   * From SCCM package that would be: powershell.exe -ExecutionPolicy ByPass -File Install.ps1

This will install the program in "C:\Program Files\RebootDialog" and also start it in the background in case a domain user is logged in

## Testing the program when not running in /testmode
You can make the program trigger the dialog if you open registry editor and create a sub key for let's say Windows Update
Create the key/folder "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired"
* Please note that windows update will remove this after a while when it is detecting that reboot is actually not needed...
Within 5min after this key is created the dialog will show. At this time the program is live and if you press the Reboot Now button it will trigger a restart of the device.<br/>

![WindowsUpdate](/Install/WindowsUpdate.jpg)

