import 'package:flutter/material.dart';

class InviteAvatar extends StatelessWidget {
  const InviteAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surfaceContainerLow,
            shape: BoxShape.circle,
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Icon(Icons.add, size: 20, color: colors.onSurfaceVariant),
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
