import 'package:flutter/material.dart';

class MemberAvatar extends StatelessWidget {
  final String initials;
  final String name;
  final bool isYou;
  const MemberAvatar({
    super.key,
    required this.initials,
    required this.name,
    this.isYou = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: isYou
                ? Border.all(
                    color: colors.primaryContainer.withValues(alpha: 0.4),
                    width: 2,
                  )
                : null,
          ),
          child: Text(
            initials,
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
