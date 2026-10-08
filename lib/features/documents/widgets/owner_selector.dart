import 'package:docket/features/family/family_member.dart';
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
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final isSelf = member.userId == currentUserId;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: .circular(8),
        border: Border.all(
          color: isSelected ? colors.primary : colors.surfaceContainerLow,
          width: 1.5,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: .circular(8),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          borderRadius: .circular(8),
          child: Padding(
            padding: const .symmetric(horizontal: 12, vertical: 10),
            child: Opacity(
              opacity: isEnabled ? 1 : 0.4,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    alignment: .center,
                    decoration: BoxDecoration(
                      color: colors.surfaceContainerHighest,
                      shape: .circle,
                    ),
                    child: Text(
                      initialsOf(member.name),
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          member.name,
                          style: textTheme.labelLarge?.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isSelf ? "You" : _roleLabel,
                          style: textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    isEnabled
                        ? (isSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined)
                        : Icons.lock_outline,
                    size: 20,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : colors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
