import 'dart:async';
import 'dart:ui';

import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

enum ToastVariant { info, success, error }

class Toast {
  const Toast._();

  static OverlayEntry? _entry;

  static void show(
    BuildContext context,
    String message, {
    ToastVariant variant = ToastVariant.info,
    Duration duration = const Duration(seconds: 3),
    double bottomInset = 16,
  }) {
    final overlay = Overlay.of(context, rootOverlay: true);
    dismiss();
    final entry = OverlayEntry(
      builder: (_) => _ToastCard(
        message: message,
        variant: variant,
        duration: duration,
        bottomInset: bottomInset,
        onFinished: dismiss,
      ),
    );
    _entry = entry;
    overlay.insert(entry);
  }

  static void dismiss() {
    _entry?.remove();
    _entry = null;
  }
}

class _ToastCard extends StatefulWidget {
  const _ToastCard({
    required this.message,
    required this.variant,
    required this.duration,
    required this.bottomInset,
    required this.onFinished,
  });

  final String message;
  final ToastVariant variant;
  final Duration duration;
  final double bottomInset;
  final VoidCallback onFinished;

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 180),
        reverseDuration: const Duration(milliseconds: 140),
      )..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) widget.onFinished();
      });
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _timer = Timer(widget.duration, _hide);
  }

  void _hide() {
    if (!mounted) return;
    _controller.reverse();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  IconData get _icon => switch (widget.variant) {
    ToastVariant.info => Icons.info_outline,
    ToastVariant.success => Icons.check_circle_outline,
    ToastVariant.error => Icons.error_outline,
  };

  Color _iconColor(ColorScheme colors) => switch (widget.variant) {
    ToastVariant.info => colors.onSurfaceVariant,
    ToastVariant.success => Theme.of(context).primaryColor,
    ToastVariant.error => colors.error,
  };

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Positioned(
      left: 16,
      right: 16,
      bottom: MediaQuery.paddingOf(context).bottom + widget.bottomInset,
      child: FadeTransition(
        opacity: _animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(_animation),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _hide,
                  borderRadius: .circular(VaultTheme.radiusMd),
                  child: ClipRRect(
                    borderRadius: .circular(VaultTheme.radiusMd),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        padding: const .symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: colors.surface.withValues(alpha: 0.82),
                          borderRadius: .circular(VaultTheme.radiusMd),
                          border: .all(color: VaultTheme.hairline),
                          boxShadow: VaultTheme.e2,
                        ),
                        child: Row(
                          mainAxisSize: .min,
                          children: [
                            Icon(_icon, size: 18, color: _iconColor(colors)),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                widget.message,
                                style: textTheme.labelMedium?.copyWith(
                                  color: colors.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
