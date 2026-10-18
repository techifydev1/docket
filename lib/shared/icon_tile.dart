import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    this.size = 44,
    this.filled = true,
    this.shape = .rectangle,
    this.iconSize,
    this.color,
    this.iconColor,
  });

  final IconData icon;
  final double size;
  final bool filled;
  final BoxShape shape;
  final double? iconSize;
  final Color? color;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? (filled ? VaultTheme.primary : VaultTheme.surfaceMuted);
    final fg =
        iconColor ?? (filled ? VaultTheme.onPrimary : VaultTheme.primary);
    return Container(
      width: size,
      height: size,
      alignment: .center,
      decoration: BoxDecoration(
        color: bg,
        shape: shape,
        borderRadius: shape == .rectangle
            ? BorderRadius.circular(VaultTheme.radiusMd)
            : null,
        boxShadow: filled ? VaultTheme.e1 : null,
      ),
      child: Icon(icon, size: iconSize ?? size * 0.45, color: fg),
    );
  }
}
