import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final bool currentOrPassed;
  const StepIndicator({super.key, required this.currentOrPassed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        borderRadius: .circular(999),
        color: currentOrPassed
            ? VaultTheme.primary
            : VaultTheme.surfaceContainer,
      ),
    );
  }
}
