# escape=`
FROM mcr.microsoft.com/windows/servercore:20H2

RUN powershell; `
    Invoke-WebRequest -OutFile $env:TEMP\NDP461-KB3102436-x86-x64-AllOS-ENU.exe https://go.microsoft.com/fwlink/?LinkId=2099467; `
    Start-Process $env:TEMP\NDP461-KB3102436-x86-x64-AllOS-ENU.exe '/q /norestart' -wait; `
    Remove-Item –path $env:TEMP\NDP461-KB3102436-x86-x64-AllOS-ENU.exe;

RUN powershell; `
    Invoke-WebRequest -OutFile $env:TEMP\vcredist_x64_2013.exe http://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe; `
    Start-Process $env:TEMP\vcredist_x64_2013.exe '/quiet /install' -wait; `
    Remove-Item –path $env:TEMP\vcredist_x64_2013.exe;

RUN powershell; `
    Invoke-WebRequest -OutFile $env:TEMP\vcredist_x64_2017.exe https://download.visualstudio.microsoft.com/download/pr/9fbed7c7-7012-4cc0-a0a3-a541f51981b5/e7eec15278b4473e26d7e32cef53a34c/vc_redist.x64.exe; `
    Start-Process $env:TEMP\vcredist_x64_2017.exe '/quiet /install' -wait; `
    Remove-Item –path $env:TEMP\vcredist_x64_2017.exe;

RUN powershell; `
    Invoke-WebRequest -OutFile $env:TEMP\steamcmd.zip https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip; `
    Expand-Archive -Path $env:TEMP\steamcmd.zip -DestinationPath c:\steamcmd\; `
    Remove-Item –path $env:TEMP\steamcmd.zip;

RUN net user pterodactyl /add
USER pterodactyl

WORKDIR C:\Container

ADD ./entrypoint.ps1 C:\entrypoint.ps1
CMD ["powershell", "C:\\entrypoint.ps1"]