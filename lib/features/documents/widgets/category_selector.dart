import 'package:docket/features/documents/document_category.dart';
import 'package:flutter/material.dart';

class CategorySelector extends StatelessWidget {
  final DocumentCategory? selected;
  final ValueChanged<DocumentCategory> onChanged;
  const CategorySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = DocumentCategory.values
        .where((category) => category != DocumentCategory.all)
        .toList();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final category in categories)
          ChoiceChip(
            label: Text(category.label),
            selected: category == selected,
            onSelected: (_) => onChanged(category),
          ),
      ],
    );
  }
}
