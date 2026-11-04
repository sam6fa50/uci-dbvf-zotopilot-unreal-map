# ZotoPilot's Simulation Unreal Engine Map

## About

This repository houses the Unreal Engine map used by UCI's DBVF team ZotoPilot used for simulation with AirSim derivatives. This repository does NOT house the scripts, that will go separately to decouple the two.

The second goal of this repository is to provide prebuilt binaries that have AirSim built into them. This is done by packaging the Unreal Engine project into an executable (building the 'game'). This way, members of the team do not need to load the entire Unreal Engine project in order to run the simulation and instead can download the releases from the GitHub releases in this repository to test their simulation scripts.

This method of utilizing AirSim comes with the downside that environments cannot be edited directly, as that would require Unreal. Everything else is configurable via .json based settings and the scripting APIs, including `ComputerVision` mode which allows for arbitrary script based camera positioning (see the section on [Customizing the Simulation](#customizing-the-simulation)).

To work on the map, see [Development](#development), and for usage off of the artifacts generated, see below.

## Usage

To download the latest version of the map, go to the release page and download the artifact for the latest tag. Extract the program in your location of choice, and launch it by executing `Launch.bat`. You will then get an elevation request for network permissions, select allow.

After this, you will be able to interface wtih localhost scripts by executing them in the exact same way you would when you launched the map from Unreal Engine.

Currently, Windows is the only target platform but this will be changed if needed. This does not prevent opening the map in Unreal Editor, but it does potentially remove/reduce automations present (fetching dependencies, building, and publishing to GitHub releases). This is because for now there are only PowerShell scripts for all automation, though the dependency fetching andit may work on the Linux build for PowerShell as well.

## Customizing the Simulation

There are a few options exposed from the `settings.json` file that is included in the artifact's root. You can use this to change your mode to, for example, `ComputerVision` mode by changing the file to:

```json
{
  "SettingsVersion": 2.0,
  "SimMode": "ComputerVision"
}
```

You can then interface with this mode by following the scripting API for `ComputerVision` mode for AirSim

## Development

In order to develop the map, you need Unreal Engine 5.8.3 (soon will be updated to 5.8.4). Opening on another version is not supported and changes made after opening in a different version should NOT be committed to this repository yet as there is no formal structure for branches.

To open in the Unreal Editor, clone the repository, and run `powershell Tools/Install-AirSimPlugin.ps1` in a terminal. If this comes back with an error resembling permission issues, go to:
`Settings > Advanced > Terminal > Powershell`
And set 
`Change execution policy to allow local PowerShell scripts to run without signing...` to `On`.

After that, try executing the script again. If all works and the script finishes running, you will now be able to open this project! 

To do this, first try right clicking `UCI_DBVF_2627_AirSim.uproject` and selecting `Open with Unreal Engine` if available. 

If not, open Unreal Engine manually, click on `My Projects > Browse`, then navigate to the Git repository and select the `.uproject` file from there.

Once it opens, you can begin working on the map. Commit your changes as usual, the `.gitignore` will ignore all unecessary files. 

> [!CAUTION]
> Files above 100 MiB will be rejected by Git (as we have not configured Git LFS for this repository yet), so be careful with large assets!

## Building & Pushing Releases to GitHub

If you would like to build from terminal, you can run `Tools/New-Release.ps1 <version-number>` after finalizing your Git commits. This will build your project into an executable in `Dist/<version-number>` with a packaged zip next to it that can be distributed or published to GitHub releases.

If you would like to produce publish a release to GitHub releases, you need to ensure you have GitHub CLI installed. You can install it by entering this command in a terminal window: `winget install --id GitHub.cli`

Then run `gh auth login` and follow the steps to authenticate yourself. After this is done, you can execute `Tools/Publish-Release.ps1 <version-number> "build message"` to publish your release on the releases page under a newly created Git tag that matches `version-number`.
