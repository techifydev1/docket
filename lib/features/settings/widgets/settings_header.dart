import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text("Settings", style: textTheme.headlineLarge),
        const SizedBox(height: 2),
        Text(
          "Manage your profile, security and vault details.",
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
