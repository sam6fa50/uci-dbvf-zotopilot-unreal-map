# Packages the project into Dist/<Version>/ and zips it.
# Usage: powershell New-Release.ps1 v0.1.0
param([Parameter(Mandatory)][string]$Version)

$ErrorActionPreference = 'Stop'

# Accept "x.x.x" or "vx.x.x"; always use "vx.x.x"
$Version = 'v' + $Version.TrimStart('v', 'V')

if (Get-Process UnrealEditor -ErrorAction SilentlyContinue) {
	throw "Close the Unreal editor first."
}

$EngineRoot  = "C:\Program Files\Epic Games\UE_5.8"
$ProjectName = "UCI_DBVF_2627_AirSim"
$ProjectRoot = "$PSScriptRoot\.."
$ArchiveDir  = "$ProjectRoot\Dist\$Version"

# Rebuilding a version replaces its old output entirely
$ZipPath = "$ProjectRoot\Dist\$ProjectName-$Version-Win64.zip"
foreach ($Old in $ArchiveDir, $ZipPath) {
    if (Test-Path $Old) { Remove-Item $Old -Recurse -Force }
}

# Build, cook and package into Dist/<Version>/Windows/
& "$EngineRoot\Engine\Build\BatchFiles\RunUAT.bat" BuildCookRun `
    "-project=$ProjectRoot\$ProjectName.uproject" -platform=Win64 -clientconfig=Development `
    -build -cook -stage -pak -archive "-archivedirectory=$ArchiveDir"

if ($LASTEXITCODE -ne 0) {
	throw "Packaging failed (exit code $LASTEXITCODE)" 
}

# Add runtime config, then zip
Copy-Item "$ProjectRoot\Sim\settings.json", "$ProjectRoot\Sim\Launch.bat" "$ArchiveDir\Windows"
Compress-Archive "$ArchiveDir\Windows\*" $ZipPath
