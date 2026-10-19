import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final Map<String, String> _cache = {};
  static bool _primed = false;
  static const String _biometricsKey = "use_biometrics";
  static const String _plainNamespace = "docket_vault";
  static const String _biometricNamespace = "docket_vault_biometrics";

  final preferences = const FlutterSecureStorage();

  bool _biometricsEnabled = false;
  bool _modeResolved = false;
  FlutterSecureStorage _storage = _build(false);

  static FlutterSecureStorage _build(bool biometrics) {
    if (!biometrics) {
      return const FlutterSecureStorage(
        aOptions: AndroidOptions(storageNamespace: _plainNamespace),
      );
    }
    return const FlutterSecureStorage(
      aOptions: AndroidOptions.biometric(
        enforceBiometrics: true,
        resetOnError: false,
        storageNamespace: _biometricNamespace,
        biometricPromptTitle: "Unlock Docket",
        biometricPromptSubtitle: "Confirm it's you to open your vault",
      ),
      iOptions: IOSOptions(
        accessControlFlags: [AccessControlFlag.userPresence],
      ),
    );
  }

  Future<void> _ensureMode() async {
    if (_modeResolved) return;
    _biometricsEnabled = await useBiometrics();
    _storage = _build(_biometricsEnabled);
    _modeResolved = true;
  }

  Future<void> prime() async {
    if (_primed) return;
    await _ensureMode();
    final values = await _storage.readAll();
    _cache
      ..clear()
      ..addAll(values);
    _primed = true;
  }

  Future<void> save(String key, String value) async {
    await _ensureMode();
    _cache[key] = value;
    await _storage.write(key: key, value: value);
  }

  Future<String?> get(String key) async {
    await _ensureMode();
    if (_primed) return _cache[key];
    return _storage.read(key: key);
  }

  Future<bool> useBiometrics() async {
    return (await preferences.read(key: _biometricsKey)) == "true";
  }

  Future<bool> saveUseBiometrics(bool value) async {
    await _ensureMode();
    if (value == _biometricsEnabled) return true;

    final from = _storage;
    final to = _build(value);
    final Map<String, String> values;
    try {
      values = _primed ? Map.of(_cache) : await from.readAll();
      for (final entry in values.entries) {
        await to.write(key: entry.key, value: entry.value);
      }
      await from.deleteAll();
    } catch (_) {
      return false;
    }

    _biometricsEnabled = value;
    _storage = to;
    _cache
      ..clear()
      ..addAll(values);
    _primed = true;
    await preferences.write(
      key: _biometricsKey,
      value: value ? "true" : "false",
    );
    return true;
  }

  Future<bool> verifyBiometrics() async {
    await _ensureMode();
    if (!_biometricsEnabled) return true;
    try {
      await _storage.write(key: "_probe", value: "1");
      final probe = await _storage.read(key: "_probe");
      await _storage.delete(key: "_probe");
      return probe == "1";
    } catch (_) {
      return false;
    }
  }
}
