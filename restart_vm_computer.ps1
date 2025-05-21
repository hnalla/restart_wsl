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

# Check if WSL is installed
try {
    $vmService = Get-Service vmcompute -ErrorAction Stop
    
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

Read-Host "Press Enter to exit"