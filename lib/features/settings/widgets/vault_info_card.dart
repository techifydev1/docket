import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/features/family/family_response.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:docket/shared/info_row.dart';
import 'package:flutter/material.dart';

class VaultInfoCard extends StatelessWidget {
  final FamilyResponse family;
  const VaultInfoCard({super.key, required this.family});

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    final created = DateTime.tryParse(family.createdAt);
    return DocketCard(
      child: Column(
        children: [
          Row(
            children: [
              const IconTile(
                icon: Icons.roofing_rounded,
                size: 48,
                iconSize: 24,
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
                      style: textTheme.labelLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Household Archival System",
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 1),
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
