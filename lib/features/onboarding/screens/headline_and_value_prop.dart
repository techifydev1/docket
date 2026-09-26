import 'package:flutter/material.dart';

class HeadlineAndValueProp extends StatelessWidget {
  const HeadlineAndValueProp();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          "What's your family vault called?",
          style: textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Keep birth certificates, IDs, health records, and deeds encrypted and immediately accessible to everyone in your home.",
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
