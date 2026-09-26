import 'package:flutter/material.dart';

import 'package:docket/features/home/widgets/invite_avatar.dart';
import 'package:docket/features/home/widgets/member_avatar.dart';

class FamilyMembers extends StatelessWidget {
  final VoidCallback onInvite;
  const FamilyMembers({super.key, required this.onInvite});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const MemberAvatar(initials: "EV", name: "You", isYou: true),
        const SizedBox(width: 16),
        const MemberAvatar(initials: "JV", name: "James"),
        const SizedBox(width: 16),
        const MemberAvatar(initials: "AV", name: "Ada"),
        const SizedBox(width: 16),
        InviteAvatar(onTap: onInvite),
      ],
    );
  }
}
