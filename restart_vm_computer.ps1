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

try {
        
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
            
            # Better exit handling that keeps the window open
            Write-Host "`nPress Enter to exit..." -ForegroundColor Cyan
            # This combination ensures the window stays open in both interactive and non-interactive sessions
            $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
            exit
        }
        else {
            Write-Host "WSL appears to need a restart. Proceeding..." -ForegroundColor Yellow
        }
    }
    
    
    Write-Host "Restarting WSL service..." -ForegroundColor Cyan
    
    
    Get-Service vmcompute | Restart-Service -Force
    Write-Host "The vmcompute service has been restarted successfully." -ForegroundColor Green
} catch {
    Write-Host "Failed to restart the vmcompute service. Error: $_" -ForegroundColor Red
    "Error Details: $_" | Out-File -Append $logFile
}



# Sleep for a moment to ensure messages are displayed
Start-Sleep -Seconds 1

# Better exit handling that keeps the window open
Write-Host "`nScript execution completed. Press Enter to exit..." -ForegroundColor Cyan
$host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null