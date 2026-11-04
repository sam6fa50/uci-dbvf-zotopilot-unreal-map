# ZotoPilot's Simulation Unreal Engine Map

## Table of Contents
1. [About](#about)
2. [Usage](#usage)
3. [Configuring the Simulation](#configuring-the-simulation)
4. [Development](#development)
5. [Building & Pushing Releases to GitHub](#building--pushing-releases-to-github)

## About

This repository houses the Unreal Engine map used by UCI's DBVF team ZotoPilot used for simulation with AirSim derivatives. This repository does NOT house the scripts, those will exist in a separate repo to decouple the two. Scripts do not need to be run from any particular location.

The second goal of this repository is to provide prebuilt binaries that have AirSim built into them. This is done by packaging the Unreal Engine project into an executable (building the 'game'). This way, members of the team do not need to run Unreal Engine in order to run and use the simulation, and can instead just run the prebuilt binary, and simulate scripts scoped to the competition map.

This method of utilizing AirSim comes with the downside that environments cannot be edited directly (needs Unreal Engine). 

Everything else is configurable via `settings.json` and the scripting APIs (see the section on [Configuring the Simulation](#configuring-the-simulation)).

To work on the map, see [Development](#development), for usage off of the artifacts generated, see below, and for building and publishing artifacts based on your commit see [Building & Pushing Releases to Github](#building--pushing-releases-to-github).

## Usage

To download the latest version of the map, go to the release page and download the artifact for the latest tag. Extract the program in your location of choice, and launch it by executing `Launch.bat`. You will then get an elevation request for network permissions, select allow.

After this, you will be able to interface wtih scripts by executing them from wherever they're at on your system.

## Configuring the Simulation

There are a few options exposed from the `settings.json` that is included in the artifact's root that can be used to customize the simulation behavior. 

You can use this to, for example, change your mode to `ComputerVision` by changing the file to:

```json
{
  "SettingsVersion": 2.0,
  "SimMode": "ComputerVision"
}
```

You can then interface with this mode by following the scripting API for `ComputerVision` mode for AirSim.

## Development

Currently, Windows is the only development/target platform. 

This does not prevent simply opening the map on other operating systems in Unreal Editor, but it does potentially reduce automations present (fetching dependencies, building, and publishing to GitHub releases) as those are all PowerShell scripts and are not tested to work on other platforms. 

In order to develop the map, you need Unreal Engine 5.8.3 (soon will be updated to 5.8.4). Opening on another version is NOT supported and changes made after opening in a different version should NOT be committed to this repository yet until we decide how to navigate Unreal Engine version upgrades.

To open in the Unreal Editor, clone the repository, and run `powershell Tools/Install-AirSimPlugin.ps1` in a terminal. If this comes back with an error giving some issue about permissions, perform the following:

1. Open Settings and navigate to `Advanced > Terminal > Powershell`
2. Enable `Change execution policy to allow local PowerShell scripts to run without signing...`

After that, try executing the script again. If all works and the script finishes running, you will now be able to open this project! 

Open Unreal Engine, click on `My Projects > Browse`, then navigate to the Git repository and select the `.uproject` file from there.

Once it opens, you can begin working on the map. Commit your changes as usual, be careful about adding plugins as that is not tested yet.

> [!CAUTION]
> Files above 100 MiB will be rejected by Git (as we have not configured Git LFS for this repository yet), so be careful with large assets!

## Building & Pushing Releases to GitHub

If you would like to build from terminal, run `Tools/New-Release.ps1 <version-number>` after committing your changes. This will use Unreal Engine's build system to package the project into `Dist/<version-number>` with a zip next to it for distribution.

If you would like to produce publish a release to GitHub releases, first make sure you built as above for `version-number` so that the aforementioned zip exists.

Then you need to ensure you have GitHub CLI installed. The setup is as follows:

1. Install via: `winget install --id GitHub.cli`
2. Run `gh auth login` and follow the steps to authenticate yourself 

After this is done, run `Tools/Publish-Release.ps1 <version-number> "<build-description>"` to publish your release on the releases page under a newly created Git tag that matches `version-number` with description `"build-description"`.
