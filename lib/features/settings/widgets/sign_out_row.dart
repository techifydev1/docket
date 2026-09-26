import 'package:docket/features/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

class SignOutRow extends StatelessWidget {
  const SignOutRow({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: .circular(12),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        ),
        borderRadius: .circular(12),
        child: Padding(
          padding: const .all(14),
          child: Row(
            children: [
              Icon(Icons.logout, size: 20, color: colors.error),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Sign out",
                  style: textTheme.labelLarge?.copyWith(color: colors.error),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
