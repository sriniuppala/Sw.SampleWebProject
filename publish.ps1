param([String]$project, [String]$deployUrl, [String]$deployPath, [String]$configuration)

$env:Path += ";${Env:ProgramFiles(x86)}\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin"

msbuild .\publish.xml /p:Configuration=$configuration /p:DeployServiceUrl=$deployUrl /p:DeployIisAppPath="$deployPath" /p:ProjectName=$project