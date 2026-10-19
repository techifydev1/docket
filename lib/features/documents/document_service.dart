import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/documents/models/document_record.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/http/dio_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sodium/sodium.dart';

class DocumentService {
  final CryptoService crypto;
  final DioClient client = DioClient();

  DocumentService(this.crypto);

  static const _cloudinaryUploadBase = "https://api.cloudinary.com/v1_1";
  static const _maxCachedDocuments = 5;

  final Map<String, Uint8List> _decryptedCache = {};

  String _cacheKey(DocumentRecord document) =>
      "${document.id}:${document.cloudinaryVersion}";

  Uint8List? _cachedDecrypted(DocumentRecord document) =>
      _decryptedCache[_cacheKey(document)];

  void _cacheDecrypted(DocumentRecord document, Uint8List bytes) {
    final key = _cacheKey(document);
    _decryptedCache.remove(key);
    _decryptedCache[key] = bytes;
    while (_decryptedCache.length > _maxCachedDocuments) {
      _decryptedCache.remove(_decryptedCache.keys.first);
    }
  }

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

  Future<DocumentRecord> uploadDocument({
    required String familyId,
    required int keyVersion,
    required String ownerId,
    required String addedBy,
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
      final docId = publicId.split("/").last;
      final cipher = crypto.encryptBytes(data, familyKey);
      final upload = await _uploadToCloudinary(
        sign,
        publicId,
        cipher,
        fileName,
      );
      final uploadedPublicId = "${upload["public_id"]}";
      final cloudinaryVersion = "${upload["version"]}";
      final encryptedMetadata = encryptMetaData({
        "title": title,
        "category": category,
        "tags": tags,
        "fileName": fileName,
        "size": size,
        "dataType": dataType,
      }, familyKey);
      await confirmUpload(
        familyId: familyId,
        docId: docId,
        publicId: uploadedPublicId,
        cloudinaryVersion: cloudinaryVersion,
        signature: "${upload["signature"]}",
        encryptedMetadata: encryptedMetadata,
        keyVersion: keyVersion,
        ownerId: ownerId,
      );
      return DocumentRecord(
        id: docId,
        encryptedMetadata: encryptedMetadata,
        keyVersion: keyVersion,
        addedBy: addedBy,
        addedAt: DateTime.now().toUtc().toIso8601String(),
        ownerId: ownerId,
        publicId: uploadedPublicId,
        cloudinaryVersion: cloudinaryVersion,
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
      "max_file_size": "${sign["max_file_size"]}",
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
      throw ApiError(
        "upload_failed",
        message ?? "The file could not be uploaded, please try again",
        0,
        DateTime.now().toString(),
      );
    }
  }

  Future<String> getDownloadUrl(String familyId, String docId) async {
    try {
      return await client.get<String, Map<String, dynamic>>(
        "/document/$familyId/$docId/url",
        decoder: (json) => json["url"] as String,
      );
    } on ApiError {
      rethrow;
    }
  }

  Future<void> deleteDocument(String familyId, String docId) async {
    try {
      await client.delete<Map<String, dynamic>>(
        "/document/$familyId/$docId",
        decoder: (json) => json as Map<String, dynamic>,
      );
      _decryptedCache.removeWhere((key, _) => key.startsWith("$docId:"));
    } on ApiError {
      rethrow;
    }
  }

  Future<Uint8List> getDecryptedBytes(
    BuildContext context,
    Uint8List encryptedBytes,
  ) async {
    final familyKey = await getDecryptedFamilyKey(context);
    try {
      return crypto.decryptBytes(encryptedBytes, familyKey);
    } finally {
      familyKey.dispose();
    }
  }

  Future<SecureKey> getDecryptedFamilyKey(BuildContext context) async {
    final family = context.read<FamilyProvider>().selectedFamily!;
    return crypto.unwrapFamilyKey(family.wrappedKey!);
  }

  Future<Uint8List?> getEncryptedBlob(String familyId, String docId) async {
    final url = await getDownloadUrl(familyId, docId);
    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: .bytes),
      );
      final data = response.data;
      return data == null ? null : Uint8List.fromList(data);
    } on DioException catch (e) {
      throw ApiError(
        "download_failed",
        "The file could not be downloaded, please try again",
        e.response?.statusCode ?? 0,
        DateTime.now().toString(),
      );
    }
  }

  Future<SecureKey> _loadFamilyKey(
    String familyId,
    String wrappedKey,
    int keyVersion,
  ) async {
    final local = await crypto.loadFamilyKeyLocally(familyId, keyVersion);
    return local ?? await crypto.unwrapFamilyKey(wrappedKey);
  }

  Future<Uint8List?> getDecryptedDocument(
    BuildContext context,
    DocumentRecord document,
  ) async {
    final cached = _cachedDecrypted(document);
    if (cached != null) return cached;
    final family = context.read<FamilyProvider>().selectedFamily;
    if (family == null || family.wrappedKey == null) return null;
    final familyKey = await _loadFamilyKey(
      family.id,
      family.wrappedKey!,
      document.keyVersion,
    );
    try {
      final bytes = await _downloadAndDecrypt(family.id, document, familyKey);
      if (bytes != null) _cacheDecrypted(document, bytes);
      return bytes;
    } finally {
      familyKey.dispose();
    }
  }

  Future<Uint8List?> _downloadAndDecrypt(
    String familyId,
    DocumentRecord document,
    SecureKey familyKey,
  ) async {
    final encryptedBytes = await getEncryptedBlob(familyId, document.id);
    if (encryptedBytes == null) return null;
    return crypto.decryptBytes(encryptedBytes, familyKey);
  }

  Future<void> shareDecrypted(
    BuildContext context,
    DocumentRecord document,
  ) async {
    final family = context.read<FamilyProvider>().selectedFamily;
    if (family == null || family.wrappedKey == null) return;
    final familyKey = await _loadFamilyKey(
      family.id,
      family.wrappedKey!,
      document.keyVersion,
    );
    try {
      final metadata = decryptMetaData(document.encryptedMetadata, familyKey);
      final decryptedBytes =
          _cachedDecrypted(document) ??
          await _downloadAndDecrypt(family.id, document, familyKey);
      if (decryptedBytes == null) return;
      _cacheDecrypted(document, decryptedBytes);
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              decryptedBytes,
              name: metadata["fileName"]?.toString() ?? "document",
              mimeType: _mimeFromExtension(metadata["dataType"]?.toString()),
            ),
          ],
        ),
      );
    } finally {
      familyKey.dispose();
    }
  }

  String _mimeFromExtension(String? extension) {
    switch (extension?.toLowerCase()) {
      case "pdf":
        return "application/pdf";
      case "png":
        return "image/png";
      case "jpg":
      case "jpeg":
        return "image/jpeg";
      case "gif":
        return "image/gif";
      case "webp":
        return "image/webp";
      case "txt":
        return "text/plain";
      case "doc":
        return "application/msword";
      case "docx":
        return "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
      case "xls":
        return "application/vnd.ms-excel";
      case "xlsx":
        return "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
      default:
        return "application/octet-stream";
    }
  }
}
