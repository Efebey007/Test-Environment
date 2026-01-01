$MsiUrl  = "https://pkgs.tailscale.com/stable/tailscale-setup-1.92.3-amd64.msi"
$MsiPath = "$env:TEMP\tailscale.msi"
Invoke-WebRequest -Uri $MsiUrl -OutFile $MsiPath
Start-Process msiexec -ArgumentList "/i `"$MsiPath`" /qn /norestart" -Wait
net user runneradmin P@ssw0rd!
cmd /c '"C:\Program Files\Tailscale\tailscale.exe" up --auth-key=tskey-auth-knZoe8Butt11CNTRL-3ZJHzG2uX4gaAFZ8e2xS4gCMZ7DKkZ7TK --unattended'
