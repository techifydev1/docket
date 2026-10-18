import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/features/family/family_member.dart';
import 'package:docket/shared/docket_avatar.dart';
import 'package:docket/shared/initials.dart';
import 'package:flutter/material.dart';

class OwnerSelector extends StatelessWidget {
  final List<FamilyMember> members;
  final String currentUserId;
  final String? selectedId;
  final bool canUploadForOthers;
  final ValueChanged<FamilyMember> onChanged;
  const OwnerSelector({
    super.key,
    required this.members,
    required this.currentUserId,
    required this.selectedId,
    required this.canUploadForOthers,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final member in members)
          Padding(
            padding: const .only(bottom: 8),
            child: _MemberRow(
              member: member,
              currentUserId: currentUserId,
              isSelected: member.userId == selectedId,
              isEnabled: canUploadForOthers || member.userId == currentUserId,
              onTap: () => onChanged(member),
            ),
          ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  final FamilyMember member;
  final String currentUserId;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;
  const _MemberRow({
    required this.member,
    required this.currentUserId,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
  });

  String get _roleLabel {
    final role = member.role;
    return role[0] + role.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    final isSelf = member.userId == currentUserId;
    return Opacity(
      opacity: isEnabled ? 1 : 0.4,
      child: Material(
        type: MaterialType.transparency,
        borderRadius: .circular(VaultTheme.radiusMd),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: .circular(VaultTheme.radiusMd),
          child: Container(
            padding: const .symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? VaultTheme.primarySoft
                  : VaultTheme.surfaceMuted,
              borderRadius: .circular(VaultTheme.radiusMd),
              border: Border.all(
                color: isSelected
                    ? VaultTheme.primary.withValues(alpha: 0.3)
                    : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                DocketAvatar(
                  initials: initialsOf(member.name),
                  size: 36,
                  soft: !isSelected,
                  ring: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        member.name,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: textTheme.labelLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isSelf ? "You" : _roleLabel,
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  isEnabled
                      ? (isSelected
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked)
                      : Icons.lock_outline,
                  size: 20,
                  color: isSelected ? VaultTheme.primary : VaultTheme.inkMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
