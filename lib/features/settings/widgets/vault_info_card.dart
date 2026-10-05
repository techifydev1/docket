import 'package:docket/features/family/family_response.dart';
import 'package:docket/shared/info_row.dart';
import 'package:flutter/material.dart';

class VaultInfoCard extends StatelessWidget {
  final FamilyResponse family;
  const VaultInfoCard({super.key, required this.family});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final created = DateTime.tryParse(family.createdAt);
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: .circular(12),
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
                  borderRadius: .circular(8),
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
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      family.name,
                      maxLines: 1,
                      overflow: .ellipsis,
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
          const SizedBox(height: 8),
          InfoRow(label: "Vault ID", value: family.id),
          InfoRow(
            label: "Created",
            value: created == null
                ? "-"
                : MaterialLocalizations.of(
                    context,
                  ).formatMediumDate(created.toLocal()),
          ),
          InfoRow(label: "Members", value: "${family.memberCount}"),
          const InfoRow(label: "Encryption", value: "Zero-knowledge"),
        ],
      ),
    );
  }
}
