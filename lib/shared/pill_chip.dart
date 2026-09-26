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
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 24,
      padding: const .symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: .circular(9999),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(icon, size: 12, color: colors.onSecondaryContainer),
          const SizedBox(width: 4),
          Text(
            label,
            maxLines: 1,
            overflow: .ellipsis,
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSecondaryContainer,
            ),
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
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              color: colors.onSecondaryContainer,
            ),
          ],
        ],
      ),
    );
  }
}
