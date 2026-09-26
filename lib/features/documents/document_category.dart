import 'package:flutter/material.dart';

enum DocumentCategory {
  all("All", Icons.article_outlined),
  certificates("Certificates", Icons.article_outlined),
  property("Property", Icons.home_work_outlined),
  health("Health", Icons.health_and_safety_outlined),
  identity("IDs", Icons.badge_outlined);

  final String label;
  final IconData icon;
  const DocumentCategory(this.label, this.icon);
}

final List<DocumentCategory> documentCategories = [
  for (final category in DocumentCategory.values)
    if (category != DocumentCategory.all) category,
];
