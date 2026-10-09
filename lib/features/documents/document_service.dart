import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/documents/models/document_record.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/http/dio_client.dart';
import 'package:flutter/foundation.dart';
import 'package:sodium/sodium.dart';

class DocumentService {
  final CryptoService crypto;
  final DioClient client = DioClient();

  DocumentService(this.crypto);

  static const _cloudinaryUploadBase = "https://api.cloudinary.com/v1_1";

  String encryptMetaData(Map<String, dynamic> data, SecureKey familyKey) {
    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(data)));
    return base64Encode(crypto.encryptBytes(bytes, familyKey));
  }

  Map<String, dynamic> decryptMetaData(String base64, SecureKey familyKey) {
    final plain = crypto.decryptBytes(base64Decode(base64), familyKey);
    return jsonDecode(utf8.decode(plain)) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> signUpload(String familyId) async {
    try {
      return await client.post<Map<String, dynamic>>("/document/sign", {
        "familyId": familyId,
      }, decoder: (json) => json as Map<String, dynamic>);
    } on ApiError {
      rethrow;
    }
  }

  Future<List<DocumentRecord>> getDocuments(String familyId) async {
    try {
      return await client.get<List<DocumentRecord>, List<dynamic>>(
        "/document/$familyId",
        decoder: (json) => json
            .map((doc) => DocumentRecord.fromJson(doc as Map<String, dynamic>))
            .toList(),
      );
    } on ApiError {
      rethrow;
    }
  }

  Future<void> confirmUpload({
    required String familyId,
    required String docId,
    required String publicId,
    required String cloudinaryVersion,
    required String signature,
    required String encryptedMetadata,
    required int keyVersion,
    required String ownerId,
  }) async {
    try {
      await client.post<Map<String, dynamic>>("/document/confirm", {
        "familyId": familyId,
        "docId": docId,
        "publicId": publicId,
        "cloudinaryVersion": cloudinaryVersion,
        "signature": signature,
        "encryptedMetadata": encryptedMetadata,
        "kv": "$keyVersion",
        "ownerId": ownerId,
      }, decoder: (json) => json as Map<String, dynamic>);
    } on ApiError {
      rethrow;
    }
  }

  Future<void> uploadDocument({
    required String familyId,
    required int keyVersion,
    required String ownerId,
    required String title,
    required String category,
    required List<String> tags,
    required Uint8List data,
    required String dataType,
    required String size,
    required String fileName,
  }) async {
    final familyKey = await crypto.loadFamilyKeyLocally(familyId, keyVersion);
    if (familyKey == null) {
      throw ApiError(
        "missing_family_key",
        "Your encryption key for this vault is missing on this device",
        0,
        DateTime.now().toString(),
      );
    }
    try {
      final sign = await signUpload(familyId);
      final publicId = sign["public_id"] as String;
      final cipher = crypto.encryptBytes(data, familyKey);
      final upload = await _uploadToCloudinary(
        sign,
        publicId,
        cipher,
        fileName,
      );
      final uploadedPublicId = "${upload["public_id"]}";
      await confirmUpload(
        familyId: familyId,
        docId: publicId.split("/").last,
        publicId: uploadedPublicId,
        cloudinaryVersion: "${upload["version"]}",
        signature: "${upload["signature"]}",
        encryptedMetadata: encryptMetaData({
          "title": title,
          "category": category,
          "tags": tags,
          "fileName": fileName,
          "size": size,
          "dataType": dataType,
        }, familyKey),
        keyVersion: keyVersion,
        ownerId: ownerId,
      );
    } finally {
      familyKey.dispose();
    }
  }

  Future<Map<String, dynamic>> _uploadToCloudinary(
    Map<String, dynamic> sign,
    String publicId,
    Uint8List cipher,
    String fileName,
  ) async {
    final formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(cipher, filename: fileName),
      "api_key": "${sign["apiKey"]}",
      "timestamp": "${sign["timestamp"]}",
      "public_id": publicId,
      "type": "authenticated",
      "overwrite": "false",
      "signature": "${sign["signature"]}",
    });
    try {
      final response = await Dio().post(
        "$_cloudinaryUploadBase/${sign["cloudName"]}/raw/upload",
        data: formData,
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final data = e.response?.data;
      final dynamic body = data is Map<String, dynamic> ? data["error"] : null;
      final message = body is Map<String, dynamic>
          ? body["message"]?.toString()
          : null;
      debugPrint(body.toString());
      throw ApiError(
        "upload_failed",
        message ?? "The file could not be uploaded, please try again",
        0,
        DateTime.now().toString(),
      );
    }
  }
}
