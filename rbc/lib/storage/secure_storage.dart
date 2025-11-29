import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final _storage = FlutterSecureStorage();

  // Save a key-value pair
  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Read a value by key
  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  // Delete a value by key
  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Clear all storage
  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
