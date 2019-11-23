# Setting Up Windows 10 Pro

These docs outline how I tweak Windows 10 after a new install, for personal
preference and a better development experience.

**Table of Contents**

- Windows Tweaks & Tips
  - [Windows Tweaks &amp; Tips](#windows-tweaks--tips)
  - [Backing Up &amp; Restoring Data](#backing-up--restoring-data)
  - [Allow Powershell Script Execution](#allow-powershell-script-execution)
  - [Disable Windows Defender](#disable-windows-defender)
  - [Disable User Account Control](#disable-user-account-control)
  - [Disable Firewall Notifications](#disable-firewall-notifications)
  - [Disable Focus Assist](#disable-focus-assist)
  - [Disable File Warnings for NAS](#disable-file-warnings-for-nas)
  - [Disable Thumbs.db files](#disable-thumbs-db-files)
  - [Installing Apps With Chocolatey](#installing-apps-with-chocolatey)
  - [Change Computer Name &amp; Workgroup](#change-computer-name--workgroup)
  - [Move User Content Folders to Another Drive](#move-user-content-folders-to-another-drive)
  - [Unlink Microsoft Account from Admin Profile](#unlink-microsoft-account-from-admin-profile)
  - [Create a Shortcut to AppData](#create-a-shortcut-to-appdata)
  - [Taskbar settings](#taskbar-settings)
  - [Remove Quick Access in Explorer](#remove-quick-access-in-explorer)
  - [Getting the Sleep Command to Work](#getting-the-sleep-command-to-work)
  - [Prevent Computer From Going to Sleep When Unattended](#prevent-computer-from-going-to-sleep-when-unattended)
  - [Keep Computer On When Lid Closed](#keep-computer-on-when-lid-closed)
  - [Network Setup](#network-setup)
  - [Run custom scripts at startup](#run-custom-scripts-at-startup)
  - [Troubleshooting](#troubleshooting)
    - [How to Get Product Key After Online Purchase](#how-to-get-product-key-after-online-purchase)
    - [How to Get System Info](#how-to-get-system-info)
    - [How to Determine What is Waking System While Sleeping](#how-to-determine-what-is-waking-system-while-sleeping)
- [Setting up WSL](./WSL.md)
- [App Tweaks](./APP-TWEAKS.md)

---

## Backing Up & Restoring Data

I haven't trusted the built-in Windows backup in years, perhaps it's gotten
better, but I've found it's easier to just backup files and restore what you
truly care about.

I created a [Powershell script](https://github.com/the0neWhoKnocks/powershell.moving-time) that allows me to define named paths of what to backup. It does so in a
mirrored directory structure to the output location, which allows for easy
restoration from the same script, or manually picking and choosing what you'd
like to restore.

---

## Allow Powershell Script Execution

- Open an Admin Powershell instance
- Run `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`

---

## Disable Windows Defender

- Disable real-time protection
  - Search for `security` > Choose `Windows Defender Security Center`
  - Go to `Virus & threat protection` > Virus & threat protection settings > Turn off all toggles
- `Win+R` type in `gpedit.msc` and hit Enter. This will open up a new menu, 
  where group policy editor options are listed.
- Head to the **Administrative Templates** tab, located under **Computer Configuration**.
- Click **Windows Components**, followed by **Windows Defender Antivirus**.
  - Find the **Turn off Windows Defender** option, and double-click it, check `Enabled`.
  - Click on the **Real-time Protection** folder, double-click on **Turn off real-time protection**, check `Enabled`.
- Apply your changes before exiting the GPE menu.

---

## Disable User Account Control

Anytime you install a new program, or run a program you've given admin rights to,
you'll be prompted with a confirmation dialog, which can get pretty annoying
after a while.

- Start > Search > UAC
- Choose **Change User Account Control settings**
- Drag the slider to the bottom **Never Notify**, click OK

---

## Disable Firewall Notifications

Settings > Notifications & Actions > (toggle off) Security and Maintenance

---

## Disable Focus Assist

If you're using a dock, this gets annoying.

Settings > Search for "focus assist" > Set to `Off`

---

## Disable File Warnings for NAS

Gets rid of those annoying **Windows Security - These files might be harmful to
your computer** warnings that pop up when you're trying to move files on a NAS.

- First, if you have any folders open pointing to the NAS, close them.
- Search for `Internet Options`
- Go the `Security` tab > `Local intranet` icon > `Sites` button > `Advanced` button
- Enter the IP of the NAS. If DNS isn't set up on your router wildcards are ok
  `192.168.1.*`.
- `Ok` out of all the dialogs.
- You may have to disconnect, and reconnect the drives, I didn't.

---

## Disable Thumbs.db files

- Open up `gpedit.msc`
- Navigate to `User Configuration > Administrative Templates > Windows Components`
  - Click on `File Explorer`
    - Double-click on `Turn off the display of thumbnails and only display icons on network folders`
      - Click `Enabled`
      - Click `Apply`
    - Double-click on `Turn off the caching of thumbnails in hidden thumbs.db files`
      - Click `Enabled`
      - Click `Apply`
- In an Admin `cmd` or `powershell` terminal, run `gpupdate /force`

---

## Installing Apps With Chocolatey

Once Windows is up and running, you'll want to get your apps installed before
restoring files and settings.

I've included a documented [Powershell script](./assets/install-apps-w-chocolatey.ps1)
that will:
- Disable Windows Update
- Enable certain Windows features
- Install Chocolatey
- Install applications

To make future installs or re-installs easier you can create a shortcut for the
script:
- Right-click `install-apps-w-chocolatey.ps1` > Create Shortcut
- Right-click the new shortcut > Properties
  - Change **Target** to be `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -f "<PATH_TO_FILE>\install-apps-w-chocolatey.ps1"`

After you've installed/configured any remaining apps, open the Task Manager, go
to the Startup tab, and Right-click and **Disable** anything you don't want
automatically starting on boot.

---

## Change Computer Name & Workgroup

This is needed if you've set up a custom workgroup for your internal network.

- Right-click Windows Start icon > System
- Computer Name > *Change* button

---

## Move User Content Folders to Another Drive

This is useful if you have multiple drives and want free up space on the OS drive.

- Create folders for each User folder you want to move. For example `<Drive>\Downloads`.
- Navigate to your current user directory, Right-click on
`Downloads` > `Properties` > `Location` > `Move`.
- Choose the new path for that folder, and `Apply`.
- You'll have to manually do it for all folders you want to change.

---

## Unlink Microsoft Account from Admin Profile

On new systems a user is forced into signing in for the first time with
their Microsoft email account. Doing so means you can't change the user name,
and everything's linked to Microsoft.

First, unlink your account:
- Settings > Accounts
- Click **Disconnect Microsoft Account**
- In the **Switch to a local account** window, type your current Microsoft
password and click **Next**.
- Fill in your username with your NMU UserID (such as jsmith), enter your
password, create a hint, and select **Next**. 
- On the final window, click **Sign out and Finish**.

The above will unlink your account, but your actual user profile folder may
still be named for the old account. To get that back in order, do this:
- Right-click Start, select Admin terminal
- Enable the Admin account `net user Administrator /active:yes`
- Sign out of current account, and into the newly activated Admin account
- Right-click Start, select **Computer Management**
  - Select **Users & Groups**
  - Select Users
  - Rename the old user name to the new one
- Go to `C:\Users\`
  - Rename the old user folder to the new name
- Run > `regedit`
  - Navigate to `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList` (or just paste this path in the top field).
  - Click on the folders until you see `ProfileImagePath` with the path to your
  old user folder.
    - Double-click on it, and update the folder name
  - Scroll to the top, highlight `Computer`, then go to `Edit` > `Find`
    - Look for `C:\Users\<old_name>`
    - Update any items that come up with the old name, hitting F3 after editing
    to find the next item.
- Sign out of the Admin account, sign back into your account
- Open Admin terminal
  - Disable the Admin account `net user Administrator /active:no`

---

## Create a Shortcut to AppData

- Go into your User folder `C:\Users\<USER_NAME>`
- Show hidden files, Explorer > View > (check) Hidden Items
- Right-click `AppData` > create a shortcut
- Hide hidden files
- Move shortcut to `D:\Profile\`

---

## Taskbar settings

- Right-click taskbar > uncheck Lock the taskbar
- Right-click taskbar > Settings
  - Combine taskbar buttons > When taskbar is full
  - Notification area > Select which icons appear on the taskbar
    - Always show all icons in the notification area

---

## Remove Quick Access in Explorer

- Open File Explorer
- Go to the **View** tab and click on **Options**
- Change the **Open File Explorer to** dropdown to `This PC`
- Uncheck **Show recently used files in Quick Access** &
**Show frequently used folders in Quick Access** at the bottom.

---

## Getting the Sleep Command to Work

- Open an Admin terminal
  - If running Classic Shell - SHIFT + Right-click on Start button
  - Command Prompt (Admin)
  - Disable the Hybernate option with `powercfg /h off`
- Open **Device Manager**
  - Mice and other pointing devices
    - (find your mouse)
    - right-click > Properties > Power Management > (uncheck) allow this device
    to wake the computer.
  - Keyboards
    - (find keyboard, usually HID...)
    - right-click > Properties > Power Management > (check) allow this device to
    wake the computer.
- You may have to enable an option in your Bios to allow for waking when in
sleep mode as well.

---

## Prevent Computer From Going to Sleep When Unattended

For some reason this is a hidden option

- Run > `regedit`
  - Go to `Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\7bc4a2f9-d8fc-4469-b07b-33eb785aaca0`
  - Double click on `Attributes`
  - Enter number `2`
- Settings > Power Options
  - Click on **Change plan settings**
  - Click on **Advanced power settings**
  - Click **Sleep**, then **System unattended sleep timeout**, then change
  these settings from `2 Minutes` to what ever you want.

---

## Keep Computer On When Lid Closed

- Control Panel > Power Options
- Choose what closing the lid does
  - Don't sleep when lid closed (when plugged in)

---

## Network Setup

- Control Panel > Network & Sharing
  - Change advanced sharing settings
    - Private
      - File & Printer sharing - Turn on ...
    - Guest or Public
      - Network discovery - Turn on network discovery

---

## Run custom scripts at startup

I use this in conjunction with [my mounting script](https://github.com/the0neWhoKnocks/powershell-network-mount) to set up network shares.

- Create a shortcut of the script
- Run > `shell:startup`
  - Move the shortcut to the Startup folder that opened.

---

## Troubleshooting

### How to Get Product Key After Online Purchase

If you purchase a license to Windows online they don't seem to give you easy
access to that license on their site.

- Right-click Start, select Admin terminal
- `wmic path SoftwareLicensingService get OA3xOriginalProductKey`

### How to Get System Info

In case you need info about amount of RAM, system name, drivers, etc.

Run > `msinfo32`

### How to Determine What is Waking System While Sleeping

Run (as Admin) > `powercfg -lastwake`

For example, that command informed me that an Intel ethernet device had woke my system.
I just had to Run > `devmgmt.msc`, go into **Network Adapters**, select the
device > Properties > Power Management > and disable the Allow this device to
wake options.
