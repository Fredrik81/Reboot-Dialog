#
# Name: Install.ps1
# By: Fredrik Rydin and copies of some function from PS Deployment Toolkit
# Description: This script will install the needed binaries for reboot dialog program and will also start it if user is logged in.
#              It will only start the process if the user singed in is following a domain user style (Domain\user)
#


#region Function Execute-ProcessAsUser
Function Execute-ProcessAsUser {
	[CmdletBinding()]
	Param (
		[Parameter(Mandatory=$true)]
		[ValidateNotNullorEmpty()]
		[string]$UserName,
		[Parameter(Mandatory=$true)]
		[ValidateNotNullorEmpty()]
		[string]$Path,
		[Parameter(Mandatory=$false)]
		[ValidateNotNullorEmpty()]
		[string]$Parameters = '',
		[Parameter(Mandatory=$false)]
		[ValidateSet('HighestAvailable','LeastPrivilege')]
		[string]$RunLevel = 'LeastPrivilege',
		[Parameter(Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[switch]$Wait = $false,
		[Parameter(Mandatory=$false)]
		[ValidateNotNullOrEmpty()]
		[boolean]$ContinueOnError = $true
	)
	
	Begin {
		## Get the name of this function and write header
		[string]${CmdletName} = $PSCmdlet.MyInvocation.MyCommand.Name
		Write-host "Starting Run As Different User..."
        $dirAppDeployTemp = $env:TEMP
        $appDeployToolkitName = "RebootDialogInstall"
        $exeSchTasks = "C:\Windows\System32\schtasks.exe"
	}
	Process {
		## Reset exit code variable
		If (Test-Path -Path 'variable:executeProcessAsUserExitCode') { Remove-Variable -Name executeProcessAsUserExitCode -Scope Global}
		$global:executeProcessAsUserExitCode = $null
		
		## Build the scheduled task XML name
		[string]$schTaskName = "$appDeployToolkitName-ExecuteAsUser"
		
		##  Create the temporary folder if it doesn't already exist
		If (-not (Test-Path -Path $dirAppDeployTemp -PathType Container)) {
            Write-Host "Err..."
			New-Item -Path $dirAppDeployTemp -ItemType Directory -Force -ErrorAction 'Stop'
		}
		
		## If PowerShell.exe is being launched, then create a VBScript to launch PowerShell so that we can suppress the console window that flashes otherwise
		If (($Path -eq 'PowerShell.exe') -or ((Split-Path -Path $Path -Leaf) -eq 'PowerShell.exe')) {
			[string]$executeProcessAsUserParametersVBS = 'chr(34) & ' + "`"$($Path)`"" + ' & chr(34) & ' + '" ' + ($Parameters -replace '"', "`" & chr(34) & `"" -replace ' & chr\(34\) & "$','') + '"'
			[string[]]$executeProcessAsUserScript = "strCommand = $executeProcessAsUserParametersVBS"
			$executeProcessAsUserScript += 'set oWShell = CreateObject("WScript.Shell")'
			$executeProcessAsUserScript += 'intReturn = oWShell.Run(strCommand, 0, true)'
			$executeProcessAsUserScript += 'WScript.Quit intReturn'
			$executeProcessAsUserScript | Out-File -FilePath "$dirAppDeployTemp\$($schTaskName).vbs" -Force -Encoding default -ErrorAction 'SilentlyContinue'
			$Path = 'wscript.exe'
			$Parameters = "`"$dirAppDeployTemp\$($schTaskName).vbs`""
		}
		
		## Specify the scheduled task configuration in XML format
		[string]$xmlSchTask = @"
<?xml version="1.0" encoding="UTF-16"?>
<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task">
  <RegistrationInfo />
  <Triggers />
  <Settings>
	<MultipleInstancesPolicy>StopExisting</MultipleInstancesPolicy>
	<DisallowStartIfOnBatteries>false</DisallowStartIfOnBatteries>
	<StopIfGoingOnBatteries>false</StopIfGoingOnBatteries>
	<AllowHardTerminate>true</AllowHardTerminate>
	<StartWhenAvailable>false</StartWhenAvailable>
	<RunOnlyIfNetworkAvailable>false</RunOnlyIfNetworkAvailable>
	<IdleSettings />
	<AllowStartOnDemand>true</AllowStartOnDemand>
	<Enabled>true</Enabled>
	<Hidden>false</Hidden>
	<RunOnlyIfIdle>false</RunOnlyIfIdle>
	<WakeToRun>false</WakeToRun>
	<ExecutionTimeLimit>PT72H</ExecutionTimeLimit>
	<Priority>7</Priority>
  </Settings>
  <Actions Context="Author">
	<Exec>
	  <Command>$Path</Command>
	  <Arguments>$Parameters</Arguments>
	</Exec>
  </Actions>
  <Principals>
	<Principal id="Author">
	  <UserId>$UserName</UserId>
	  <LogonType>InteractiveToken</LogonType>
	  <RunLevel>$RunLevel</RunLevel>
	</Principal>
  </Principals>
</Task>
"@
		## Export the XML to file
		Try {
			#  Specify the filename to export the XML to
			[string]$xmlSchTaskFilePath = "$dirAppDeployTemp\$schTaskName.xml"
			[string]$xmlSchTask | Out-File -FilePath $xmlSchTaskFilePath -Force -ErrorAction Stop
		}
		Catch {
			Write-Host "Failed to export the scheduled task XML file."
			If ($ContinueOnError) {
				Return
			}
			Else {
				[int32]$global:executeProcessAsUserExitCode = $schTaskResult.ExitCode
				Exit
			}
		}
		
		## Create Scheduled Task to run the process with a logged-on user account
		Try {
			If ($Parameters) {
				Write-Host "Create scheduled task to run the process [$Path $Parameters] as the logged-on user [$userName]..."
			}
			Else {
				Write-Host "Create scheduled task to run the process [$Path] as the logged-on user [$userName]..."
			}
            
			$schTaskResult = [Diagnostics.Process]::Start($exeSchTasks,"/create /f /tn $schTaskName /xml `"$xmlSchTaskFilePath`"").WaitForExit(10000)
			If ($schTaskResult -ne $true) {
				If ($ContinueOnError) {
                    write-host "mm"
					Return
				}
				Else {
                    Write-Host "aha.."
					[int32]$global:executeProcessAsUserExitCode = $schTaskResult
					Exit
				}
			}
		}
		Catch {
			Write-Host "Failed to create scheduled task."
			If ($ContinueOnError) {
				Return
			}
			Else {
				[int32]$global:executeProcessAsUserExitCode = $schTaskResult
				Exit
			}
		}
		
		## Trigger the Scheduled Task
		Try {
			If ($Parameters) {
				Write-Host "Trigger execution of scheduled task with command [$Path $Parameters] as the logged-on user [$userName]..."
			}
			Else {
				Write-Host "Trigger execution of scheduled task with command [$Path] as the logged-on user [$userName]..."
			}
            Write-Host "Starting it..."
            #Start-ScheduledTask -TaskPath / -TaskName $schTaskName
			$schTaskResult = [Diagnostics.Process]::Start($exeSchTasks, "/run /i /tn $schTaskName").WaitForExit(5000)
			If ($schTaskResult -ne $true) {
				If ($ContinueOnError) {
					Return
				}
				Else {
					[int32]$global:executeProcessAsUserExitCode = $schTaskResult
					Exit
				}
			}
		}
		Catch {
			Write-Host "Failed to trigger scheduled task."
			#  Delete Scheduled Task
			Write-Host 'Delete the scheduled task which did not to trigger.'
			[Diagnostics.Process]::Start($exeSchTasks, "/delete /tn $schTaskName /f")
			If ($ContinueOnError) {
				Return
			}
			Else {
				[int32]$global:executeProcessAsUserExitCode = $schTaskResult
				Exit
			}
		}
		
		## Wait for the process launched by the scheduled task to complete execution
		If ($Wait) {
			Write-Host "Waiting for the process launched by the scheduled task [$schTaskName] to complete execution (this may take some time)..."
			Start-Sleep -Seconds 1
			While ((($exeSchTasksResult = & $exeSchTasks /query /TN $schTaskName /V /FO CSV) | ConvertFrom-CSV | Select-Object -ExpandProperty 'Status' | Select-Object -First 1) -eq 'Running') {
				Start-Sleep -Seconds 5
			}
			#  Get the exit code from the process launched by the scheduled task
			[int32]$global:executeProcessAsUserExitCode = ($exeSchTasksResult = & $exeSchTasks /query /TN $schTaskName /V /FO CSV) | ConvertFrom-CSV | Select-Object -ExpandProperty 'Last Result' | Select-Object -First 1
			Write-Host "Exit code from process launched by scheduled task [$global:executeProcessAsUserExitCode]"
		}
		
		## Delete scheduled task
		Try {
			Write-Host "Delete scheduled task [$schTaskName]."
			[Diagnostics.Process]::Start($exeSchTasks, "/delete /tn $schTaskName /f")
		}
		Catch {
			Write-Host "Failed to delete scheduled task [$schTaskName]."
		}
	}
	End {
		Write-host "Process Finished.."
	}
}
#endregion

Stop-Process -Name SystemTimer -Force -ErrorAction SilentlyContinue
Stop-Process -Name "Reboot Dialog" -Force -ErrorAction SilentlyContinue
if (-not (Test-Path -Path 'C:\Program Files\RebootDialog' -PathType Container))
{
    New-Item -ItemType directory -Path 'C:\Program Files\RebootDialog' -ErrorAction SilentlyContinue
}
Copy-Item "$($PSScriptRoot)\Reboot Dialog.exe" -Destination "C:\Program Files\RebootDialog\" -Force
Copy-Item "$($PSScriptRoot)\Reboot Dialog.exe.config" -Destination "C:\Program Files\RebootDialog\" -Force
if (Test-Path -Path "$($PSScriptRoot)\Picture.png")
{
    Copy-Item "$($PSScriptRoot)\Picture.png" -Destination "C:\Program Files\RebootDialog\" -Force
}
New-ItemProperty -Path HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\Run -Name SystemTimer -Value '"C:\Program Files\RebootDialog\Reboot Dialog.exe"' -Force

#Get Logged in user
try {
    $user = (Get-WMIObject -class Win32_ComputerSystem | select username).username
    if ($user -notlike "*\*")
    {
        write-host "Not a domain user signed in..."
    } else {
        if (Test-Path "C:\Program Files\RebootDialog\Reboot Dialog.exe")
        {
            Write-Host "Starting Reboot Dialog.exe as $user..."
            Execute-ProcessAsUser -UserName $user -Path '"C:\Program Files\RebootDialog\Reboot Dialog.exe"'
        } else {
            Write-Host "Reboot Dialog.exe not found!" -ForegroundColor Red
        }
    }
} catch {
    write-host "Failed to get logged on user..." -ForegroundColor Red
}
