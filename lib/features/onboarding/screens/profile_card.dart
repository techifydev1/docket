import 'package:docket/shared/text_field.dart';
import 'package:flutter/material.dart';

import 'biometric_toggle.dart';
import 'user_avatar.dart';

class ProfileCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final VoidCallback onChanged;
  const ProfileCard({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colors.surfaceContainerHigh.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              spacing: 14,
              children: [
                const UserAvatar(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Profile Avatar",
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Tap camera to upload or take a photo",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
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
