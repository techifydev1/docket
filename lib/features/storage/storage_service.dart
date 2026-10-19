import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final Map<String, String> _cache = {};
  static bool _primed = false;
  static const String _biometricsKey = "use_biometrics";

  final storage = FlutterSecureStorage();
  final preferences = FlutterSecureStorage();

  Future<void> prime() async {
    if (_primed) return;
    final values = await storage.readAll();
    _cache
      ..clear()
      ..addAll(values);
    _primed = true;
  }

  Future<void> save(String key, String value) async {
    _cache[key] = value;
    await storage.write(key: key, value: value);
  }

  Future<String?> get(String key) async {
    if (_primed) return _cache[key];
    return storage.read(key: key);
  }

  Future<void> saveUseBiometrics(bool value) async {
    await preferences.write(
      key: _biometricsKey,
      value: value ? "true" : "false",
    );
  }

  Future<bool> useBiometrics() async {
    return (await preferences.read(key: _biometricsKey)) != "false";
  }
}
