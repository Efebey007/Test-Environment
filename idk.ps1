cmd /c net user /add Admin P@ss0wrd! >nul
cmd /c net localgroup /add administrators Admin >nul
Write-Host "Username: Admin"
Write-Host "Password: P@ssw0rd!"
