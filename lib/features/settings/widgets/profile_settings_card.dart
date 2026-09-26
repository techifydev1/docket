import 'package:docket/features/settings/profile.dart';
import 'package:docket/shared/initials_avatar.dart';
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
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: .circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          InitialsAvatar(initials: profile.initials),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  profile.name,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.email,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            tooltip: 'Edit profile',
            visualDensity: .compact,
            icon: Icon(
              Icons.edit_outlined,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
