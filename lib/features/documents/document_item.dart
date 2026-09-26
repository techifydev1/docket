import 'package:docket/features/documents/document_category.dart';
import 'package:flutter/material.dart';

class DocumentItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final DocumentCategory category;
  final String owner;
  final String fileName;
  final String addedOn;
  final String modifiedOn;
  final String fingerprint;
  final String fileType;
  final String fileSize;
  final int pageCount;
  final String addedBy;
  final String visibility;
  final List<String> tags;
  const DocumentItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.owner,
    required this.fileName,
    required this.addedOn,
    required this.modifiedOn,
    required this.fingerprint,
    this.fileType = "PDF",
    this.fileSize = "1.4 MB",
    this.pageCount = 2,
    this.addedBy = "Eleanor Vance",
    this.visibility = "All family members",
    this.tags = const [],
  });
}
