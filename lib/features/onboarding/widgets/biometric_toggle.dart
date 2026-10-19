import 'package:docket/shared/toggle_tile.dart';
import 'package:flutter/material.dart';

class BiometricToggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const BiometricToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ToggleTile(
      icon: Icons.fingerprint,
      title: "Biometric / Face ID Lock",
      subtitle: "Require biometric passkey to view vital files",
      value: value,
      onChanged: onChanged,
    );
  }
}
