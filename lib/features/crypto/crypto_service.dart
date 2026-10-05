import 'dart:convert';

import 'package:docket/features/storage/storage_service.dart';
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
}
