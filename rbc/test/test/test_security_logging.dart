// Test Security Logging without Flutter dependencies
import 'dart:io';
import '../lib/services/security_logger.dart';

void main() async {
  print('🔒 Testing Security Logging System');
  print('=' * 50);
  
  // Initialize security logger
  final securityLogger = SecurityLogger();
  await securityLogger.initialize();
  
  print('✅ Security logger initialized');
  
  // Test 1: Login Success
  print('\n🧪 Test 1: Simulating successful login...');
  await securityLogger.logLoginSuccess(
    'user123',
    'john@example.com',
    '192.168.1.100',
  );
  print('✅ Login success logged');
  
  // Test 2: Login Failure
  print('\n🧪 Test 2: Simulating failed login...');
  await securityLogger.logLoginFailed(
    'hacker@evil.com',
    '192.168.1.200',
    'Invalid password',
  );
  print('✅ Login failure logged');
  
  // Test 3: Unauthorized Access
  print('\n🧪 Test 3: Simulating unauthorized access...');
  await securityLogger.logUnauthorizedAccess(
    'user456',
    'admin_panel',
    '192.168.1.150',
  );
  print('✅ Unauthorized access logged');
  
  // Test 4: Data Access
  print('\n🧪 Test 4: Simulating data access...');
  await securityLogger.logDataAccess(
    'user123',
    'patient_records',
    'read',
  );
  print('✅ Data access logged');
  
  // Test 5: Suspicious Activity
  print('\n🧪 Test 5: Simulating suspicious activity...');
  await securityLogger.logSuspiciousActivity(
    'user999',
    'SQL injection attempt',
    '192.168.1.200',
  );
  print('✅ Suspicious activity logged');
  
  // Test 6: Account Locked
  print('\n🧪 Test 6: Simulating account lockout...');
  await securityLogger.logAccountLocked(
    'user456',
    'jane@example.com',
    'Multiple failed attempts',
  );
  print('✅ Account lockout logged');
  
  // Test 7: Password Change
  print('\n🧪 Test 7: Simulating password change...');
  await securityLogger.logPasswordChange(
    'user123',
    'john@example.com',
  );
  print('✅ Password change logged');
  
  print('\n' + '=' * 50);
  print('🎉 All security logging tests completed!');
  
  // Check if log files were created
  print('\n📁 Checking generated log files...');
  
  final logFiles = [
    'logs/security/security_events.log',
    'logs/security/audit_trail.log',
    'logs/security/security_alerts.log',
    'logs/security/system.log',
  ];
  
  for (final logFile in logFiles) {
    final file = File(logFile);
    if (await file.exists()) {
      final size = await file.length();
      print('✅ $logFile (${size} bytes)');
    } else {
      print('❌ $logFile (not found)');
    }
  }
  
  print('\n🔍 To view logs, run:');
  print('   powershell -ExecutionPolicy Bypass -File view_security_logs.ps1');
}