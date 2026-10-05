import 'package:flutter/material.dart';

class SignOutButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const SignOutButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.logout, size: 16),
        label: const Text("Sign out"),
        style: TextButton.styleFrom(
          foregroundColor: colors.error,
          padding: const .symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(0, 0),
          tapTargetSize: .shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: .circular(8)),
          textStyle: textTheme.labelMedium,
        ),
      ),
    );
  }
}