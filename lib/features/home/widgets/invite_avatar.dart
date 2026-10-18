import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class InviteAvatar extends StatelessWidget {
  final VoidCallback onTap;
  const InviteAvatar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return Column(
      children: [
        Material(
          color: VaultTheme.surfaceMuted,
          shape: CircleBorder(
            side: BorderSide(
              color: VaultTheme.primary.withValues(alpha: 0.35),
              width: 1.5,
            ),
          ),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: const SizedBox(
              width: 48,
              height: 48,
              child: Icon(Icons.add, size: 22, color: VaultTheme.primary),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text("Invite", style: textTheme.labelMedium),
      ],
    );
  }
}
