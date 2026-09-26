import 'package:flutter/material.dart';

class DocketTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextInputType? keyboardType;
  final bool isPassword;
  final TextEditingController? controller;
  final VoidCallback? onChanged;
  const DocketTextField({
    this.label = "Full Legal Name",
    this.placeholder = "Your full legal name",
    this.keyboardType,
    this.isPassword = false,
    this.controller,
    this.onChanged,
  });

  @override
  State<DocketTextField> createState() => _DocketTextFieldState();
}

class _DocketTextFieldState extends State<DocketTextField> {
  late bool _obscured = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final keyboardType =
        widget.keyboardType ??
        (widget.isPassword ? TextInputType.visiblePassword : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textTheme.labelMedium?.copyWith(color: colors.onSurface),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: widget.controller,
          keyboardType: keyboardType,
          obscureText: _obscured,
          textCapitalization: widget.isPassword
              ? TextCapitalization.none
              : (keyboardType == null
                    ? TextCapitalization.sentences
                    : TextCapitalization.none),
          autocorrect: !widget.isPassword && keyboardType == null,
          onChanged: (_) => widget.onChanged?.call(),
          style: textTheme.bodyMedium?.copyWith(color: colors.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.surfaceContainerLow,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8),
            ),
            hintText: widget.placeholder,
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () => setState(() => _obscured = !_obscured),
                    icon: Icon(
                      _obscured ? Icons.visibility : Icons.visibility_off,
                    ),
                    color: colors.onSurfaceVariant,
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
