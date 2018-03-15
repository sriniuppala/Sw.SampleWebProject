param([String]$myGetUrl)

$env:Path += ";${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin"

.\init-myget.ps1 -source $myGetUrl

nuget restore .\Sw.SampleWebProject.sln

msbuild .\Sw.SampleWebProject.sln /p:Configuration=Release