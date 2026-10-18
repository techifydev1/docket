import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class Stat extends StatelessWidget {
  final String value;
  final String label;
  const Stat({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: VaultTheme.stat),
        const SizedBox(height: 2),
        Text(label, style: VaultTheme.overline),
      ],
    );
  }
}
