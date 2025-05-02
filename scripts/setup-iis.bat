@echo off
SET SiteName=MyWebApp
SET AppPoolName=MyAppPool
SET PhysicalPath=C:\inetpub\wwwroot\MyWebApp
SET Port=8080

REM Create physical path
IF NOT EXIST "%PhysicalPath%" (
    mkdir "%PhysicalPath%"
)

REM Create App Pool
%windir%\system32\inetsrv\appcmd add apppool /name:%AppPoolName%

REM Create IIS Site
%windir%\system32\inetsrv\appcmd add site /name:%SiteName% /bindings:http/*:%Port: =%: /physicalPath:"%PhysicalPath%" /applicationPool:%AppPoolName%

REM Start site
%windir%\system32\inetsrv\appcmd start site /name:%SiteName%
