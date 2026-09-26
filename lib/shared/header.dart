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
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 28,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          title,
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
        SizedBox(height: titleSubtitleGap),
        Text(
          subtitle,
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
