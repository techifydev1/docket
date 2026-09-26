import 'package:flutter/material.dart';

class DocumentsHeader extends StatelessWidget {
  final int documentCount;
  final VoidCallback onAdd;
  const DocumentsHeader({
    super.key,
    required this.documentCount,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                "Documents",
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: .w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "$documentCount encrypted files in this vault",
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: onAdd,
          style: FilledButton.styleFrom(
            backgroundColor: colors.primary,
            foregroundColor: colors.onPrimary,
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: .circular(8)),
          ),
          icon: const Icon(Icons.upload_file, size: 18),
          label: Text(
            "Add",
            style: textTheme.labelLarge?.copyWith(color: colors.onPrimary),
          ),
        ),
      ],
    );
  }
}
