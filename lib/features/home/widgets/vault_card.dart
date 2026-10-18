import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/features/documents/documents_provider.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/home/widgets/stat.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VaultCard extends StatelessWidget {
  const VaultCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    final family = context.watch<FamilyProvider>().selectedFamily;
    final documentCount = context.watch<DocumentsProvider>().documents.length;
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
                      family?.name ?? "",
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
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Stat(value: "$documentCount", label: "Documents"),
              ),
              Expanded(
                child: Stat(
                  value: "${family?.memberCount ?? 0}",
                  label: "Members",
                ),
              ),
              const Expanded(
                child: Stat(value: "100%", label: "Encrypted"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
