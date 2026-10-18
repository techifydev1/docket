import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const SignOutButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.logout_rounded, size: 16),
        label: const Text("Sign out"),
        style: TextButton.styleFrom(
          foregroundColor: VaultTheme.error,
          padding: const .symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(0, 0),
          tapTargetSize: .shrinkWrap,
          textStyle: VaultTheme.textTheme.labelMedium,
        ),
      ),
    );
  }
}
