import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 64,
          height: 64,
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
            "EV",
            style: textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Positioned(
          right: -4,
          bottom: -4,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: .circle,
            ),
            child: Icon(Icons.photo_camera, size: 16, color: colors.onPrimary),
          ),
        ),
      ],
    );
  }
}
