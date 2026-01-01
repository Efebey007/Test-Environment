$MsiUrl  = "https://pkgs.tailscale.com/stable/tailscale-setup-1.92.3-amd64.msi"
$MsiPath = "$env:TEMP\tailscale.msi"
$USER = "C:\Windows\System32\whoami.exe"
Invoke-WebRequest -Uri $MsiUrl -OutFile $MsiPath
Start-Process msiexec -ArgumentList "/i `"$MsiPath`" /qn /norestart" -Wait
net user $USER P@ssw0rd!
cmd /c '"C:\Program Files\Tailscale\tailscale.exe" up --auth-key=tskey-auth-kBSfbTf2z511CNTRL-vTCwbrXKUjMBgXC9zVaRjMUWtXCuZiLN7'
