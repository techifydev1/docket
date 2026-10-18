import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 64,
          height: 64,
          alignment: .center,
          decoration: BoxDecoration(
            color: VaultTheme.primary,
            shape: .circle,
            border: .all(color: VaultTheme.surface, width: 2),
            boxShadow: VaultTheme.e1,
          ),
          child: Text(
            "EV",
            style: VaultTheme.textTheme.labelLarge?.copyWith(
              fontSize: 20,
              color: VaultTheme.onPrimary,
            ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: VaultTheme.surface,
              shape: .circle,
              border: .all(color: VaultTheme.hairline),
              boxShadow: VaultTheme.e1,
            ),
            child: const Icon(
              Icons.photo_camera_outlined,
              size: 15,
              color: VaultTheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
