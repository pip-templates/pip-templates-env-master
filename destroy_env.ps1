#!/usr/bin/env pwsh

param
(
    [Alias("c", "Path")]
    [Parameter(Mandatory=$false, Position=0)]
    [string] $ConfigPath
)

$ErrorActionPreference = "Stop"

# Load support functions
$rootPath = $PSScriptRoot
if ($rootPath -eq "") { $rootPath = "." }
. "$($rootPath)/lib/include.ps1"
$rootPath = $PSScriptRoot
if ($rootPath -eq "") { $rootPath = "." }

# Destroy k8s cluster
. "$($rootPath)/cloud/destroy_k8s.ps1" $ConfigPath
# Check for error
if ($LastExitCode -ne 0) {
    Write-Error "Can't destroy k8s. Watch logs above."
}

# Unpeer mongo 
. "$($rootPath)/cloud/unpeer_mongo.ps1" $ConfigPath
# Check for error
if ($LastExitCode -ne 0) {
    Write-Error "Can't unpeer mongo cluster. Watch logs above."
}

# Destroy mongo cluster
. "$($rootPath)/cloud/destroy_mongo.ps1" $ConfigPath
# Check for error
if ($LastExitCode -ne 0) {
    Write-Error "Can't destroy mongo cluster. Watch logs above."
}