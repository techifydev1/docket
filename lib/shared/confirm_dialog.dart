import 'dart:ui';

import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/icon_tile.dart';
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
    final accent = widget.isDestructive ? colors.error : colors.primary;
    final onAccent = widget.isDestructive ? colors.onError : colors.onPrimary;
    return PopScope(
      canPop: !_isLoading,
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const .symmetric(horizontal: 24, vertical: 24),
        child: ClipRRect(
          borderRadius: .circular(VaultTheme.radiusXl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const .fromLTRB(24, 24, 24, 16),
              decoration: BoxDecoration(
                color: VaultTheme.surface.withValues(alpha: 0.9),
                borderRadius: .circular(VaultTheme.radiusXl),
                border: .all(color: VaultTheme.hairline),
                boxShadow: VaultTheme.e2,
              ),
              child: Column(
                mainAxisSize: .min,
                children: [
                  if (widget.icon != null) ...[
                    IconTile(
                      icon: widget.icon!,
                      size: 56,
                      filled: true,
                      color: accent,
                      iconColor: onAccent,
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    widget.title,
                    textAlign: .center,
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.message,
                    textAlign: .center,
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () => Navigator.of(context).pop(false),
                          child: const Text("Cancel"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _isLoading ? null : _confirm,
                          style: FilledButton.styleFrom(
                            backgroundColor: accent,
                            foregroundColor: onAccent,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: onAccent,
                                  ),
                                )
                              : Text(widget.confirmLabel),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
