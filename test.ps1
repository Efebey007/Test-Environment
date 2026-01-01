$MsiUrl  = "https://pkgs.tailscale.com/stable/tailscale-setup-1.92.3-amd64.msi"
$MsiPath = "$env:TEMP\tailscale.msi"
Invoke-WebRequest -Uri $MsiUrl -OutFile $MsiPath
Start-Process msiexec -ArgumentList "/i `"$MsiPath`" /qn /norestart" -Wait
net user runneradmin P@ssw0rd!
cmd /c '"C:\Program Files\Tailscale\tailscale.exe" up --auth-key=tskey-auth-kSHqqm3TEv11CNTRL-tkVbZncBSK9ZPbZa9cEMK9KQqRmJ7kXQ'
