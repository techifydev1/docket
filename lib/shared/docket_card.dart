import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class DocketCard extends StatelessWidget {
  const DocketCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(VaultTheme.pad),
    this.color,
    this.onTap,
    this.borderRadius = VaultTheme.radiusLg,
    this.elevated = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;
  final double borderRadius;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);
    final content = Padding(padding: padding, child: child);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? VaultTheme.surface,
        borderRadius: radius,
        boxShadow: elevated ? VaultTheme.e1 : null,
      ),
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: radius,
                child: content,
              ),
            ),
    );
  }
}
