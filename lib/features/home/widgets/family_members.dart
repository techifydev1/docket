import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/home/widgets/invite_avatar.dart';
import 'package:docket/features/home/widgets/member_avatar.dart';
import 'package:docket/features/user/user_provider.dart';
import 'package:docket/shared/initials.dart';

class FamilyMembers extends StatelessWidget {
  final VoidCallback onInvite;
  const FamilyMembers({super.key, required this.onInvite});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().userResponse;
    final members = context
        .watch<FamilyProvider>()
        .selectedFamily
        ?.familyMembers;
    if (members == null || members.isEmpty) {
      return Align(
        alignment: .centerLeft,
        child: InviteAvatar(onTap: onInvite),
      );
    }
    return SingleChildScrollView(
      scrollDirection: .horizontal,
      child: Row(
        children: [
          for (final member in members)
            Padding(
              padding: const .only(right: 16),
              child: MemberAvatar(
                initials: initialsOf(member.name),
                name: member.name,
                isYou: member.userId == user?.id,
              ),
            ),
          InviteAvatar(onTap: onInvite),
        ],
      ),
    );
  }
}
