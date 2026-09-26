import 'package:docket/shared/toggle_tile.dart';
import 'package:flutter/material.dart';

class BiometricToggle extends StatefulWidget {
  const BiometricToggle({super.key});

  @override
  State<BiometricToggle> createState() => _BiometricToggleState();
}

class _BiometricToggleState extends State<BiometricToggle> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return ToggleTile(
      icon: Icons.fingerprint,
      title: "Biometric / Face ID Lock",
      subtitle: "Require biometric passkey to view vital files",
      value: _enabled,
      onChanged: (value) => setState(() => _enabled = value),
    );
  }
}
