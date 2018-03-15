##-----------------------------------------------------------------------
## <copyright file="ApplyVersionToAssemblies.ps1">(c) http://TfsBuildExtensions.codeplex.com/. This source is subject to the Microsoft Permissive License. See http://www.microsoft.com/resources/sharedsource/licensingbasics/sharedsourcelicenses.mspx. All other rights reserved.</copyright>
##-----------------------------------------------------------------------
# Look for a 0.0.0.0 pattern in the build number. 
# If found use it to version the assemblies.
#
# For example, if the 'Build number format' build process parameter 
# $(BuildDefinitionName)_$(Year:yyyy).$(Month).$(DayOfMonth)$(Rev:.r)
# then your build numbers come out like this:
# "Build HelloWorld_2013.07.19.1"
# This script would then apply version 2013.07.19.1 to your assemblies.

# Modified by John Rummell to work with TFS Build 2015 preview

# Enable -Verbose option
[CmdletBinding()]
	
# Parameters
param($buildNumber, $workingDirectory, [switch]$Disable)

# Convenience option so you can debug this script or disable it in 
# your build definition without having to remove it from
# the 'Post-build script path' build process parameter.
if ($PSBoundParameters.ContainsKey('Disable'))
{
	Write-Verbose "Script disabled; no actions will be taken on the files."
}

# Resolve build number
if (-not $buildNumber)
{
	$buildNumber = $Env:TF_BUILD_BUILDNUMBER
}

if (-not $buildNumber)
{
	$buildNumber = $Env:BUILD_BUILDNUMBER
}

# Resolve working directory
if (-not $workingDirectory)
{
	$workingDirectory = $Env:TF_BUILD_SOURCESDIRECTORY
}

if (-not $workingDirectory)
{
	$workingDirectory = $Env:BUILD_SOURCESDIRECTORY
}

# Regular expression pattern to find the version in the build number 
# and then apply it to the assemblies
$VersionRegex = "\d+\.\d+\.\d+\.\d+"
	
# Make sure path to source code directory is available
if (-not $workingDirectory)
{
	Write-Error ("workingDirectory environment variable is missing.")
	exit 1
}
elseif (-not (Test-Path $workingDirectory))
{
	Write-Error "workingDirectory does not exist: $workingDirectory"
	exit 1
}
Write-Verbose "workingDirectory: $workingDirectory"
	
# Make sure there is a build number
if (-not $buildNumber)
{
	Write-Error ("buildNumber environment variable is missing.")
	exit 1
}
Write-Verbose "buildNumber: $buildNumber"
	
# Get and validate the version data
$VersionData = [regex]::matches($buildNumber, $VersionRegex)
switch($VersionData.Count)
{
   0		
      { 
         Write-Error "Could not find version number data in buildNumber ($buildNumber)."
         exit 1
      }
   1 {}
   default 
      { 
         Write-Warning "Found more than instance of version data in buildNumber." 
         Write-Warning "Will assume first instance is version."
      }
}
$NewVersion = $VersionData[0]
Write-Verbose "Version: $NewVersion"
	
# Apply the version to the assembly property files
$files = gci $workingDirectory -recurse -include "*Properties*","My Project" | 
	?{ $_.PSIsContainer } | 
	foreach { gci -Path $_.FullName -Recurse -include AssemblyInfo.* }
if($files)
{
	Write-Verbose "Will apply $NewVersion to $($files.count) files."
	
	foreach ($file in $files) {
			
			
		if(-not $Disable)
		{
			$filecontent = Get-Content($file)
			attrib $file -r
			$filecontent -replace $VersionRegex, $NewVersion | Out-File $file
			Write-Verbose "$file.FullName - version applied"
		}
	}
}
else
{
	Write-Warning "Found no files."
}
