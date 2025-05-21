$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator
$isAdmin = (New-Object Security.Principal.WindowsPrincipal($currentUser)).IsInRole($adminRole)

# Create log directory in script location
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$logDir = Join-Path $scriptDir "logs"
if (-not (Test-Path $logDir)) {
    New-Item -ItemType Directory -Path $logDir | Out-Null
}
$logFile = Join-Path $logDir "restart_errors.log"

if (-not $isAdmin) {
    Start-Process powershell -ArgumentList "-File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Check if WSL is installed and if it's already functioning correctly
try {
    $vmService = Get-Service vmcompute -ErrorAction Stop
    
    # Check if WSL is already running properly
    Write-Host "Checking if WSL is functioning correctly..." -ForegroundColor Cyan
    $wslCheck = wsl --status 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "WSL appears to be functioning correctly. No restart needed." -ForegroundColor Green
        Write-Host "If you're experiencing issues, you can force a restart by using the -Force parameter."
        
        if ($args -contains "-Force") {
            Write-Host "Force restart requested. Proceeding with service restart..." -ForegroundColor Yellow
        } else {
            Write-Host "Restart aborted to prevent potential issues." -ForegroundColor Cyan
            exit
        }
    }
    
    Write-Host "WSL appears to need a restart. Proceeding..." -ForegroundColor Yellow
    Write-Host "Restarting WSL service..." -ForegroundColor Cyan
    $vmService | Restart-Service -Force
    Write-Host "The vmcompute service has been restarted successfully." -ForegroundColor Green
    Write-Host "Your WSL instances should now be working correctly." -ForegroundColor Green
} 
catch [Microsoft.PowerShell.Commands.ServiceCommandException] {
    Write-Host "WSL service (vmcompute) not found. Is WSL installed on this system?" -ForegroundColor Red
    "Error: WSL service not found - $_" | Out-File -Append $logFile
}
catch {
    Write-Host "Failed to restart the vmcompute service. Error: $_" -ForegroundColor Red
    "Error Details: $_" | Out-File -Append $logFile
}

# Better exit handling that keeps the window open
Write-Host "`nScript execution completed. Press Enter to exit..." -ForegroundColor Cyan

# This combination ensures the window stays open in both interactive and non-interactive sessions
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null