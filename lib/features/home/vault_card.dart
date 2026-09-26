import 'package:flutter/material.dart';

import 'stat.dart';

class VaultCard extends StatelessWidget {
  const VaultCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.roofing,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "The Vance Family",
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Household Archival System",
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, thickness: 1, color: colors.surfaceContainerHigh),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: Stat(value: "12", label: "Documents")),
              Expanded(child: Stat(value: "4", label: "Members")),
              Expanded(child: Stat(value: "100%", label: "Encrypted")),
            ],
          ),
        ],
      ),
    );
  }
}
