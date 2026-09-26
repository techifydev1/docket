import 'package:flutter/material.dart';

class PrivacyCard extends StatelessWidget {
  const PrivacyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const .all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: .circular(8),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const .only(top: 2),
            decoration: BoxDecoration(
              color: colors.secondaryContainer,
              shape: .circle,
            ),
            child: Icon(
              Icons.lock_outline,
              size: 18,
              color: colors.onSecondaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "Strict Family Privacy",
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: .w600,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Only invited household members can access these documents. You will be prompted to invite loved ones or an executor in Step 3.",
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
