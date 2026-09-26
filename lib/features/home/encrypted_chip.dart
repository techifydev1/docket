import 'package:flutter/material.dart';

class EncryptedChip extends StatelessWidget {
  const EncryptedChip({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline,
            size: 12,
            color: colors.onSecondaryContainer,
          ),
          const SizedBox(width: 4),
          Text(
            "Encrypted",
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSecondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
