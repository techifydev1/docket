import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:docket/shared/link_button.dart';
import 'package:flutter/material.dart';

class StatusMessage extends StatelessWidget {
  const StatusMessage({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.onRetry,
    this.retryLabel = "Try again",
  });

  final IconData icon;
  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return Center(
      child: Padding(
        padding: const .symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: .min,
          children: [
            IconTile(icon: icon, size: 56, iconSize: 26),
            const SizedBox(height: 16),
            Text(title, textAlign: .center, style: textTheme.titleMedium),
            if (message != null) ...[
              const SizedBox(height: 6),
              Text(message!, textAlign: .center, style: textTheme.bodySmall),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              LinkButton(label: retryLabel, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
