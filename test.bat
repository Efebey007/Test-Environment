@echo off
setlocal enabledelayedexpansion

:: 1. Auto-launch as Administrator
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: 2. Check for the REEMO_KEY environment variable
if "%REEMO_KEY%"=="" (
    echo [ERROR] REEMO_KEY environment variable is not set.
    echo Please set it before running this script, or run: set REEMO_KEY=your_private_key
    pause
    exit /b 1
)

:: 3. Set up paths and variables [cite: 1]
set "NATIVE_SYSTEM32=%SystemRoot%\System32"
set "POWERSHELL_EXE=%NATIVE_SYSTEM32%\WindowsPowerShell\v1.0\powershell.exe"
set "CURL_EXE=%NATIVE_SYSTEM32%\curl.exe"
set "REEMO_URL=https://download.reemo.io/reemo.setup.x64.exe"
set "REEMO_INSTALLER=%TEMP%\reemo.setup.x64.exe"
set "REEMO_PROGRAMFILES=%ProgramFiles%"
set "REEMO_CONFIG=%REEMO_PROGRAMFILES%\Reemo\service\reemo.ini"

echo === Downloading Reemo Agent ===
del /Q "%REEMO_INSTALLER%" >nul 2>&1
set "REEMO_DOWNLOADED="

:: Try downloading with cURL [cite: 1, 2]
if exist "%CURL_EXE%" (
    "%CURL_EXE%" -fL --silent --show-error --retry 3 --retry-delay 2 -o "%REEMO_INSTALLER%" "%REEMO_URL%"
    if not errorlevel 1 set "REEMO_DOWNLOADED=1"
)

:: Fallback to PowerShell if cURL is unavailable/fails [cite: 2]
if not defined REEMO_DOWNLOADED (
    "%POWERSHELL_EXE%" -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; [Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -UseBasicParsing -Uri $env:REEMO_URL -OutFile $env:REEMO_INSTALLER" >nul 2>&1
    if errorlevel 1 (
        echo [ERROR] The Reemo installer download failed. [cite: 2]
        del /Q "%REEMO_INSTALLER%" >nul 2>&1
        pause
        exit /b 1
    )
)

:: Validate file existence and size [cite: 2, 3]
if not exist "%REEMO_INSTALLER%" (
    echo [ERROR] The Reemo installer was not created after download. [cite: 2]
    pause
    exit /b 1
)
for %%F in ("%REEMO_INSTALLER%") do if %%~zF LEQ 0 (
    echo [ERROR] The downloaded Reemo installer is empty. [cite: 3]
    del /Q "%REEMO_INSTALLER%" >nul 2>&1
    pause
    exit /b 1
)

echo === Validating Authenticode Signature ===
:: Validate the embedded Reemo publisher signature [cite: 3, 4]
"%POWERSHELL_EXE%" -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$signature=Get-AuthenticodeSignature -LiteralPath $env:REEMO_INSTALLER; if ($null -eq $signature.SignerCertificate) { exit 1 }; $signer=$signature.SignerCertificate.GetNameInfo([Security.Cryptography.X509Certificates.X509NameType]::SimpleName,$false); if ($signer -ne 'HUBITECH SARL' -or $signature.Status.ToString() -in @('NotSigned','HashMismatch')) { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] The Reemo installer failed Authenticode signer validation. [cite: 4]
    del /Q "%REEMO_INSTALLER%" >nul 2>&1
    pause
    exit /b 1
)

echo === Installing Reemo ===
:: Run the silent installation using the provided key [cite: 8]
"%REEMO_INSTALLER%" /S /SECRETKEY="%REEMO_KEY%"
set "REEMO_EXIT=%errorlevel%"

if not "%REEMO_EXIT%"=="0" (
    echo [ERROR] The silent installer returned a failure code: %REEMO_EXIT% [cite: 9]
    del /Q "%REEMO_INSTALLER%" >nul 2>&1
    pause
    exit /b 1
)
del /Q "%REEMO_INSTALLER%" >nul 2>&1

echo === Verifying Installation ===
:: Validate the configuration file and token generation [cite: 10, 11]
"%POWERSHELL_EXE%" -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$path=$env:REEMO_CONFIG; $deadline=[DateTime]::UtcNow.AddSeconds(20); while ([DateTime]::UtcNow -lt $deadline) { if (Test-Path -LiteralPath $path -PathType Leaf) { foreach ($line in [IO.File]::ReadLines($path)) { if ($line -match '^\s*token\s*=\s*\S+') { exit 0 } } }; Start-Sleep -Seconds 1 }; exit 1" >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Reemo finished installing, but its documented configuration file or authentication token could not be validated. [cite: 12]
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Reemo Agent installed and authenticated successfully!
timeout /t 5 >nul
exit /b 0
