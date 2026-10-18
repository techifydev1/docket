import 'package:docket/core/theme/vault_theme.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class CodeInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const CodeInput({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;

    final defaultPinTheme = PinTheme(
      width: 44,
      height: 52,
      textStyle: textTheme.headlineMedium,
      decoration: BoxDecoration(
        color: VaultTheme.surfaceMuted,
        borderRadius: .circular(VaultTheme.radiusMd),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: VaultTheme.primary, width: 1.5),
    );

    return Pinput(
      length: 6,
      closeKeyboardWhenCompleted: true,
      keyboardType: TextInputType.number,
      mainAxisAlignment: .spaceBetween,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: focusedPinTheme,
      showCursor: true,
      onChanged: (pin) => onChanged(pin),
    );
  }
}
