import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "Settings",
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: .w700,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          "Manage your profile, security and vault details.",
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
