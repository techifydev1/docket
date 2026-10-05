import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final IconData? icon;
  final bool isDestructive;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.icon,
    this.isDestructive = false,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = "Continue",
    IconData? icon,
    bool isDestructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        icon: icon,
        isDestructive: isDestructive,
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final accent = isDestructive
        ? colors.error
        : Theme.of(context).primaryColor;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      backgroundColor: colors.surfaceContainerLowest,
      icon: icon == null
          ? null
          : Container(
              width: 48,
              height: 48,
              alignment: .center,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                shape: .circle,
              ),
              child: Icon(icon, size: 24, color: accent),
            ),
      title: Text(
        title,
        textAlign: .center,
        style: textTheme.bodyMedium?.copyWith(
          fontWeight: .w600,
          color: colors.onSurface,
        ),
      ),
      content: Text(
        message,
        textAlign: .center,
        style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            foregroundColor: colors.onSurfaceVariant,
            shape: RoundedRectangleBorder(borderRadius: .circular(8)),
            textStyle: textTheme.labelMedium,
          ),
          child: const Text("Cancel"),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: isDestructive ? colors.onError : colors.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: .circular(8)),
            textStyle: textTheme.labelMedium,
          ),
          child: Text(confirmLabel),
        ),
      ],
      actionsAlignment: .center,
      actionsPadding: const .fromLTRB(16, 0, 16, 16),
    );
  }
}
