import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/text_field.dart';
import 'package:flutter/material.dart';

import 'package:docket/features/onboarding/widgets/biometric_toggle.dart';
import 'package:docket/features/onboarding/widgets/user_avatar.dart';

class ProfileCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final VoidCallback onChanged;
  const ProfileCard({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return DocketCard(
      child: Column(
        children: [
          Container(
            padding: const .only(bottom: 12),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: VaultTheme.hairline, width: 1),
              ),
            ),
            child: Row(
              spacing: 14,
              children: [
                const UserAvatar(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text("Profile Avatar", style: textTheme.labelLarge),
                      const SizedBox(height: 2),
                      Text(
                        "Tap camera to upload or take a photo",
                        style: textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
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
          const BiometricToggle(),
        ],
      ),
    );
  }
}
