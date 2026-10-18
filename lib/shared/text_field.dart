import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';

class DocketTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextInputType? keyboardType;
  final bool isPassword;
  final TextEditingController? controller;
  final VoidCallback? onChanged;
  final VoidCallback? onSubmitted;
  final Widget? suffixIcon;
  final bool enabled;
  const DocketTextField({
    super.key,
    this.label = "Full Legal Name",
    this.placeholder = "Your full legal name",
    this.keyboardType,
    this.isPassword = false,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.suffixIcon,
    this.enabled = true,
  });

  @override
  State<DocketTextField> createState() => _DocketTextFieldState();
}

class _DocketTextFieldState extends State<DocketTextField> {
  late bool _obscured = widget.isPassword;

  OutlineInputBorder _border(Color color, [double width = 0]) =>
      OutlineInputBorder(
        borderRadius: .circular(VaultTheme.radiusMd),
        borderSide: BorderSide(color: color, width: width),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    final keyboardType =
        widget.keyboardType ??
        (widget.isPassword ? TextInputType.visiblePassword : null);
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(widget.label.toUpperCase(), style: textTheme.labelSmall),
        const SizedBox(height: 6),
        TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: keyboardType,
          obscureText: _obscured,
          textCapitalization: widget.isPassword
              ? .none
              : (keyboardType == null ? .sentences : .none),
          autocorrect: !widget.isPassword && keyboardType == null,
          onChanged: (_) => widget.onChanged?.call(),
          onSubmitted: widget.onSubmitted == null
              ? null
              : (_) => widget.onSubmitted!(),
          textInputAction: widget.onSubmitted == null
              ? null
              : TextInputAction.done,
          style: textTheme.bodyLarge?.copyWith(
            color: widget.enabled
                ? VaultTheme.ink
                : VaultTheme.inkMuted.withValues(alpha: 0.6),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.enabled
                ? VaultTheme.surfaceMuted
                : VaultTheme.surfaceMuted.withValues(alpha: 0.6),
            border: _border(Colors.transparent),
            enabledBorder: _border(Colors.transparent),
            focusedBorder: _border(VaultTheme.primary, 1.5),
            hintText: widget.placeholder,
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: VaultTheme.inkMuted.withValues(alpha: 0.6),
            ),
            contentPadding: const .symmetric(horizontal: 16, vertical: 16),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () => setState(() => _obscured = !_obscured),
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                    ),
                    color: VaultTheme.inkMuted,
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
