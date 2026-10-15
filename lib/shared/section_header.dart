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
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: .w700,
            color: enabled ? colors.onSurface : colors.onSurfaceVariant,
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            child: Text(
              action!,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: .w700,
                color: enabled
                    ? Theme.of(context).primaryColor
                    : colors.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
