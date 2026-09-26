import 'package:docket/features/documents/vault_member.dart';
import 'package:flutter/material.dart';

class OwnerSelector extends StatelessWidget {
  final String? selectedName;
  final ValueChanged<VaultMember> onChanged;
  const OwnerSelector({
    super.key,
    required this.selectedName,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final member in vaultMembers)
          Padding(
            padding: const .only(bottom: 8),
            child: _MemberRow(
              member: member,
              isSelected: member.name == selectedName,
              onTap: () => onChanged(member),
            ),
          ),
      ],
    );
  }
}

class _MemberRow extends StatelessWidget {
  final VaultMember member;
  final bool isSelected;
  final VoidCallback onTap;
  const _MemberRow({
    required this.member,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Material(
      color: isSelected ? colors.primaryContainer : colors.surfaceContainerLow,
      borderRadius: .circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(8),
        child: Padding(
          padding: const .symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: .center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.primary
                      : colors.surfaceContainerHighest,
                  shape: .circle,
                ),
                child: Text(
                  member.initials,
                  style: textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? colors.onPrimary
                        : colors.onSurfaceVariant,
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
                      member.relation,
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.circle_outlined,
                size: 20,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : colors.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
