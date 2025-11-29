# Generate Sample Security Logs for Demo
Write-Host "Generating Sample Security Logs..." -ForegroundColor Green

# Create logs directory structure
$securityLogsDir = "logs/security"
if (-not (Test-Path $securityLogsDir)) {
    New-Item -ItemType Directory -Path $securityLogsDir -Force | Out-Null
}

# Sample log files
$securityEventsFile = "$securityLogsDir/security_events.log"
$auditTrailFile = "$securityLogsDir/audit_trail.log"
$alertsFile = "$securityLogsDir/security_alerts.log"
$systemLogFile = "$securityLogsDir/system.log"

# Generate sample security events
$sampleEvents = @(
    "[2025-11-29T21:30:15] [LOW] [loginSuccess] User: user123 | IP: 192.168.1.100 | User successfully logged in | Signature: a1b2c3d4e5f6g7h8",
    "[2025-11-29T21:31:22] [MEDIUM] [loginFailed] User: unknown | IP: 192.168.1.105 | Login attempt failed: Invalid password | Signature: b2c3d4e5f6g7h8i9",
    "[2025-11-29T21:32:45] [LOW] [dataAccess] User: user123 | IP: 192.168.1.100 | Data access: read on patient_records | Signature: c3d4e5f6g7h8i9j0",
    "[2025-11-29T21:33:12] [HIGH] [unauthorizedAccess] User: user456 | IP: 192.168.1.110 | Unauthorized access attempt to: admin_panel | Signature: d4e5f6g7h8i9j0k1",
    "[2025-11-29T21:34:33] [LOW] [logout] User: user123 | IP: 192.168.1.100 | User logged out | Signature: e5f6g7h8i9j0k1l2",
    "[2025-11-29T21:35:44] [MEDIUM] [passwordChange] User: user789 | IP: 192.168.1.115 | Password changed successfully | Signature: f6g7h8i9j0k1l2m3",
    "[2025-11-29T21:36:55] [CRITICAL] [accountLocked] User: user456 | IP: 192.168.1.110 | Account locked: Multiple failed attempts | Signature: g7h8i9j0k1l2m3n4",
    "[2025-11-29T21:37:11] [CRITICAL] [suspiciousActivity] User: user999 | IP: 192.168.1.200 | Suspicious activity detected: SQL injection attempt | Signature: h8i9j0k1l2m3n4o5",
    "[2025-11-29T21:38:22] [MEDIUM] [mfaSuccess] User: user123 | IP: 192.168.1.100 | Multi-factor authentication successful | Signature: i9j0k1l2m3n4o5p6",
    "[2025-11-29T21:39:33] [HIGH] [mfaFailed] User: user456 | IP: 192.168.1.110 | Multi-factor authentication failed | Signature: j0k1l2m3n4o5p6q7",
    "[2025-11-29T21:40:44] [HIGH] [permissionDenied] User: user789 | IP: 192.168.1.115 | Permission denied for resource: sensitive_data | Signature: k1l2m3n4o5p6q7r8",
    "[2025-11-29T21:41:55] [LOW] [sessionExpired] User: user123 | IP: 192.168.1.100 | Session expired automatically | Signature: l2m3n4o5p6q7r8s9"
)

# Write security events
Write-Host "Creating security events log..." -ForegroundColor Yellow
$sampleEvents | Out-File -FilePath $securityEventsFile -Encoding UTF8

