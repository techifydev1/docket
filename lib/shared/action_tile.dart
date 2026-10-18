import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:flutter/material.dart';

class ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const ActionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return DocketCard(
      padding: const .symmetric(horizontal: 14, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          IconTile(icon: icon, size: 38, filled: false, iconSize: 20),
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
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: VaultTheme.inkMuted,
          ),
        ],
      ),
    );
  }
}
