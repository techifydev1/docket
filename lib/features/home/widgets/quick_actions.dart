import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onUpload;
  final VoidCallback onInvite;
  const QuickActions({
    super.key,
    required this.onUpload,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: onUpload,
            style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
            child: const Row(
              mainAxisAlignment: .center,
              children: [
                Icon(Icons.upload_file_rounded, size: 18),
                SizedBox(width: 8),
                Text("Upload"),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: onInvite,
            style: FilledButton.styleFrom(
              backgroundColor: VaultTheme.primarySoft,
              foregroundColor: VaultTheme.primary,
              elevation: 0,
              minimumSize: const Size(0, 48),
            ),
            child: const Row(
              mainAxisAlignment: .center,
              children: [
                Icon(Icons.person_add_alt_1_outlined, size: 18),
                SizedBox(width: 8),
                Text("Invite"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