# Generate audit trail (JSON format)
Write-Host "Creating audit trail..." -ForegroundColor Yellow
$auditEntries = @(
    '{"id":"SEC_1732912215_1234","type":"loginSuccess","severity":"low","userId":"user123","userEmail":"john@example.com","description":"User successfully logged in","metadata":{"loginMethod":"password"},"ipAddress":"192.168.1.100","userAgent":"RBC-Flutter-App/1.0","timestamp":"2025-11-29T21:30:15.000Z","signature":"a1b2c3d4e5f6g7h8"}',
    '{"id":"SEC_1732912282_2345","type":"loginFailed","severity":"medium","userId":"unknown","userEmail":"hacker@evil.com","description":"Login attempt failed: Invalid password","metadata":{"failureReason":"Invalid password"},"ipAddress":"192.168.1.105","userAgent":"curl/7.68.0","timestamp":"2025-11-29T21:31:22.000Z","signature":"b2c3d4e5f6g7h8i9"}',
    '{"id":"SEC_1732912365_3456","type":"dataAccess","severity":"low","userId":"user123","userEmail":"john@example.com","description":"Data access: read on patient_records","metadata":{"dataType":"patient_records","action":"read"},"ipAddress":"192.168.1.100","userAgent":"RBC-Flutter-App/1.0","timestamp":"2025-11-29T21:32:45.000Z","signature":"c3d4e5f6g7h8i9j0"}',
    '{"id":"SEC_1732912392_4567","type":"unauthorizedAccess","severity":"high","userId":"user456","userEmail":"jane@example.com","description":"Unauthorized access attempt to: admin_panel","metadata":{"resource":"admin_panel","action":"access_denied"},"ipAddress":"192.168.1.110","userAgent":"Mozilla/5.0","timestamp":"2025-11-29T21:33:12.000Z","signature":"d4e5f6g7h8i9j0k1"}'
)

$auditEntries | Out-File -FilePath $auditTrailFile -Encoding UTF8

# Generate security alerts
Write-Host "Creating security alerts..." -ForegroundColor Yellow
$alerts = @(
    '{"alertId":"ALERT_1732912644_001","timestamp":"2025-11-29T21:37:24.000Z","severity":"critical","event":{"type":"accountLocked","userId":"user456","description":"Account locked: Multiple failed attempts"},"requiresAction":true}',
    '{"alertId":"ALERT_1732912671_002","timestamp":"2025-11-29T21:37:51.000Z","severity":"critical","event":{"type":"suspiciousActivity","userId":"user999","description":"SQL injection attempt detected"},"requiresAction":true}',
    '{"alertId":"ALERT_1732912733_003","timestamp":"2025-11-29T21:38:53.000Z","severity":"high","event":{"type":"mfaFailed","userId":"user456","description":"Multiple MFA failures"},"requiresAction":true}'
)

$alerts | Out-File -FilePath $alertsFile -Encoding UTF8

# Generate system log
Write-Host "Creating system log..." -ForegroundColor Yellow
$systemEvents = @(
    "[2025-11-29T21:30:00] [SYSTEM] Security logging system initialized",
    "[2025-11-29T21:30:01] [SYSTEM] Log rotation completed successfully",
    "[2025-11-29T21:35:00] [SYSTEM] Security alert threshold reached - 3 critical events",
    "[2025-11-29T21:40:00] [SYSTEM] Automated security scan completed",
    "[2025-11-29T21:45:00] [SYSTEM] Log integrity verification passed"
)

$systemEvents | Out-File -FilePath $systemLogFile -Encoding UTF8

Write-Host ""
Write-Host "✅ Sample security logs generated successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Generated Files:" -ForegroundColor Cyan
Write-Host "   - $securityEventsFile" -ForegroundColor White
Write-Host "   - $auditTrailFile" -ForegroundColor White  
Write-Host "   - $alertsFile" -ForegroundColor White
Write-Host "   - $systemLogFile" -ForegroundColor White
Write-Host ""
Write-Host "📊 Log Summary:" -ForegroundColor Cyan
Write-Host "   - Security Events: $($sampleEvents.Count)" -ForegroundColor White
Write-Host "   - Audit Entries: $($auditEntries.Count)" -ForegroundColor White
Write-Host "   - Security Alerts: $($alerts.Count)" -ForegroundColor White
Write-Host "   - System Events: $($systemEvents.Count)" -ForegroundColor White
Write-Host ""
Write-Host "🔍 View logs using:" -ForegroundColor Yellow
Write-Host "   powershell -ExecutionPolicy Bypass -File view_logs.ps1" -ForegroundColor White