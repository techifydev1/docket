import 'dart:convert';

import 'package:docket/features/storage/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:sodium/sodium.dart';
import 'package:bip39/bip39.dart' as bip39;

class CryptoService {
  late final Sodium sodium;
  final StorageService storage = StorageService();
  Future<void> initSodium() async {
    sodium = await SodiumInit.init();
  }

  Future<bool> hasUserKeys() async {
    return await storage.get("private_key") != null &&
        await storage.get("public_key") != null;
  }

  Future<String> createUserKeys() async {
    if (await hasUserKeys()) return (await storage.get("public_key"))!;
    final kp = sodium.crypto.box.keyPair();
    await storage.save(
      "private_key",
      base64Encode(kp.secretKey.extractBytes()),
    );
    await storage.save("public_key", base64Encode(kp.publicKey));
    final pub = base64Encode(kp.publicKey);
    kp.secretKey.dispose();
    return pub;
  }

  SecureKey generateFamilyKey() => sodium.crypto.secretBox.keygen();

  String wrapFamilyKey(SecureKey familyKey, Uint8List memberPublicKey) {
    final wrapped = familyKey.runUnlockedSync<Uint8List>(
      (bytes) =>
          sodium.crypto.box.seal(message: bytes, publicKey: memberPublicKey),
    );
    return base64Encode(wrapped);
  }

  String _familyKeyStorageKey(String familyId, String version) =>
      'family_key_${familyId}_$version';

  Future<void> saveFamilyKeyLocally(
    String familyId,
    SecureKey familyKey,
    int version,
  ) async {
    await storage.save(
      _familyKeyStorageKey(familyId, '$version'),
      base64Encode(familyKey.extractBytes()),
    );
  }

  Future<SecureKey?> loadFamilyKeyLocally(String familyId, int version) async {
    final b64 = await storage.get(_familyKeyStorageKey(familyId, '$version'));
    if (b64 == null) return null;
    return sodium.secureCopy(base64Decode(b64));
  }

  Future<SecureKey> unwrapFamilyKey(String wrappedBase64) async {
    final secretKey = sodium.secureCopy(
      base64Decode((await storage.get("private_key"))!),
    );
    final publicKey = base64Decode((await storage.get("public_key"))!);
    try {
      final raw = sodium.crypto.box.sealOpen(
        cipherText: base64Decode(wrappedBase64),
        publicKey: publicKey,
        secretKey: secretKey,
      );
      return sodium.secureCopy(raw);
    } finally {
      secretKey.dispose();
    }
  }

  Future<void> ensureFamilyKey(
    String familyId,
    String? wrappedBase64,
    int version,
  ) async {
    try {
      if (wrappedBase64 == null || wrappedBase64.isEmpty) return;
      final storageKey = _familyKeyStorageKey(familyId, '$version');
      if (await storage.get(storageKey) != null) return;
      if (!await hasUserKeys()) return;
      final key = await unwrapFamilyKey(wrappedBase64);
      await storage.save(storageKey, base64Encode(key.extractBytes()));
      key.dispose();
    } catch (e) {
      debugPrint("Unable to restore family key for $familyId: $e");
    }
  }

  Uint8List encryptBytes(Uint8List data, SecureKey key) {
    final nonce = sodium.randombytes.buf(sodium.crypto.secretBox.nonceBytes);
    final cipher = sodium.crypto.secretBox.easy(
      message: data,
      nonce: nonce,
      key: key,
    );
    return Uint8List.fromList([...nonce, ...cipher]);
  }

  Uint8List decryptBytes(Uint8List blob, SecureKey key) {
    final n = sodium.crypto.secretBox.nonceBytes;
    return sodium.crypto.secretBox.openEasy(
      cipherText: blob.sublist(n),
      nonce: blob.sublist(0, n),
      key: key,
    );
  }

  String generateRecoveryPhrase() {
    return bip39.generateMnemonic(strength: 256);
  }

  bool isValidRecoveryPhrase(String phrase) {
    return bip39.validateMnemonic(phrase);
  }

  SecureKey _recoveryKeyFromPhrase(String phrase) {
    final hash = sodium.crypto.genericHash(
      message: Uint8List.fromList(utf8.encode(phrase)),
    );
    return sodium.secureCopy(hash);
  }

  Future<String> buildBackupKey(String phrase) async {
    final privateKey = await storage.get("private_key");
    final publicKey = await storage.get("public_key");
    if (privateKey == null || publicKey == null) {
      throw Exception("No private key or public key present");
    }
    final recoveryKey = _recoveryKeyFromPhrase(phrase);
    final nonce = sodium.randombytes.buf(sodium.crypto.secretBox.nonceBytes);
    try {
      final encrypted = sodium.crypto.secretBox.easy(
        message: Uint8List.fromList(
          utf8.encode(
            jsonEncode({"publicKey": publicKey, "privateKey": privateKey}),
          ),
        ),
        nonce: nonce,
        key: recoveryKey,
      );
      return base64Encode([...nonce, ...encrypted]);
    } finally {
      recoveryKey.dispose();
    }
  }

  Future<void> restoreKeyFromBackup(String phrase, String backup) async {
    if (!isValidRecoveryPhrase(phrase)) {
      throw Exception("Invalid recovery phrase");
    }
    final blob = base64Decode(backup);
    final nonceBytes = sodium.crypto.secretBox.nonceBytes;
    if (blob.length <= nonceBytes) {
      throw Exception("Invalid recovery backup");
    }
    final recoveryKey = _recoveryKeyFromPhrase(phrase);
    try {
      final decrypted = sodium.crypto.secretBox.openEasy(
        cipherText: blob.sublist(nonceBytes),
        nonce: blob.sublist(0, nonceBytes),
        key: recoveryKey,
      );
      final data = jsonDecode(utf8.decode(decrypted)) as Map<String, dynamic>;
      await storage.save("private_key", data["privateKey"] as String);
      await storage.save("public_key", data["publicKey"] as String);
    } on SodiumException {
      throw Exception("Invalid recovery phrase or corrupted backup");
    } finally {
      recoveryKey.dispose();
    }
  }
}
