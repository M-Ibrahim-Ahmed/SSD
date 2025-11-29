# Security Test Log Viewer
# View and analyze test execution logs

param(
    [string]$LogType = "all",  # all, pass, fail, error, info
    [int]$Lines = 50           # number of lines to show
)

$logFile = "logs/test_execution.log"

Write-Host "📋 Security Test Log Viewer" -ForegroundColor Green
Write-Host "=" * 50

if (-not (Test-Path $logFile)) {
    Write-Host "❌ Log file not found: $logFile" -ForegroundColor Red
    Write-Host "Run security tests first to generate logs." -ForegroundColor Yellow
    exit
}

Write-Host "📁 Log file: $logFile" -ForegroundColor Cyan
Write-Host "🔍 Filter: $LogType" -ForegroundColor White
Write-Host "📊 Lines: $Lines" -ForegroundColor White
Write-Host ""

# Read log file
$logContent = Get-Content $logFile -Tail $Lines

# Filter logs based on type
switch ($LogType.ToLower()) {
    "pass" { 
        $filteredLogs = $logContent | Where-Object { $_ -like "*[PASS]*" }
        Write-Host "✅ PASSED TESTS:" -ForegroundColor Green
    }
    "fail" { 
        $filteredLogs = $logContent | Where-Object { $_ -like "*[FAIL]*" }
        Write-Host "❌ FAILED TESTS:" -ForegroundColor Red
    }
    "error" { 
        $filteredLogs = $logContent | Where-Object { $_ -like "*[ERROR]*" }
        Write-Host "🚨 ERRORS:" -ForegroundColor Red
    }
    "info" { 
        $filteredLogs = $logContent | Where-Object { $_ -like "*[INFO]*" }
        Write-Host "ℹ️ INFORMATION:" -ForegroundColor Blue
    }
    default { 
        $filteredLogs = $logContent
        Write-Host "📜 ALL LOGS:" -ForegroundColor White
    }
}

Write-Host ""

if ($filteredLogs) {
    foreach ($log in $filteredLogs) {
        # Color code based on log level
        if ($log -like "*[PASS]*") {
            Write-Host $log -ForegroundColor Green
        } elseif ($log -like "*[FAIL]*" -or $log -like "*[ERROR]*") {
            Write-Host $log -ForegroundColor Red
        } elseif ($log -like "*[INFO]*") {
            Write-Host $log -ForegroundColor Cyan
        } else {
            Write-Host $log -ForegroundColor White
        }
    }
} else {
    Write-Host "No logs found matching filter: $LogType" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=" * 50

# Show log statistics
$totalLogs = $logContent.Count
$passLogs = ($logContent | Where-Object { $_ -like "*[PASS]*" }).Count
$failLogs = ($logContent | Where-Object { $_ -like "*[FAIL]*" }).Count
$errorLogs = ($logContent | Where-Object { $_ -like "*[ERROR]*" }).Count
$infoLogs = ($logContent | Where-Object { $_ -like "*[INFO]*" }).Count

Write-Host "📊 Log Statistics:" -ForegroundColor Magenta
Write-Host "   Total: $totalLogs" -ForegroundColor White
Write-Host "   ✅ Passed: $passLogs" -ForegroundColor Green
Write-Host "   ❌ Failed: $failLogs" -ForegroundColor Red
Write-Host "   🚨 Errors: $errorLogs" -ForegroundColor Red
Write-Host "   ℹ️ Info: $infoLogs" -ForegroundColor Cyan

Write-Host ""
Write-Host "Usage Examples:" -ForegroundColor Yellow
Write-Host "  .\view_logs.ps1                    # View all logs"
Write-Host "  .\view_logs.ps1 -LogType pass      # View only passed tests"
Write-Host "  .\view_logs.ps1 -LogType fail      # View only failed tests"
Write-Host "  .\view_logs.ps1 -Lines 100         # View last 100 lines"