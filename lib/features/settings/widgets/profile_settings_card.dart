import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/features/settings/profile.dart';
import 'package:docket/shared/docket_avatar.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:flutter/material.dart';

class ProfileSettingsCard extends StatelessWidget {
  final Profile profile;
  final VoidCallback onEdit;
  const ProfileSettingsCard({
    super.key,
    required this.profile,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return DocketCard(
      padding: const .all(14),
      child: Row(
        children: [
          DocketAvatar(initials: profile.initials),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  profile.name,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: textTheme.labelLarge,
                ),
                const SizedBox(height: 2),
                Text(
                  profile.email,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            tooltip: 'Edit profile',
            visualDensity: .compact,
            icon: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: VaultTheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
