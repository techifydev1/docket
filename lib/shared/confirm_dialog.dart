import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final IconData? icon;
  final bool isDestructive;
  final Future<void> Function()? onConfirm;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.icon,
    this.isDestructive = false,
    this.onConfirm,
  });

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = "Continue",
    IconData? icon,
    bool isDestructive = false,
    Future<void> Function()? onConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        icon: icon,
        isDestructive: isDestructive,
        onConfirm: onConfirm,
      ),
    );
    return confirmed ?? false;
  }

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool _isLoading = false;

  Future<void> _confirm() async {
    final onConfirm = widget.onConfirm;
    if (onConfirm == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() => _isLoading = true);
    await onConfirm();
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final accent = widget.isDestructive
        ? colors.error
        : Theme.of(context).primaryColor;
    return PopScope(
      canPop: !_isLoading,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        backgroundColor: colors.surfaceContainerLowest,
        icon: widget.icon == null
            ? null
            : Container(
                width: 48,
                height: 48,
                alignment: .center,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  shape: .circle,
                ),
                child: Icon(widget.icon, size: 24, color: accent),
              ),
        title: Text(
          widget.title,
          textAlign: .center,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: .w600,
            color: colors.onSurface,
          ),
        ),
        content: Text(
          widget.message,
          textAlign: .center,
          style: textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading
                ? null
                : () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: colors.onSurfaceVariant,
              shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              textStyle: textTheme.labelMedium,
            ),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: _isLoading ? null : _confirm,
            style: FilledButton.styleFrom(
              backgroundColor: accent,
              foregroundColor: widget.isDestructive
                  ? colors.onError
                  : colors.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              textStyle: textTheme.labelMedium,
            ),
            child: _isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: widget.isDestructive
                          ? colors.onError
                          : colors.onPrimary,
                    ),
                  )
                : Text(widget.confirmLabel),
          ),
        ],
        actionsAlignment: .center,
        actionsPadding: const .fromLTRB(16, 0, 16, 16),
      ),
    );
  }
}
