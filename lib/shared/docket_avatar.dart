import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class DocketAvatar extends StatelessWidget {
  const DocketAvatar({
    super.key,
    required this.initials,
    this.size = 48,
    this.imageUrl,
    this.soft = false,
    this.ring = true,
  });

  final String initials;
  final double size;
  final String? imageUrl;
  final bool soft;
  final bool ring;

  @override
  Widget build(BuildContext context) {
    final bg = soft ? VaultTheme.primarySoft : VaultTheme.primary;
    final fg = soft ? VaultTheme.primary : VaultTheme.onPrimary;
    final labelStyle = VaultTheme.textTheme.labelMedium?.copyWith(
      fontSize: size * 0.3,
      color: fg,
    );
    return Container(
      width: size,
      height: size,
      alignment: .center,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: bg,
        shape: .circle,
        border: ring ? .all(color: VaultTheme.surface, width: 2) : null,
        boxShadow: ring ? VaultTheme.e1 : null,
      ),
      child: imageUrl == null
          ? Text(initials, style: labelStyle)
          : Image.network(
              imageUrl!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Text(initials, style: labelStyle),
            ),
    );
  }
}
