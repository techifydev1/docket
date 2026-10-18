import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  final bool enabled;
  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(
            color: enabled ? VaultTheme.ink : VaultTheme.inkMuted,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            behavior: .opaque,
            child: Text(
              action!,
              style: textTheme.labelMedium?.copyWith(
                color: enabled ? VaultTheme.primary : VaultTheme.inkMuted,
              ),
            ),
          ),
      ],
    );
  }
}
