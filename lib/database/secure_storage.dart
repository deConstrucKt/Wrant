import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  final _iosOptions = const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  // Store a single value
  Future<void> savePIN(String pin) async {
    try {
      await _storage.write(
        key: 'PIN',
        value: pin,
        iOptions: _iosOptions,
      );
    } catch (e) {
      // Exception
    }
  }

  // Read a single value
  Future<String?> getPIN() async {
    try {
      String? pin = await _storage.read(key: 'PIN');
      return pin;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveTokenKey(String token) async {
    try {
      await _storage.write(
        key: 'auth_token',
        value: token,
        iOptions: _iosOptions,
      );
    } catch (e) {
      // Exception
    }
  }

  Future<String?> getTokenKey() async {
    try {
      String? token = await _storage.read(key: 'auth_token');
      return token;
    } catch (e) {
      return null;
    }
  }

  Future<void> deletePIN() async {
    try {
      await _storage.delete(key: 'PIN');
    } catch (e) {
      // exception
    }
  }
}