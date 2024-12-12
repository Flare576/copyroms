# CopyRoms

## TL;DR

1. Download the zip that matches your OS to the folder you want your backups
2. Extract the zip
3. EDIT THE GAME LISTS IN THE `FILTERS` FOLDER
4. Run the script for the system you're backing up

## Details

## The Goal

CopyRoms is a set of scripts and lists designed to make backing up your video game collection easy.

### The FILTERS Lists

In order to give you a starting point, I used a two-step process to create an initial list of games for each system

1. Use the [1G1R] tools to generate a list of preferred ROMS for English speaking USA Residents
2. Use various websites to determine the "Top" titles for a system
3. Limit list to 200GB (or, for early systems, until I stopped recognizing games :P )

In this way, I generated lists that likely contain most of the games in your library - You can add/remove games from your lists as you need!

### The Scripts

The scripts use a 4-step process to download the ROMS you specify:

1. If `rclone` isn't found, [Download Rclone] (latest version) and extract it.
2. If the ROMS need to be unzipped to be used (Most disk-based systems), check the FILTER list against the folders
3. Run `rclone` against myrient using the filter you edited
4. If necessary, unzip the archive and delete the zip file to preserve space

#### Windows

The Windows scripts download all ROMS to the `ROMS` folder in the same folder as the scripts.

#### SteamOS

The SteamOS scripts are designed to be run in the `Emulation` folder that EmuDeck creates during setup - Move the `steamos.zip` file there before Extracting it!

Also, you should be able to Right-click (left-trigger) on the script and choose `Run in Konsole` - You don't even need a keyboard!

#### Linux

The SteamOS scripts download the Linux version of rclone and are written in Bash - you should be able to run them as well!

#### OSx

I don't actually have a machine running OSx to test the scripts, but as long as you put [Download Rclone] and put the executable in the same folder as the scripts, you should be OK!


[1G1R]: https://www.reddit.com/r/RetroPie/comments/mtzcy6/create_your_own_1g1r_set_for_redump_and_nointro/
[Download Rclone]: https://rclone.org/downloads/
