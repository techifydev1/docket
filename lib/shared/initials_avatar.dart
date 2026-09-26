import 'package:flutter/material.dart';

class InitialsAvatar extends StatelessWidget {
  final String initials;
  final double size;
  const InitialsAvatar({super.key, required this.initials, this.size = 48});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      alignment: .center,
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        shape: .circle,
        border: Border.all(
          color: colors.primaryContainer.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Text(
        initials,
        style: textTheme.labelLarge?.copyWith(
          fontWeight: .w700,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
