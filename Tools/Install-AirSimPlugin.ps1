# Downloads the pinned AirSim plugin into Plugins/.
# First, a check to make sure Unreal Engine is closed, as we will refuse to run
# while the editor holds plugin files open.
if (Get-Process UnrealEditor -ErrorAction SilentlyContinue) {
    throw "Close the Unreal editor first: it locks plugin files."
}

# Upgrade by changing these tags to reflect what's present on:
# https://github.com/Cosys-Lab/Cosys-AirSim/releases/
# And then rerunning this script
# Exact Tag, e.g. 5.8-v3.5.0
$Tag   = "5.8-v3.5.0"

# Exact filename from that release's Assets
$Asset = "AirSim_plugin_Windows_58_350.zip"

# Composed URL
$Url   = "https://github.com/Cosys-Lab/Cosys-AirSim/releases/download/$Tag/$Asset"

# Stop on error rather than continue arbitrarily, which can cause an override if
# download fails
$ErrorActionPreference = 'Stop'

# The progress bar makes large downloads very slow
$ProgressPreference = 'SilentlyContinue'       

# Location to push download artifact to
$ZipPath = "$env:TEMP\$Asset"

# Define the project root $Root
$Root = "$PSScriptRoot\.."

# Output the download and populate file at $ZipPath
curl.exe --fail --location --progress-bar --output $ZipPath $Url
if ($LASTEXITCODE -ne 0) { 
	throw "Download failed (curl exit code $LASTEXITCODE)"
}

# Next, delete the existing AirSim Plugin install
$PluginDir = "$Root\Plugins\AirSim"
if (Test-Path $PluginDir) { 
	Remove-Item $PluginDir -Recurse -Force -ErrorAction SilentlyContinue
}

# Finally, extract the file $ZipPath, and place it in $Root/Plugins
Expand-Archive $ZipPath "$Root\Plugins" -Force
