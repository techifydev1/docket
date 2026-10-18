import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class PillChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onDeleted;
  const PillChip({
    super.key,
    required this.icon,
    required this.label,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return Container(
      height: 26,
      padding: const .symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: VaultTheme.primarySoft,
        borderRadius: .circular(999),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(icon, size: 13, color: VaultTheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            overflow: .ellipsis,
            style: textTheme.labelMedium?.copyWith(color: VaultTheme.primary),
          ),
          if (onDeleted != null) ...[
            const SizedBox(width: 2),
            IconButton(
              onPressed: onDeleted,
              tooltip: 'Remove $label',
              icon: const Icon(Icons.close),
              iconSize: 12,
              padding: .zero,
              visualDensity: .compact,
              constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
              color: VaultTheme.primary,
            ),
          ],
        ],
      ),
    );
  }
}
