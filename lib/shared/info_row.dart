import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return Padding(
      padding: const .symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(label, style: textTheme.bodySmall),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: .ellipsis,
              textAlign: .end,
              style: textTheme.labelLarge,
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}
