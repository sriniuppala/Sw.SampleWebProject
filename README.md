# Sw.SampleWebProject

There are two scripts available that will build and publish this project from the command line.
They are windows batch files that execute powershell and MSBuild scripts.

## build.cmd

Run the build script with the pre-authenticated MyGet URL parameter. e.g.

    build.cmd https://www.myget.org/F/elite/auth/{secrect}/api/v3/index.json

This will tell the nuget client how to authenticate with our private feed, 
restore packages from the office nuget.org feed and our private feed,
and build the project with MSBuild.

## publish.cmd

Run the publish script with the following parameters:

1. Project Name: the name of the project. The script uses this to build the path to the web .csproj file. 
  E.g. if you use `Sw.SampleWebProject` as the ProjectName, it will know that the project file is `Sw.SampleWebProject\Sw.SampleWebProject.csproj`.
2. Web Server: the name of the server with IIS and MS Web Deploy that you are deploying to. This can be an IP address, server name, or domain name.
3. IIS path: the deploy path in IIS. It's usually `"Default Web Site/ProjectName"`
4. Build Configuration: for test environments, this is typically Debug, for live environments Release.

    publish.cmd Sw.SampleWebProject localhost "Default Web Site/SampleWebProject"  Debug
    
