import 'package:docket/core/theme/vault_theme.dart';
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
    final textTheme = VaultTheme.textTheme;
    final background = isEntry ? VaultTheme.primary : VaultTheme.primarySoft;
    final foreground = isEntry ? VaultTheme.onPrimary : VaultTheme.primary;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton(
            onPressed: isLoading ? null : onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: background,
              foregroundColor: foreground,
              disabledBackgroundColor: VaultTheme.surfaceMuted,
              disabledForegroundColor: VaultTheme.inkMuted,
              elevation: isEntry ? 1 : 0,
              shadowColor: VaultTheme.ink.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                borderRadius: .circular(VaultTheme.radiusMd),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: foreground,
                    ),
                  )
                : Row(
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        label,
                        style: textTheme.labelLarge?.copyWith(
                          color: foreground,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 20,
                        color: foreground,
                      ),
                    ],
                  ),
          ),
        ),
        if (helperText != null) ...[
          const SizedBox(height: 12),
          Text(helperText!, textAlign: .center, style: textTheme.bodySmall),
        ],
        if (footer != null) ...[const SizedBox(height: 8), footer!],
      ],
    );
  }
}
