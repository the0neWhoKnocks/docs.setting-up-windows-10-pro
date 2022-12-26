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
      - You may encounter some files (like .yml) aren't respecting your settings.
      You'll just have to scroll down to the language (in the same list), select
      it, and then check **Use default value** to use global settings.
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

## Fix applications that need to run with Admin rights

- These apps need this - RocketDock, Kodi
- Run > `%PROGRAMFILES(x86)%`
- Right-click on the app folder > Properties > Security > click Edit
- Under *Group or user names:*, click on *Users (COMPUTER_NAME)\Users*
- Under *Permissions for Users*, check *Full control* and then click *Apply*.

---

## Kodi

- Let the amp handle the audio. Go to Settings > System > Audio Output
  - Number of channels: 7.1
  - The below may give you better sound, but at the cost of not being able
  to control the volume via Kodi
    - Enable Passthrough: check
    - Dolby Digital Capable Reciever: check
    - DTS Capable Reciever: check

### Install Advanced Emulator Launcher

[Forum](https://forum.kodi.tv/showthread.php?tid=287826)
[Repo](https://github.com/Wintermute0110/plugin.program.AEL)
[Install Directions](https://github.com/Wintermute0110/plugin.program.AEL#installing-the-latest-development-version)

- First create a folder that'll house shortcuts to the executables for
your games. Then create/copy over those shortcuts to the folder.
  - Create an `artwork` folder in that folder.
- Download the linked zip file, extract it, and re-zip it.
  - Since I was on an older verion of Kodi, I had to update the `xbmc.python`
  version in the `addon.xml` file before zipping it up again. For Jarvis,
  the version is `2.24.0`.
- In Kodi, go to System > Addons > Install from Zip
- Once it's installed, go to the Programs > Add-Ons
  - Select Advanced Eumulator Launcher
    - Go to the bottom of the list (Browse By...) and open the Context
    menu (C on keyboard)
      - Select `Add New Launcher`
      - Choose `LNK Launcher`
      - Select the folder with the shortcuts
      - Name the launcher
      - Choose `Microsoft Xbox One` for the Platform.
      - Select the `artwork` folder
    - Once the new launcher has been created, select it and open the Context
    menu for it and choose `Scan ROMs`.

---

## Steam

For a new install you'll have to log in, and maybe re-add your computer as a trusted system.

- Open up Steam (not Big Picture)
  - Wire up external games Library by going to Settings > Downloads
    - Click on Steam Library Folders
    - Click Add Library Folder
    - Set it to `<EXTERNAL_DRIVE>/Games`
    - Right-click the new path and choose `Make Default Folder`
  - Disable start on startup by going to Settings > Interface
    - Uncheck `Run Steam when my computer starts`
 
---

GOG

- Go into Settings
  - Disable auto-start in `General`, uncheck `Launch on system start`
  - Disable game auto-updates in `Features`, uncheck `Auto-update games`
  - Wire up external games Library by going to `Downloads`
    - Set Game Installation Folder to the `<EXTERNAL_DRIVE>/Games` folder on the external drive
    - Set Other Downloads to `<EXTERNAL_DRIVE>/Games/GOG misc.`
    - Your library may still show up as empty

---

## Hook Steam up to Kodi

- Download SuperRepo for your Kodi version from http://srp.nu/jarvis/all/superrepo.kodi.jarvis.all-0.7.04.zip
- Unzip the contents into KODI/portable_data/addons
- Kodi > System > Add-Ons > Install from Repository > Superrepo all > Program Add-Ons
- Scroll down to Steam, and Install
  - Configure the add-on. Go to `Advanced` and check these options:
    - Run Kodi in Portable mode
    - Suspend Kodi audio when running Steam
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
