function Coalesce($a, $b) { if ($null -ne $a) { $a } else { $b } };
New-Alias "??" Coalesce;

$startTime = Get-Date;

Write-Host "Starting Space Engineers server at $startTime";

$workdir = "C:\Container";

Set-Location $workdir;

#Clean startup variable
$ModifiedStartup = ($env:STARTUP).replace('{{', '$env:').replace('}}', '');

#Run the server
# Invoke-Expression $ModifiedStartup

$script = [scriptblock]::create($ModifiedStartup);
$serverJob = Start-Job -Name "Space Engineers Dedicated Server" -ScriptBlock $script;

$running = $true;
$jobEvent = Register-ObjectEvent $serverJob StateChanged -Action {
    $jobEvent | Unregister-Event;
    $script:running = $false;
};

Write-Host -NoNewline "Waiting for server to start.";
$found = $false;
DO {
    Write-Host -NoNewline ".";
    $script:found = Test-Path "$workdir\SpaceEngineersDedicated*.log" -NewerThan $script:startTime;
    Start-Sleep -Milliseconds 250;
} Until (($found -eq $true) -or ($running -ne $true))

if ($running -ne $true) {
    Receive-Job -Job $serverJob;

    if ($logFileCompare) {
        Write-Host "`nStopped";
        Start-Sleep -Seconds 5;
        Exit 0;
    } else {
        Write-Host "`nCrashed";
        Start-Sleep -Seconds 5;
        Exit -1;
    }
} else {
    Write-Host "`nStarted";
}

$logfile = Get-ChildItem "$workdir\SpaceEngineersDedicated*.log" | Sort-Object -Property LastWriteTime | Select-Object -Last 1;

Write-Host "Tailing generated log file: $logfile";
Get-Content -Path $logfile -Wait;

# If you see top-like output, something went wrong with the log tail
While($true) {Get-Process | Sort-Object -des cpu | Select-Object -f 15 | Format-Table -a; Start-Sleep 1; Clear-Host};