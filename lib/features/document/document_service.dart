import 'dart:convert';
import 'dart:typed_data';

import 'package:docket/features/crypto/crypto_service.dart';
import 'package:sodium/sodium.dart';

class DocumentService {
  final crypto = CryptoService();

  String encryptMetaData(Map<String, dynamic> data, SecureKey familyKey) {
    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(data)));
    return base64Encode(crypto.encryptBytes(bytes, familyKey));
  }

  Map<String, dynamic> decryptMetaData(String base64, SecureKey familyKey) {
    final plain = crypto.decryptBytes(base64Decode(base64), familyKey);
    return jsonDecode(utf8.decode(plain)) as Map<String, dynamic>;
  }
}
