import 'package:docket/shared/text_field.dart';
import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onChanged;
  const LoginCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLowest,
        borderRadius: .circular(12),
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
          DocketTextField(
            label: "Email Address",
            placeholder: "you@example.com",
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            onChanged: onChanged,
          ),
          const SizedBox(height: 16),
          DocketTextField(
            label: "Password",
            placeholder: "Enter your password",
            isPassword: true,
            controller: passwordController,
            onChanged: onChanged,
          ),
          Align(
            alignment: .centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: .zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: .shrinkWrap,
              ),
              child: Text(
                "Forgot password?",
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: .w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
