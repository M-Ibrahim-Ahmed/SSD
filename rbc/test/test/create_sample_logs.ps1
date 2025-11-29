# Generate Sample Security Logs
Write-Host "Generating Sample Security Logs..." -ForegroundColor Green

# Create directory
$securityLogsDir = "logs/security"
if (-not (Test-Path $securityLogsDir)) {
    New-Item -ItemType Directory -Path $securityLogsDir -Force | Out-Null
}

# Create security events log
$securityEventsFile = "$securityLogsDir/security_events.log"
$events = @(
    "[2025-11-29T21:30:15] [LOW] [loginSuccess] User: user123 | IP: 192.168.1.100 | User successfully logged in",
    "[2025-11-29T21:31:22] [MEDIUM] [loginFailed] User: unknown | IP: 192.168.1.105 | Login attempt failed: Invalid password",
    "[2025-11-29T21:32:45] [LOW] [dataAccess] User: user123 | IP: 192.168.1.100 | Data access: read on patient_records",
    "[2025-11-29T21:33:12] [HIGH] [unauthorizedAccess] User: user456 | IP: 192.168.1.110 | Unauthorized access attempt to: admin_panel",
    "[2025-11-29T21:34:33] [LOW] [logout] User: user123 | IP: 192.168.1.100 | User logged out",
    "[2025-11-29T21:35:44] [MEDIUM] [passwordChange] User: user789 | IP: 192.168.1.115 | Password changed successfully",
    "[2025-11-29T21:36:55] [CRITICAL] [accountLocked] User: user456 | IP: 192.168.1.110 | Account locked: Multiple failed attempts",
    "[2025-11-29T21:37:11] [CRITICAL] [suspiciousActivity] User: user999 | IP: 192.168.1.200 | Suspicious activity detected: SQL injection attempt"
)

$events | Out-File -FilePath $securityEventsFile -Encoding UTF8

Write-Host "Security logs created at: $securityEventsFile" -ForegroundColor Green
Write-Host "Total events: $($events.Count)" -ForegroundColor Cyan