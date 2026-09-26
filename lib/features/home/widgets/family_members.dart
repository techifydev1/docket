import 'package:flutter/material.dart';

import 'package:docket/features/home/widgets/invite_avatar.dart';
import 'package:docket/features/home/widgets/member_avatar.dart';

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
