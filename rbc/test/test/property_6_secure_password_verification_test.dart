import 'package:flutter_test/flutter_test.dart';
import 'dart:math';
import '../lib/services/secure_password_verification_service.dart';

void main() {
  group('Property 6: Secure Password Verification Tests', () {
    late SecurePasswordVerificationServiceImpl passwordService;
    final random = Random();

    setUp(() {
      passwordService = SecurePasswordVerificationServiceImpl();
    });

    // Helper function to generate random email
    String generateRandomEmail() {
      final domains = ['example.com', 'test.org', 'demo.net'];
      final username = List.generate(8, (index) => 
          String.fromCharCode(97 + random.nextInt(26))).join();
      return '$username@${domains[random.nextInt(domains.length)]}';
    }

    // Helper function to generate random password
    String generateRandomPassword() {
      const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
      return List.generate(12, (index) => 
          chars[random.nextInt(chars.length)]).join();
    }

    test('**Feature: security-enhancement, Property 6: Secure Password Verification**', () async {
      // Property: For any authentication attempt, credential validation should use 
      // cryptographically secure hashing algorithms and never perform plaintext comparison
      // Validates: Requirements 2.1
      
      // Run property test with 100 iterations as specified in design document
      for (int i = 0; i < 100; i++) {
        // Generate random test data
        final email = generateRandomEmail();
        final password = generateRandomPassword();
        final wrongPassword = generateRandomPassword();
        
        // Ensure wrong password is actually different
        final actualWrongPassword = wrongPassword == password 
            ? generateRandomPassword() + "different"
            : wrongPassword;

        // Store user with secure password hashing
        passwordService.storeUserPassword(email, password);

        // Test 1: Correct password should authenticate successfully
        final correctCredentials = Credentials(email: email, password: password);
        final correctResult = await passwordService.authenticate(correctCredentials);
        
        expect(correctResult.success, isTrue, 
            reason: 'Correct password should authenticate successfully for iteration $i');
        expect(correctResult.sessionToken, isNotNull,
            reason: 'Successful authentication should provide session token for iteration $i');

        // Test 2: Wrong password should fail authentication
        final wrongCredentials = Credentials(email: email, password: actualWrongPassword);
        final wrongResult = await passwordService.authenticate(wrongCredentials);
        
        expect(wrongResult.success, isFalse,
            reason: 'Wrong password should fail authentication for iteration $i');
        expect(wrongResult.sessionToken, isNull,
            reason: 'Failed authentication should not provide session token for iteration $i');

        // Test 3: Verify that password hashing is used (not plaintext comparison)
        // This is verified by checking that the stored password data contains hash and salt
        final storedData = passwordService.getStoredPasswordData(email);
        expect(storedData, isNotNull, 
            reason: 'User password data should be stored for iteration $i');
        expect(storedData!.contains(':'), isTrue,
            reason: 'Stored password should contain hash:salt format for iteration $i');
        
        final parts = storedData.split(':');
        expect(parts.length, equals(2),
            reason: 'Stored password should have exactly 2 parts (hash:salt) for iteration $i');
        expect(parts[0], isNot(equals(password)),
            reason: 'Stored hash should not equal plaintext password for iteration $i');
        expect(parts[1], isNotEmpty,
            reason: 'Salt should not be empty for iteration $i');

        // Test 4: Verify cryptographic security - same password should produce different hashes with different salts
        final salt1 = passwordService.generateSalt();
        final salt2 = passwordService.generateSalt();
        final hash1 = passwordService.hashPassword(password, salt1);
        final hash2 = passwordService.hashPassword(password, salt2);
        
        expect(salt1, isNot(equals(salt2)),
            reason: 'Different salt generations should produce different salts for iteration $i');
        expect(hash1, isNot(equals(hash2)),
            reason: 'Same password with different salts should produce different hashes for iteration $i');

        // Test 5: Verify password verification function works correctly
        expect(passwordService.verifyPassword(password, parts[0], parts[1]), isTrue,
            reason: 'Password verification should succeed with correct password for iteration $i');
        expect(passwordService.verifyPassword(actualWrongPassword, parts[0], parts[1]), isFalse,
            reason: 'Password verification should fail with wrong password for iteration $i');
      }
    });

    test('Cryptographically Secure Token Generation', () {
      // Additional property test for session token security
      final tokens = <String>{};
      
      for (int i = 0; i < 100; i++) {
        final token = passwordService.generateSecureToken();
        
        // Verify token properties
        expect(token, isNotEmpty, reason: 'Token should not be empty for iteration $i');
        expect(token.length, greaterThan(20), 
            reason: 'Token should have sufficient length for iteration $i');
        expect(tokens.contains(token), isFalse,
            reason: 'Token should be unique for iteration $i');
        
        tokens.add(token);
      }
      
      // Verify we generated 100 unique tokens
      expect(tokens.length, equals(100),
          reason: 'All generated tokens should be unique');
    });

    test('Cryptographically Secure Salt Generation', () {
      final salts = <String>{};
      
      for (int i = 0; i < 100; i++) {
        final salt = passwordService.generateSalt();
        
        // Verify salt properties
        expect(salt, isNotEmpty, reason: 'Salt should not be empty for iteration $i');
        expect(salt.length, greaterThan(20), 
            reason: 'Salt should have sufficient length for iteration $i');
        expect(salts.contains(salt), isFalse,
            reason: 'Salt should be unique for iteration $i');
        
        salts.add(salt);
      }
      
      // Verify we generated 100 unique salts
      expect(salts.length, equals(100),
          reason: 'All generated salts should be unique');
    });
  });
}