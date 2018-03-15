# adds the elite myget source. when called from VSTS, source should be the pre-authenticated V3 URL from https://www.myget.org/feed/Details/elite

param([String]$source)

.\init.ps1
.\.tools\nuget.exe sources update -Name elite -source $source -configFile nuget.config