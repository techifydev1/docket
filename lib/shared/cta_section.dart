import 'package:flutter/material.dart';

class CtaSection extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isEntry;
  final String? helperText;
  final Widget? footer;
  const CtaSection({
    super.key,
    this.onPressed,
    required this.label,
    this.isEntry = true,
    this.helperText,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: isEntry ? 52 : 48,
          child: FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: isEntry ? colors.primary : colors.primaryContainer,
              foregroundColor: colors.onPrimary,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: textTheme.labelLarge?.copyWith(
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  size: isEntry ? 20 : 18,
                  color: colors.onPrimary,
                ),
              ],
            ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 12),
          Text(
            helperText!,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
        if (footer != null) ...[
          const SizedBox(height: 8),
          footer!,
        ],
      ],
    );
  }
}
