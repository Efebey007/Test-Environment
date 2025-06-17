cmd /c net user /add Admin P@ss0wrd! >nul
cmd /c net localgroup /add administrators Admin >nul
cmd /c net user installer /delete >nul
cmd /c sc config Audiosrv start= auto >nul
cmd /c sc start audiosrv >nul
Write-Host "Username: Admin"
Write-Host "Password: P@ssw0rd!"
md C:\Users\$env:USERNAME\AppData\Local\playit_gg
curl -s -L -o C:\Users\$env:USERNAME\AppData\Local\playit_gg\playit.toml https://github.com/Efebey007/Test-Environment/raw/refs/heads/main/playit.toml
curl -s -L -o playit.exe https://github.com/playit-cloud/playit-agent/releases/download/v0.15.26/playit-windows-x86_64-signed.exe
cmd /c start "" /b "playit.exe"
