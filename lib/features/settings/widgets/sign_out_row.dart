import 'package:docket/features/auth/auth_gate.dart';
import 'package:docket/features/auth/logout.dart';
import 'package:docket/shared/confirm_dialog.dart';
import 'package:flutter/material.dart';

class SignOutRow extends StatelessWidget {
  const SignOutRow({super.key});

  Future<void> _signOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    final confirmed = await ConfirmDialog.show(
      context,
      title: "Sign out?",
      message:
          "Your vaults stay safe, but you'll need your email and password to get back in.",
      confirmLabel: "Sign out",
      icon: Icons.logout,
      isDestructive: true,
      onConfirm: () => logout(context),
    );
    if (!confirmed) return;
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthGate()),
      (route) => false,
    );
  }

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
        onTap: () => _signOut(context),
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
