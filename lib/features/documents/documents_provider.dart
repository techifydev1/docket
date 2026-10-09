import 'package:docket/features/documents/document_category.dart';
import 'package:docket/features/documents/document_item.dart';
import 'package:docket/features/documents/document_service.dart';
import 'package:docket/features/documents/models/document_record.dart';
import 'package:docket/features/family/family_member.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:flutter/foundation.dart';

const _months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

class DocumentsProvider extends ChangeNotifier {
  final DocumentService service;

  DocumentsProvider(this.service);

  List<DocumentItem> _documents = [];
  bool _isLoading = false;
  String? _error;

  List<DocumentItem> get documents => _documents;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load({
    required String familyId,
    required List<FamilyMember> members,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final records = await service.getDocuments(familyId);
      final items = <DocumentItem>[];
      for (final record in records) {
        final item = await _decrypt(record, familyId, members);
        if (item != null) items.add(item);
      }
      _documents = items;
    } on ApiError catch (e) {
      _error = e.errorMessage;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void add(DocumentItem item) {
    _documents = [item, ..._documents];
    notifyListeners();
  }

  Future<DocumentItem?> _decrypt(
    DocumentRecord record,
    String familyId,
    List<FamilyMember> members,
  ) async {
    final key = await service.crypto.loadFamilyKeyLocally(
      familyId,
      record.keyVersion,
    );
    if (key == null) return null;
    try {
      final meta = service.decryptMetaData(record.encryptedMetadata, key);
      return _toItem(record, meta, members);
    } catch (_) {
      return null;
    } finally {
      key.dispose();
    }
  }

  DocumentItem _toItem(
    DocumentRecord record,
    Map<String, dynamic> meta,
    List<FamilyMember> members,
  ) {
    final label = meta["category"]?.toString();
    final category = documentCategories.firstWhere(
      (category) => category.label == label,
      orElse: () => documentCategories.first,
    );
    final addedAt = DateTime.tryParse(record.addedAt);
    final tags =
        (meta["tags"] as List?)?.map((tag) => tag.toString()).toList() ??
        const <String>[];
    final dataType = meta["dataType"]?.toString() ?? "";
    return DocumentItem(
      icon: category.icon,
      title: meta["title"]?.toString() ?? "Untitled document",
      subtitle: _addedLabel(addedAt),
      category: category,
      owner: _nameOf(record.ownerId, members),
      fileName: meta["fileName"]?.toString() ?? "",
      addedOn: _formatDate(addedAt),
      modifiedOn: _formatDate(addedAt),
      fingerprint: "Sealed",
      fileType: dataType.toUpperCase(),
      fileSize: _sizeLabel(meta["size"]?.toString() ?? ""),
      pageCount: 0,
      addedBy: _nameOf(record.addedBy, members),
      tags: tags,
    );
  }

  String _nameOf(String userId, List<FamilyMember> members) {
    for (final member in members) {
      if (member.userId == userId) return member.name;
    }
    return "Unknown member";
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Unknown";
    final local = date.toLocal();
    return "${local.day} ${_months[local.month - 1]} ${local.year}";
  }

  String _addedLabel(DateTime? date) {
    if (date == null) return "Added recently";
    final diff = DateTime.now().difference(date.toLocal());
    if (diff.inMinutes < 1) return "Added just now";
    if (diff.inHours < 1) return "Added ${diff.inMinutes}m ago";
    if (diff.inDays < 1) return "Added ${diff.inHours}h ago";
    if (diff.inDays < 7) return "Added ${diff.inDays}d ago";
    if (diff.inDays < 30) return "Added ${diff.inDays ~/ 7}w ago";
    if (diff.inDays < 365) return "Added ${diff.inDays ~/ 30}mo ago";
    return "Added ${diff.inDays ~/ 365}y ago";
  }

  String _sizeLabel(String size) {
    final bytes = int.tryParse(size) ?? 0;
    if (bytes >= 1048576) return "${(bytes / 1048576).toStringAsFixed(1)} MB";
    if (bytes >= 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "$bytes B";
  }
}
