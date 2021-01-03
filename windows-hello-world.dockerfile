FROM mcr.microsoft.com/windows/servercore:1809

LABEL Description="IIS" Vendor="Microsoft" Version="10"

RUN powershell -Command Add-WindowsFeature Web-Server

RUN net user pterodactyl /add

USER pterodactyl

CMD whoami & ping localhost -t