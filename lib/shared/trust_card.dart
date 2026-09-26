import 'package:flutter/material.dart';

class TrustCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final double cardRadius;
  final Color? iconBgColor;
  final Color? iconColor;
  final BoxShape iconShape;
  const TrustCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.cardRadius = 12,
    this.iconBgColor,
    this.iconColor,
    this.iconShape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(cardRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: iconBgColor ?? colors.surfaceContainerHighest,
                borderRadius: iconShape == BoxShape.rectangle
                    ? BorderRadius.circular(8)
                    : null,
                shape: iconShape,
              ),
            child: Icon(
              icon,
              size: 18,
              color: iconColor ?? Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
