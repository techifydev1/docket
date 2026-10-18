import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final double titleSubtitleGap;
  const Header({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
    this.titleSubtitleGap = 8,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        if (icon != null) ...[
          IconTile(icon: icon!, size: 56),
          const SizedBox(height: 16),
        ],
        Text(title, style: textTheme.headlineLarge),
        SizedBox(height: titleSubtitleGap),
        Text(subtitle, style: textTheme.bodyMedium),
      ],
    );
  }
}
