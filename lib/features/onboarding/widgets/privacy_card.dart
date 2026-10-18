import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:flutter/material.dart';

class PrivacyCard extends StatelessWidget {
  const PrivacyCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return DocketCard(
      padding: const .all(14),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          const IconTile(
            icon: Icons.lock_outline,
            size: 36,
            filled: false,
            iconSize: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text("Strict Family Privacy", style: textTheme.labelMedium),
                const SizedBox(height: 2),
                Text(
                  "Only invited household members can access these documents. You will be prompted to invite loved ones or an executor in Step 3.",
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
