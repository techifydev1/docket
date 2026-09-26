import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  const SectionHeader({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
        if (action != null)
          Text(
            action!,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
      ],
    );
  }
}
