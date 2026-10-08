import 'package:docket/features/documents/document_category.dart';
import 'package:flutter/foundation.dart';

class AddDocumentProvider with ChangeNotifier {
  Uint8List? data;
  String? dataType;
  String? size;
  String? fileName;
  DocumentCategory? category;
  String? owner;
  List<String> tags = [];

  bool get hasFile => data != null;

  String get sizeLabel {
    final bytes = int.tryParse(size ?? "") ?? 0;
    if (bytes >= 1048576) return "${(bytes / 1048576).toStringAsFixed(1)} MB";
    if (bytes >= 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
    return "$bytes B";
  }

  void reset() {
    data = null;
    dataType = null;
    size = null;
    fileName = null;
    category = null;
    owner = null;
    tags = [];
    notifyListeners();
  }

  void updateFileInfo(
    Uint8List data,
    String dataType,
    String size,
    String fileName,
  ) {
    this.data = data;
    this.dataType = dataType;
    this.size = size;
    this.fileName = fileName;
    debugPrint("File gotten: $fileName $dataType $size");
    notifyListeners();
  }

  void updateCategory(DocumentCategory category) {
    this.category = category;
    notifyListeners();
  }

  void updateFileName(String fileName) {
    this.fileName = fileName;
    notifyListeners();
  }

  void updateOwner(String owner) {
    this.owner = owner;
    notifyListeners();
  }

  void updateTags(List<String> tags) {
    this.tags = tags;
    notifyListeners();
  }

  void addTag(String tag) {
    tags.add(tag);
    notifyListeners();
  }
}
