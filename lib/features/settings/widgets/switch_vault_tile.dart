import 'package:flutter/material.dart';

class SwitchVaultTile extends StatelessWidget {
  final VoidCallback onTap;
  const SwitchVaultTile({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: .circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: .circular(8),
        clipBehavior: .antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const .all(12),
            child: Row(
              children: [
                Icon(
                  Icons.swap_horiz,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        "Switch vault",
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: textTheme.labelMedium?.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      Text(
                        "Open a different family vault",
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: colors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
