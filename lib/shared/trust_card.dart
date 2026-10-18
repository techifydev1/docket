import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:flutter/material.dart';

class TrustCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const TrustCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return DocketCard(
      padding: const .all(14),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          IconTile(icon: icon, size: 36, filled: false, iconSize: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(title, style: textTheme.labelMedium),
                const SizedBox(height: 2),
                Text(description, style: textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
