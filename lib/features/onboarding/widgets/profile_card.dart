import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/text_field.dart';
import 'package:flutter/material.dart';

import 'package:docket/features/onboarding/widgets/biometric_toggle.dart';

class ProfileCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final bool biometricsEnabled;
  final ValueChanged<bool> onBiometricsChanged;
  final VoidCallback onChanged;
  const ProfileCard({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.biometricsEnabled,
    required this.onBiometricsChanged,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DocketCard(
      child: Column(
        children: [
          DocketTextField(
            label: "Full Legal Name",
            placeholder: "Your full legal name",
            controller: nameController,
            onChanged: onChanged,
          ),
          const SizedBox(height: 16),
          DocketTextField(
            label: "Email Address",
            placeholder: "you@example.com",
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            onChanged: onChanged,
          ),
          const SizedBox(height: 16),
          DocketTextField(
            label: "Emergency Contact Phone",
            placeholder: "+1 (555) 234-5678",
            keyboardType: TextInputType.phone,
            controller: phoneController,
            onChanged: onChanged,
          ),
          const SizedBox(height: 16),
          DocketTextField(
            label: "Password",
            placeholder: "Create a secure password",
            isPassword: true,
            controller: passwordController,
            onChanged: onChanged,
          ),
          const SizedBox(height: 16),
          BiometricToggle(
            value: biometricsEnabled,
            onChanged: onBiometricsChanged,
          ),
        ],
      ),
    );
  }
}
