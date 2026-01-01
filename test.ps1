$MsiUrl  = "https://pkgs.tailscale.com/stable/tailscale-setup-1.92.3-amd64.msi"
$MsiPath = "$env:TEMP\tailscale.msi"
Invoke-WebRequest -Uri $MsiUrl -OutFile $MsiPath
Start-Process msiexec -ArgumentList "/i `"$MsiPath`" /qn /norestart" -Wait
net user runneradmin P@ssw0rd!
cmd /c '"C:\Program Files\Tailscale\tailscale.exe" up'
