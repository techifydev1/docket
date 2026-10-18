import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/docket_avatar.dart';
import 'package:flutter/material.dart';

class MemberAvatar extends StatelessWidget {
  final String initials;
  final String name;
  final String relation;
  final bool isYou;
  const MemberAvatar({
    super.key,
    required this.initials,
    required this.name,
    required this.relation,
    this.isYou = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return SizedBox(
      width: 72,
      child: Column(
        children: [
          DocketAvatar(initials: initials, size: 48, soft: !isYou),
          const SizedBox(height: 6),
          Text(
            name,
            maxLines: 1,
            overflow: .ellipsis,
            textAlign: .center,
            style: textTheme.labelMedium,
          ),
          if (relation.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              relation,
              maxLines: 1,
              overflow: .ellipsis,
              textAlign: .center,
              style: textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
