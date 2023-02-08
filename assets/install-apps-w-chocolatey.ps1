## Disable Activation notifications =======

Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform\Activation" -Name "Manual" -Value 1

## Disable Windows Update ======================================================

# set the Windows Update service to "disabled"
sc.exe config wuauserv start=disabled
# display the status of the service
sc.exe query wuauserv
# stop the service, in case it is running
sc.exe stop wuauserv
# display the status again, because we're paranoid
sc.exe query wuauserv
# disable the service from auto-starting at boot (that value is 0x03, 3 to humans)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv" -Name "Start" -Value 4
# double check it's REALLY disabled - Start value should be 0x4
REG.exe QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv /v Start
  # Can also use `Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv" -Name "Start"`
## take ownership of malicious file
#cmd.exe /c takeown /f "C:\Windows\System32\WaaSMedicPS.dll"
#icacls "C:\Windows\System32\WaaSMedicPS.dll" /grant administrators:F
## rename file, and create a dummy file in it's place
#if(![System.IO.File]::Exists("C:\Windows\System32\WaaSMedicPS.dll.bak")){
#  Rename-Item -Path "C:\Windows\System32\WaaSMedicPS.dll" -NewName "WaaSMedicPS.dll.bak"
#  New-Item -ItemType "file" -Path "C:\Windows\System32\WaaSMedicPS.dll"
#}

## disable Update Medic ==
#Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc" -Name "Start" -Value 4

## disable Update Orchestrator
Get-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator\" | Disable-ScheduledTask
  # disable individual items with:
  #Disable-ScheduledTask -TaskPath "\Microsoft\Windows\UpdateOrchestrator" -TaskName "Backup Scan"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\UsoSvc" -Name "Start" -Value 4

## Enable Windows Features =====================================================
# To get the `FeatureName` open an Admin PS terminal and enter something like:
# `Get-WindowsOptionalFeature -Online -FeatureName *Subsystem*`
# To determine which to use (if there's multiple), cross reference against the `DisplayName`.

# Enable virtualization for Docker
Enable-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online -NoRestart
Enable-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online -NoRestart
# Enable NFS for shares that support it
Enable-WindowsOptionalFeature -FeatureName ServicesForNFS-ClientOnly -Online -NoRestart

## Install Chocolatey ==========================================================

Set-ExecutionPolicy AllSigned
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

## Install Apps ================================================================

# auto-confirm installations
choco feature enable -n allowGlobalConfirmation

# applications
cinst 7zip.install # to handle files like .zip, .tar.gz, .rar, etc
#cinst adobereader -params '"/NoUpdates"'  # reader for PDF files
#cinst androidstudio # for Android App development
#cinst atom # IDE of choice
cinst classic-shell -installArgs ADDLOCAL=ClassicStartMenu # allows you customize Win10 to behave more like Win8
#cinst colortool # allows to easily change color schemes in cmd or wsl terminals
#cinst docker-desktop # for Docker development
#cinst evernote --ignore-checksums # notes. For some reason it says it fails the install, but succeeds
#cinst firefox # browser
cinst goggalaxy
cinst GoogleChrome # browser
#cinst handbrake.install # video encoding tool
cinst kodi
#cinst licecap # gif capture tool
cinst lxrunoffline # easily manage WSL VMs
cinst notepadplusplus.install
cinst partitionwizard # for resizing HD partitions
cinst RocketDock # OSX-like dock for Windows
cinst steam
cinst stexbar # add tools to Explorer like regex renaming of files
#cinst stickies # desktop sticky notes
cinst tortoisegit # adds git status icons to files/folders within Explorer
#cinst traystatus.portable # indicates whether caps/num lock are enabled
#cinst tvrenamer # rename TV show files
cinst uplay
cinst vlc # plays a majority of media files, using it for video
cinst winamp # simple & snappy audio player
#cinst winscp.install # secure FTP with nice GUI
cinst wox # OSX-like "Spotlight" tool 

# Not Used
# cinst nvm # doesn't work reliably
# cinst yarn # installed under WSL

# Portable
# cinst cygwin
# cinst cyg-get
# cinst conemu
# cinst blender # 2.8 stable isn't available yet, using zip
# cinst foobar2000
# cinst putty
# cinst tagscanner
# cinst tinymediamanager

# Unavailable
# amokplaylistcopy # once 'installed', it is portable
# svg explorer extension
