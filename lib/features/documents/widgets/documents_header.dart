import 'package:docket/core/theme/vault_theme.dart';
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
    final textTheme = VaultTheme.textTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text("Documents", style: textTheme.headlineLarge),
              const SizedBox(height: 2),
              Text(
                "$documentCount encrypted files in this vault",
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        FilledButton.icon(
          onPressed: onAdd,
          style: FilledButton.styleFrom(
            minimumSize: const Size(0, 44),
            padding: const .symmetric(horizontal: 16),
          ),
          icon: const Icon(Icons.upload_file_rounded, size: 18),
          label: const Text("Add"),
        ),
      ],
    );
  }
}
