# Tags the current commit and publishes Dist/<zip> as a GitHub Release.
# Usage: .\Tools\Publish-Release.ps1 0.1.0 "Release notes here"
param(
    [Parameter(Mandatory)][string]$Version,
    [string]$Notes = "Unzip and run Launch.bat."
)

$ErrorActionPreference = 'Stop'

# Accept "x.x.x" or "vx.x.x"; always use "vx.x.x"
$Version = 'v' + $Version.TrimStart('v', 'V')

$ProjectName = "UCI_DBVF_2627_AirSim"
$ZipPath     = "$PSScriptRoot\..\Dist\$ProjectName-$Version-Win64.zip"

# The tag must point at exactly the source that was built
if (git status --porcelain) {
	throw "Uncommitted changes. Commit and rebuild before publishing." 
}

if (-not (Test-Path $ZipPath)) {
	throw "No build found at $ZipPath. Run New-Release.ps1 $Version first." 
}

# Push after uncomitted changes
git push

if ($LASTEXITCODE -ne 0) {
	throw "git push failed." 
}

# Tag after pushing
git tag -a $Version -m "$Version"
if ($LASTEXITCODE -ne 0) {
	throw "git tag failed (does $Version already exist?)." 
}

# Push to origin the tag that was just created
git push origin $Version
if ($LASTEXITCODE -ne 0) {
	throw "Pushing tag $Version failed." 
}

# Use gh cli to create a release with the zip produced, titling it as the 
# version and appending the notes that were supplied optionally
gh release create $Version $ZipPath --title $Version --notes $Notes

if ($LASTEXITCODE -ne 0) {
	throw "gh release create failed. The tag is pushed; rerun just this step." 
}
