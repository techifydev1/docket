import 'package:docket/features/family/family_response.dart';
import 'package:docket/shared/initials.dart';
import 'package:docket/shared/initials_avatar.dart';
import 'package:flutter/material.dart';

class FamilyCard extends StatelessWidget {
  final FamilyResponse family;
  final bool isSelected;
  final VoidCallback onTap;
  const FamilyCard({
    super.key,
    required this.family,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: .circular(12),
        border: Border.all(
          color: isSelected ? colors.primary : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: .circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const .all(16),
            child: Row(
              children: [
                _FamilyAvatar(family: family),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        family.name,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: textTheme.labelLarge?.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _FamilySubtitle(family: family),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
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
      ),
    );
  }
}

class _FamilyAvatar extends StatelessWidget {
  final FamilyResponse family;
  const _FamilyAvatar({required this.family});

  @override
  Widget build(BuildContext context) {
    final pic = family.pic;
    if (pic == null || pic.isEmpty) {
      return InitialsAvatar(initials: initialsOf(family.name));
    }
    return ClipOval(
      child: Image.network(
        pic,
        width: 48,
        height: 48,
        fit: .cover,
        errorBuilder: (_, _, _) =>
            InitialsAvatar(initials: initialsOf(family.name)),
      ),
    );
  }
}

class _FamilySubtitle extends StatelessWidget {
  final FamilyResponse family;
  const _FamilySubtitle({required this.family});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final style = textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant);
    final created = DateTime.tryParse(family.createdAt)?.toLocal();
    final createdLabel = created == null
        ? null
        : MaterialLocalizations.of(context).formatMediumDate(created);
    return Row(
      children: [
        Text(
          family.memberCount == 1
              ? "1 member"
              : "${family.memberCount} members",
          style: style,
        ),
        if (createdLabel != null) ...[
          Text("  ·  ", style: style),
          Flexible(child: Text("Created $createdLabel", style: style)),
        ],
      ],
    );
  }
}
