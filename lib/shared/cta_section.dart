import 'package:flutter/material.dart';

class CtaSection extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isEntry;
  final bool isLoading;
  final String? helperText;
  final Widget? footer;
  const CtaSection({
    super.key,
    this.onPressed,
    required this.label,
    this.isEntry = true,
    this.isLoading = false,
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
            onPressed: isLoading ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: isEntry
                  ? colors.primary
                  : colors.primaryContainer,
              foregroundColor: colors.onPrimary,
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: .circular(8)),
            ),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.onPrimary,
                    ),
                  )
                : Row(
                    mainAxisAlignment: .center,
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
            textAlign: .center,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
        if (footer != null) ...[const SizedBox(height: 8), footer!],
      ],
    );
  }
}
