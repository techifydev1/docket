import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/features/user/user_provider.dart';
import 'package:docket/shared/docket_avatar.dart';
import 'package:docket/shared/initials.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onInvitations;
  const HomeHeader({super.key, required this.onInvitations});

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    final name = context.watch<UserProvider>().userResponse?.fullName ?? "";
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text("Welcome back", style: textTheme.bodySmall),
              const SizedBox(height: 2),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.5,
                ),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onInvitations,
          tooltip: 'Invitations',
          visualDensity: .compact,
          icon: const Icon(
            Icons.mail_outline,
            size: 22,
            color: VaultTheme.inkMuted,
          ),
        ),
        const SizedBox(width: 4),
        DocketAvatar(initials: initialsOf(name), size: 48),
      ],
    );
  }
}
