# Elevate the script if not running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}
Write-Host "Username: runneradmin"
Write-Host "Password: P@ssw0rd!"
$TAIL_IP = cmd /c '"C:\Program Files\Tailscale\tailscale.exe" ip -4'
Write-Host "Access from here: $TAIL_IP (port 3389)"
