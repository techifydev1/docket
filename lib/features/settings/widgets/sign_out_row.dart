import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/features/auth/auth_gate.dart';
import 'package:docket/features/auth/logout.dart';
import 'package:docket/shared/confirm_dialog.dart';
import 'package:docket/shared/docket_card.dart';
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
    final textTheme = VaultTheme.textTheme;
    return DocketCard(
      padding: const .all(14),
      onTap: () => _signOut(context),
      child: Row(
        children: [
          const Icon(Icons.logout_rounded, size: 20, color: VaultTheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Sign out",
              style: textTheme.labelLarge?.copyWith(color: VaultTheme.error),
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: VaultTheme.inkMuted),
        ],
      ),
    );
  }
}
