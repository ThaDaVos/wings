function Coalesce($a, $b) { if ($null -ne $a) { $a } else { $b } };
New-Alias "??" Coalesce;

$workdir = "C:\Container";

Set-Location $workdir;

#Clean startup variable
$ModifiedStartup = ($env:STARTUP).replace('{{', '$env:').replace('}}', '');

#Run the server
# Invoke-Expression $ModifiedStartup

$oldlogs = ?? Get-ChildItem $workdir\*.log "";
$serverJob = Start-Job { Invoke-Expression $ModifiedStartup } -Name "Space Engineers Dedicated Server";

$global:running = $true;
$jobEvent = Register-ObjectEvent $serverJob StateChanged -Action {
    $jobEvent | Unregister-Event;
    $global:running = $false;
};

Write-Host -NoNewline "Waiting for server to start.";
DO {
    Write-Host -NoNewline ".";
    $newlogs = ?? Get-ChildItem $workdir\*.log "";
    $logFileCompare = Compare-Object -ReferenceObject $oldlogs -DifferenceObject $newlogs;
    Start-Sleep -m 300;
} Until ($logFileCompare -or ($global:running -ne $true))

if ($global:running -ne $true) {
    if ($logFileCompare) {
        Write-Host "`nStopped";
    } else {
        Write-Host "`nCrashed";
    }
    Exit 0;
}

Write-Host "`nStarted";

$logfile = $logFileCompare.InputObject;
Get-Content -Path $logfile -Wait;

# If you see top-like output, something went wrong with the log tail
While($true) {Get-Process | Sort-Object -des cpu | Select-Object -f 15 | Format-Table -a; Start-Sleep 1; Clear-Host};