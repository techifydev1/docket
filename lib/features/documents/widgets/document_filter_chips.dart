import 'package:docket/features/documents/document_category.dart';
import 'package:flutter/material.dart';

class DocumentFilterChips extends StatelessWidget {
  final DocumentCategory selected;
  final ValueChanged<DocumentCategory> onChanged;
  const DocumentFilterChips({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = DocumentCategory.values;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < categories.length; i++) ...[
            FilterChip(
              label: Text(categories[i].label),
              selected: categories[i] == selected,
              onSelected: (_) => onChanged(categories[i]),
              showCheckmark: false,
            ),
            if (i != categories.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}
