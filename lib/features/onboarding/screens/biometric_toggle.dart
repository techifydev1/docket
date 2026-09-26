import 'package:flutter/material.dart';

class BiometricToggle extends StatefulWidget {
  const BiometricToggle();

  @override
  State<BiometricToggle> createState() => _BiometricToggleState();
}

class _BiometricToggleState extends State<BiometricToggle> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.fingerprint,
            size: 20,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "Biometric / Face ID Lock",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                Text(
                  "Require biometric passkey to view vital files",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Switch(
            value: _enabled,
            onChanged: (value) => setState(() => _enabled = value),
            activeThumbColor: colors.onPrimary,
            activeTrackColor: colors.primaryContainer,
            inactiveThumbColor: colors.onSurfaceVariant,
            inactiveTrackColor: colors.surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}
