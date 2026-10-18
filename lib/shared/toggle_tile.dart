import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:flutter/material.dart';

class ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool enabled;
  const ToggleTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return DocketCard(
      padding: const .symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          IconTile(
            icon: icon,
            size: 38,
            filled: false,
            iconSize: 20,
            color: enabled ? null : VaultTheme.surfaceContainer,
            iconColor: enabled ? null : VaultTheme.inkMuted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: textTheme.labelLarge?.copyWith(
                    color: enabled ? VaultTheme.ink : VaultTheme.inkMuted,
                  ),
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
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeThumbColor: VaultTheme.onPrimary,
            activeTrackColor: VaultTheme.primary,
            inactiveThumbColor: VaultTheme.surface,
            inactiveTrackColor: VaultTheme.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}
