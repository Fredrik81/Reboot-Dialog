 Reboot-Dialog
------
Will run silently in background and show a popup dialog when reboot is needed with snooze options.

## Download:
---
[Download from releases](https://github.com/Fredrik81/Reboot-Dialog/releases/latest "Latest Release")

I made this program to solve an issue i was facing where we did not want to force reboots of clients but simply inform them that a reboot was needed with a reminder dialog and snooze options.<br/>

## Installation
Documented information on how to perform manual installation or automatic using powershell script.
The powershell can easily be added to for example SCCM to mass deploy.
[Install Instructions](https://github.com/Fredrik81/Reboot-Dialog/blob/master/Install/Install.md)

## How it works and requirements
---
### Requirements
This program is made only for Windows and .Net 4.6+ is required (Built-in for Windows 10).<br/>
It does not use/require network access and is fully customizable in the dialog.<br/>

### How it works
When the program is started it will hide it self in the background. You will not see anything on the taskbar or system tray.<br/>
Every 5min if there is a pending reboot and if detected it will present a dialog to the user.<br/>
It will only allow one process to be started so if you even run this from a scheduled task. <br/>
You can see the process in task manager on the machine and also kill it there if you want.<br/>
![My image](Process.PNG)

Detection of reboot is made from two things at this time:
1. Windows Update is installed and pending reboot<br/>
3. Component Based Servicing is pending a reboot (can be turned on or off from config)<br/>
2. Microsoft System Center Configuration Manager (SCCM) have installed update or application that require reboot<br/>
   SCCM Client is not needed it's just an extra check if you have it installed.<br/>
(More to come)<br/><br/>

Default snooze options are set to 15min, 30min, 1 hour or 2 hours.<br/>

## Customizations
---
You can change picture, text fields and button text to make it look the way you want it or branded to your company.<br/>
All the text can be changed from the file "Reboot Dialog.exe.config".<br/>
To change picture, you need to place a file in the same directory called "Picture.png" with size 292x164.<br/>
<br/>
![My image](Screenshot.PNG)
<br/>
### Test mode
Test mode can now be activated with command-line argument: /TestMode<br/>
Example: "C:\Program Files\RebootDialog\Reboot Dialog.exe" /TestMode<br/>

### Customized Snooze options
You can customize snooze options from the applications configuration file (Reboot Dialog.exe.config).<br/>
Syntax: [Name];[Minutes];[Days Available]<br/>
Example:<br/>
2 Hours;120;2<br/>
User can use this 2 hours snooze options for the first 2 days after reboot required is detected.<br/>

```XML
<setting name="SnoozeOptions" serializeAs="Xml">
    <value>
        <ArrayOfString xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema">
            <string>15min;15</string>
            <string>30min;30</string>
            <string>1hour;60;2</string>
            <string>2hours;120;1</string>
        </ArrayOfString>
    </value>
</setting>
```
Test mode will force the reboot dialog to show after 5 seconds and the "reboot now" button will only close the application instead of rebooting.<br/>

---

<br/>
I hope you find it useful :-)<br/>

---

## Planned Features
---
- [x] Flexibility of snooze time
- [x]  After X amount of time remove some snooze options (only allow shorter snooze time)
- [ ]  Command line options (first done for Test Mode)
- [ ]  More interface customization options

---
<br/>

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=RYV3HC2FTG2XS&currency_code=USD)
