import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class HeadlineAndValueProp extends StatelessWidget {
  const HeadlineAndValueProp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "What's your family vault called?",
          style: textTheme.headlineLarge,
        ),
        const SizedBox(height: 8),
        Text(
          "Keep birth certificates, IDs, health records, and deeds encrypted and immediately accessible to everyone in your home.",
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
