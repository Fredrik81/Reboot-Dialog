 Reboot-Dialog [![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Tool%20to%20remind%20users%20there%20are%20pending%20reboot%20with%20snooze%20options.&url=https://github.com/Fredrik81/Reboot-Dialog/blob/master/README.md&via=rydin_fredrik&hashtags=reminder,reboot,updates,ConfigMgr,SCCM,Windows10)
------
Will run silently in background and show a popup dialog when reboot is needed with snooze options.<br/>
![My image](/Images/Screenshot.png)

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
* Windows 10 (any version x86 or x64)
* Windows 8 & 8.1 (with .Net 4.6 or higher installed)
* Windows 7 SP1 (with .Net 4.6 or higher installed)

#### Windows 7 SP1 .Net 4.6 (unpatched except .Net 4.6)
![Windows 7 SP1](/Images/Windows7.png)

## How it works
When the program is started it will hide it self in the background. You will not see anything on the taskbar or system tray.<br/>
Every 5min if there is a pending reboot and if detected it will present a dialog to the user.<br/>
It will only allow one process to be started so if you even run this from a scheduled task. <br/>
You can see the process in task manager on the machine and also kill it there if you want.<br/>
![My image](/Images/Process.PNG)

Detection of reboot is made from three things at this time:
* Windows Update is installed and pending reboot<br/>
* Component Based Servicing is pending a reboot (can be turned on or off from config)<br/>
* Microsoft System Center Configuration Manager (SCCM) have installed update or application that require reboot<br/>
   SCCM Client is not needed it's just an extra check if you have it installed.<br/>
(More to come)<br/><br/>

SCCM client is not required it's just an extra check and this will work with an Intune only (or other management tool as well).<br/>

Default snooze options are set to 15min, 30min, 1 hour or 2 hours.<br/>

## Customizations
---
You can change picture, text fields and button text to make it look the way you want it or branded to your company.<br/>
All the text can be changed from the file "Reboot Dialog.exe.config".<br/>
To change picture, you need to place a file in the same directory called "Picture.png" with size 292x164.<br/>
[Demo of customizations](/Demo.md)
<br/>

### Multi-Language
The program support multi-language and you can add/change the texts from the file "Languages.xml".<br/>
If you need to change the built-in langauge than you can do that from the "Reboot Dialog.config" file.<br/>
Examples is found in the demo page: [Demo of customizations](/Demo.md)

### Test mode
Test mode can now be activated with command-line argument: /TestMode<br/>
Example: "C:\Program Files\RebootDialog\Reboot Dialog.exe" /TestMode<br/>
Test mode will force the reboot dialog to show after 5 seconds and the "reboot now" button will only close the application instead of rebooting.<br/>

### Customized Snooze options
You can customize snooze options from the applications configuration file (Reboot Dialog.exe.config).<br/>
![Snooze](/Images/Snooze.jpg)

Syntax: [Name];[Minutes];[Days Available]<br/>
Example:<br/>
30min;30<br/>
  * Snooze the reminder for 30min.<br/>

2 Hours;120;2<br/>
  * Snooze the reminder for 2 hours, this option will disapear after 2 days of snoozing.<br/>

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


---

Feel free to request features or submit bugs from the Issues part in github.<br/>
I hope you find it useful :-)<br/>

---
<br/>

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=RYV3HC2FTG2XS&currency_code=USD)[![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=Tool%20to%20remind%20users%20there%20are%20pending%20reboot%20with%20snooze%20options.&url=https://github.com/Fredrik81/Reboot-Dialog/blob/master/README.md&via=rydin_fredrik&hashtags=reminder,reboot,updates,ConfigMgr,SCCM,Windows10)
