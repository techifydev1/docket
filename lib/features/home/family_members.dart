import 'package:flutter/material.dart';

import 'invite_avatar.dart';
import 'member_avatar.dart';

class FamilyMembers extends StatelessWidget {
  const FamilyMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        MemberAvatar(initials: "EV", name: "You", isYou: true),
        SizedBox(width: 16),
        MemberAvatar(initials: "JV", name: "James"),
        SizedBox(width: 16),
        MemberAvatar(initials: "AV", name: "Ada"),
        SizedBox(width: 16),
        InviteAvatar(),
      ],
    );
  }
}
