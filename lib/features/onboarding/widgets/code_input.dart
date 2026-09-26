import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class CodeInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const CodeInput({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final defaultPinTheme = PinTheme(
      width: 44,
      height: 52,
      textStyle: textTheme.headlineMedium?.copyWith(
        fontWeight: .w700,
        color: colors.onSurface,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: .circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: colors.primaryContainer, width: 1.5),
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
