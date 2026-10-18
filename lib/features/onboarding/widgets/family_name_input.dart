import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class FamilyNameInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  const FamilyNameInput({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text("VAULT OR HOUSEHOLD NAME", style: textTheme.labelSmall),
            Text("${controller.text.length}/36", style: textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: VaultTheme.surfaceMuted,
            borderRadius: .circular(VaultTheme.radiusMd),
          ),
          child: TextField(
            controller: controller,
            maxLength: 36,
            onChanged: (_) => onChanged(),
            textCapitalization: .sentences,
            style: textTheme.bodyLarge,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              prefixIcon: const Icon(Icons.folder_shared_rounded, size: 20),
              prefixIconColor: VaultTheme.inkMuted,
              hintText: "e.g., The Aina Family",
              hintStyle: textTheme.bodyLarge?.copyWith(
                color: VaultTheme.inkMuted.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
