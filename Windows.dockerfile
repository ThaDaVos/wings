FROM mcr.microsoft.com/windows/servercore:1809

RUN net user pterodactyl /add

USER pterodactyl

ADD ./entrypoint.ps1 C:/entrypoint.ps1

WORKDIR C:/Pterodactyl-Server

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENTRYPOINT ["powershell"]
CMD C:/entrypoint.ps1