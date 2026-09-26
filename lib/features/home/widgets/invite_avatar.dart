import 'package:flutter/material.dart';

class InviteAvatar extends StatelessWidget {
  final VoidCallback onTap;
  const InviteAvatar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Material(
          color: colors.surfaceContainerLow,
          shape: CircleBorder(side: BorderSide(color: colors.outlineVariant)),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 48,
              height: 48,
              child: Icon(Icons.add, size: 20, color: colors.onSurfaceVariant),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "Invite",
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
