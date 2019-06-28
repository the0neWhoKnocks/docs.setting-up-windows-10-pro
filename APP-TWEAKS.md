# App Tweaks

---

## Notepad++

GUI
- Preferences
  - Editing
    - (check) Show vertical edge
    - Border Width (check) No edge
  - Language
    - Tab Settings
      - Tab size: `2`
      - (check) Replace by space
  - MISC.
    - (uncheck) Enable Notepad++ auto-updater

Styling
- Settings > Style Configurator
- Select Theme: `Zenburn`

Markdown Support
- Download https://raw.githubusercontent.com/Edditoria/markdown-plus-plus/master/theme-zenburn/userDefinedLang-markdown.zenburn.modern.xml
- Language > Define Your Language > Import > (choose downloaded file)
- Restart
- Delete janky default
  - Language > Define Your Language
    - Select `Markdown (Default)` in dropdown
	- Select `Remove`
  
---

## Docker

Settings
- General
  - (uncheck) Automatically check for updates
  - (uncheck) Send usage statistics
  - (check) Expose daemon on tcp...
- Shared Drives
  - (check) what drives you want docker containers to have access to, for volume mounts and such.

If you want to backup your images
- Go to `C:\Users\Public\Documents\Hyper-V\Virtual hard disks`
- Copy `MobyLinuxVM.vhdx` to an external drive
- On the new machine, turn off Docker (if it's running)
- Overwrite the current `MobyLinuxVM.vhdx` with your old one.
- Restart Docker. It may complain about `Containers need to be enabled` and then
it'll restart the system, but after a reboot things seem to be fine. You can
run `docker images` to see all your old images.

Refer to this doc for [Docker and WSL notes](https://gist.github.com/the0neWhoKnocks/b45db9ddaede64a2e19dce712524fabb).

---

## StExBar

- Open a folder
- Click on View > Click on the dropdown arrrow for Options > StExBar
- Options
  - Misc
    - (uncheck) Show button text on toolbar
    - (uncheck) Copy UNC paths
    - (check) Hide edit box
  - Custom Commands
    - Keep - Options, Show system files, & Rename
    - Remove the rest

---

## Firefox

- Navigate to `C:\Users\<USER>\AppData\Roaming\Mozilla\Firefox`
- Copy over your old profile folder to `Profiles`, take note of the profile folder name.
- Inside of `installs.ini`, find the item that has `Locked=1`, that's the current profile.
  - Change it's value to be `Default=Profiles/<OLD_PROFILE_FOLDER_NAME>`
- Inside of `profiles.ini` find the `Locked=1` item and do the same for it's
`Default=` value, and for the `Path=` value below it.

---

## Traystatus

- Go to `C:\ProgramData\chocolatey\lib` and move `traystatus.portable` to a
directory where you want it to live permanently.
- Run it from the new directory `D:\Programs\traystatus.portable\tools\TrayStatus\TrayStatus.exe`
  - Options
    - (check) Start with Windows
    - (uncheck) Check for Updates
    - Click the `Internet Connection Settings` button
      - Select `Use Custom Proxy Server Settings`
      - Server Address: `disabled-tray-status` (so it hopefully doesn't try to connect to anything)
  - License Key
    - Delete the temporary "Pro" key to immediately opt into the Free version.

---

## Fix applications that need to run with Admin rights

- These apps need this - RocketDock, Kodi
- Run > `%PROGRAMFILES(x86)%`
- Right-click on the app folder > Properties > Security > click Edit
- Under *Group or user names:*, click on *Users (COMPUTER_NAME)\Users*
- Under *Permissions for Users*, check *Full control* and then click *Apply*.

Or for stuff like `ConEMU`
- Go into their folder and select the `.exe` (`C:/ConEmu/App/ConEmu/ConEmu.exe` for example)
- Right-Click > Properties
- Compatibility tab > check `Run this program as an admin`

---

## Hook Steam up to Kodi

- Download SuperRepo for your Kodi version from http://srp.nu/jarvis/all/superrepo.kodi.jarvis.all-0.7.04.zip
- Unzip the contents into KODI/portable_data/addons
- Kodi > System > Add-Ons > Install from Repository > Superrepo all > Program Add-Ons
- Scroll down to Steam, and Install
  - The below is for the Rapier skin
  - System > Skin Settings > Home > Add More Categories
  - Custom1 (check)
    - Type: Preset
      Path: Programs > Select Add-On > Steam
      Custom Icon: HomeFolder > userdata > media > icons > steam
      Category Images
        No Focus: special://skin/extras/steam-text-nofocus.png
        Focus: special://skin/extras/steam-text-focus.png
      Background:
        Single Image: HomeFolder > userdata > media > backgrounds > steam
