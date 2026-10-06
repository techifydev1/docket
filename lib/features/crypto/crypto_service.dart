import 'dart:convert';

import 'package:docket/features/storage/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:sodium/sodium.dart';

class CryptoService {
  late final Sodium sodium;
  final StorageService storage = StorageService();
  Future<void> initSodium() async {
    sodium = await SodiumInit.init();
  }

  Future<String> createUserKeys() async {
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

  Future<void> saveFamilyKeyLocally(
    String familyId,
    SecureKey familyKey,
  ) async {
    await storage.save(
      'family_key_$familyId',
      base64Encode(familyKey.extractBytes()),
    );
  }

  Future<SecureKey?> loadFamilyKeyLocally(String familyId) async {
    final b64 = await storage.get('family_key_$familyId');
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
}
