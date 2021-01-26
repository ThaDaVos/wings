cd C:\Container

#Clean startup variable
$ModifiedStartup = ($env:STARTUP).replace('{{', '$env:').replace('}}', '')
Write-Host "PS C:\Container\> $ModifiedStartup"

#Run the server
Invoke-Expression $ModifiedStartup