# Security Log Viewer
param(
    [string]$LogType = "all",
    [int]$Lines = 50
)

Write-Host "Security Log Viewer" -ForegroundColor Green
Write-Host "=" * 40

$logFile = "logs/security/security_events.log"

if (-not (Test-Path $logFile)) {
    Write-Host "No security logs found at: $logFile" -ForegroundColor Red
    Write-Host "Run create_sample_logs.ps1 first to generate sample logs" -ForegroundColor Yellow
    exit
}

Write-Host "Log file: $logFile" -ForegroundColor Cyan
Write-Host "Filter: $LogType" -ForegroundColor White
Write-Host ""

# Read logs
$logs = Get-Content $logFile -Tail $Lines

# Filter logs
switch ($LogType.ToLower()) {
    "login" { 
        $filteredLogs = $logs | Where-Object { $_ -like "*loginSuccess*" -or $_ -like "*loginFailed*" }
        Write-Host "LOGIN EVENTS:" -ForegroundColor Green
    }
    "failed" { 
        $filteredLogs = $logs | Where-Object { $_ -like "*loginFailed*" -or $_ -like "*CRITICAL*" }
        Write-Host "FAILED/CRITICAL EVENTS:" -ForegroundColor Red
    }
    "suspicious" { 
        $filteredLogs = $logs | Where-Object { $_ -like "*suspiciousActivity*" -or $_ -like "*CRITICAL*" }
        Write-Host "SUSPICIOUS ACTIVITIES:" -ForegroundColor Red
    }
    "access" { 
        $filteredLogs = $logs | Where-Object { $_ -like "*dataAccess*" -or $_ -like "*unauthorizedAccess*" }
        Write-Host "ACCESS EVENTS:" -ForegroundColor Blue
    }
    default { 
        $filteredLogs = $logs
        Write-Host "ALL SECURITY LOGS:" -ForegroundColor White
    }
}

Write-Host ""

if ($filteredLogs) {
    foreach ($log in $filteredLogs) {
        if ($log -like "*CRITICAL*") {
            Write-Host $log -ForegroundColor Red
        } elseif ($log -like "*HIGH*") {
            Write-Host $log -ForegroundColor Magenta
        } elseif ($log -like "*MEDIUM*") {
            Write-Host $log -ForegroundColor Yellow
        } elseif ($log -like "*loginSuccess*") {
            Write-Host $log -ForegroundColor Green
        } else {
            Write-Host $log -ForegroundColor White
        }
    }
} else {
    Write-Host "No logs found for filter: $LogType" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=" * 40

# Statistics
$totalLogs = $logs.Count
$loginSuccess = ($logs | Where-Object { $_ -like "*loginSuccess*" }).Count
$loginFailed = ($logs | Where-Object { $_ -like "*loginFailed*" }).Count
$critical = ($logs | Where-Object { $_ -like "*CRITICAL*" }).Count
$suspicious = ($logs | Where-Object { $_ -like "*suspiciousActivity*" }).Count

Write-Host "Log Statistics:" -ForegroundColor Cyan
Write-Host "  Total Events: $totalLogs" -ForegroundColor White
Write-Host "  Login Success: $loginSuccess" -ForegroundColor Green
Write-Host "  Login Failed: $loginFailed" -ForegroundColor Red
Write-Host "  Critical Events: $critical" -ForegroundColor Red
Write-Host "  Suspicious Activities: $suspicious" -ForegroundColor Magenta

Write-Host ""
Write-Host "Usage Examples:" -ForegroundColor Yellow
Write-Host "  .\view_security_logs.ps1                 # View all logs"
Write-Host "  .\view_security_logs.ps1 -LogType login  # View login events"
Write-Host "  .\view_security_logs.ps1 -LogType failed # View failed events"