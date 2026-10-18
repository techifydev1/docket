import 'dart:ui';

import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class GlassNav extends StatelessWidget {
  const GlassNav({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  static const List<(IconData, String)> _items = [
    (Icons.home_rounded, "Home"),
    (Icons.folder_rounded, "Documents"),
    (Icons.settings_rounded, "Settings"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const .fromLTRB(20, 0, 20, 12),
        child: SizedBox(
          height: 64,
          child: ClipRRect(
            borderRadius: .circular(999),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const .symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: VaultTheme.surface.withValues(alpha: 0.72),
                  borderRadius: .circular(999),
                  border: .all(
                    color: VaultTheme.surface.withValues(alpha: 0.6),
                  ),
                  boxShadow: VaultTheme.e2,
                ),
                child: Row(
                  mainAxisAlignment: .spaceEvenly,
                  children: [
                    for (var i = 0; i < _items.length; i++)
                      _NavItem(
                        icon: _items[i].$1,
                        label: _items[i].$2,
                        selected: i == currentIndex,
                        onTap: () => onSelect(i),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: .opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const .symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? VaultTheme.primary : Colors.transparent,
          borderRadius: .circular(999),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? VaultTheme.onPrimary : VaultTheme.inkMuted,
            ),
            if (selected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: VaultTheme.textTheme.labelMedium?.copyWith(
                  color: VaultTheme.onPrimary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
