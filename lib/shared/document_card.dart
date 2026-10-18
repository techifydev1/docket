import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:docket/shared/pill_chip.dart';
import 'package:flutter/material.dart';

class DocumentCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const DocumentCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return DocketCard(
      padding: const .all(14),
      onTap: onTap,
      child: Row(
        children: [
          IconTile(icon: icon, size: 40, filled: false, iconSize: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: textTheme.labelLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const PillChip(icon: Icons.lock_outline, label: "Encrypted"),
        ],
      ),
    );
  }
}
