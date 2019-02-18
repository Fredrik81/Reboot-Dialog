# Reboot-Dialog
------
Will run silently in background and show a popup dialog when reboot is needed with snooze options.

## Download:
---
[Download from releases](https://github.com/Fredrik81/Reboot-Dialog/releases/latest "Latest Release")

I made this program to solve an issue i was facing where we did not want to force reboots of clients but simply inform them that a reboot was needed with a reminder dialog and snooze options.

## How it works and requirements
---
This program is made only for Windows and .Net 4.6+ is required (Built-in for Windows 10).
Detection of reboot is made from two things at this time:
1. Windows Update is installed and pending reboot
2. Microsoft System Center Configuration Manager (SCCM) have installed update or application that require reboot
(More to come)
It does not use/require network access and is fully customizable in the dialog.
Snooze options are set to 15min, 30min, 1 hour or 2 hours.
Program will check silently in the background every 5min if there is a pending reboot.

## Customizations
---
You can change picture, text fields and button text to make it look the way you want it or branded to your company.
All the text can be changed from the file "Reboot Dialog.exe.config".
To change picture you need to place a file in the same directory called "Picture.png" with size 292x164.
<br/>
![My image](Screenshot.PNG)
<br/>
### Test mode
You can enable test mode from the applications configuration file (Reboot Dialog.exe.config).
```XML
<setting name="TestMode" serializeAs="String">
    <value>True</value>
</setting>
```
Test mode will force the reboot dialog to show after 5 seconds and the "reboot now" button will only close the application instead of rebooting.


## Manual installation
---
1. Copy the files into a folder on the computer (in this example C:\Program Files\RebootDialog)
2. Add it to registry so it will start automatically (require admin rights)
   CMD window (as Admin: reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run /v RebootDialog /t REG_SZ /d "\\"C:\Program Files\RebootDialog\Reboot Dialog.exe\\"" /f<br/>
   or<br/>
   Powershell (also as admin): New-ItemProperty -Path HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name RebootDialog -Value '"C:\Program Files\RebootDialog\Reboot Dialog.exe"' -Force<br/>

I hope you find it usefull :-)
***

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=RYV3HC2FTG2XS&currency_code=USD)
