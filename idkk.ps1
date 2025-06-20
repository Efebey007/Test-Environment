# Elevate the script if not running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Create a new user and add to administrators group
cmd /c "net user Admin P@ss0wrd! /add >nul"
cmd /c "net localgroup administrators Admin /add >nul"

# Display the credentials
Write-Host "Username: Admin"
Write-Host "Password: P@ss0wrd!"
