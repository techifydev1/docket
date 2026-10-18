import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:flutter/material.dart';

class TrustSection extends StatelessWidget {
  const TrustSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return DocketCard(
      padding: const .all(16),
      child: Row(
        children: [
          const IconTile(icon: Icons.roofing_rounded, size: 48, iconSize: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "ZERO-KNOWLEDGE VAULT",
                  style: VaultTheme.overline.copyWith(
                    color: VaultTheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text("Household Archival System", style: textTheme.labelLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
