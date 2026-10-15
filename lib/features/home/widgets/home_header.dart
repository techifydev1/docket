import 'package:docket/features/user/user_provider.dart';
import 'package:docket/shared/initials.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onInvitations;
  const HomeHeader({super.key, required this.onInvitations});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final name = context.watch<UserProvider>().userResponse?.fullName ?? "";
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                "Welcome back",
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.sizeOf(context).width * 0.5,
                ),
                child: Text(
                  name,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: .w700,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onInvitations,
          tooltip: 'Invitations',
          visualDensity: .compact,
          icon: Icon(
            Icons.mail_outline,
            size: 22,
            color: colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 48,
          height: 48,
          alignment: .center,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            shape: .circle,
            border: Border.all(
              color: colors.primaryContainer.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Text(
            initialsOf(name),
            style: textTheme.labelLarge?.copyWith(
              fontWeight: .w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
