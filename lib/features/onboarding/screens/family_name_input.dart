import 'package:flutter/material.dart';

class FamilyNameInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  const FamilyNameInput({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Vault or Household Name",
              style: textTheme.labelMedium?.copyWith(color: colors.onSurface),
            ),
            Text(
              "${controller.text.length}/36",
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: colors.onSurface.withValues(alpha: 0.05),
                offset: const Offset(0, 1),
                blurRadius: 2,
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLength: 36,
            onChanged: (_) => onChanged(),
            textCapitalization: TextCapitalization.sentences,
            style: textTheme.bodyLarge?.copyWith(color: colors.onSurface),
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
              prefixIcon: Icon(Icons.folder_shared, size: 20),
              prefixIconColor: colors.onSurfaceVariant,
              hintText: "e.g., The Aina Family",
              hintStyle: textTheme.bodyLarge?.copyWith(color: colors.outline),
            ),
          ),
        ),
      ],
    );
  }
}
