import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/link_button.dart';
import 'package:docket/shared/text_field.dart';
import 'package:flutter/material.dart';

class LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onChanged;
  final VoidCallback onForgotPassword;
  const LoginCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onChanged,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return DocketCard(
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
            child: LinkButton(
              label: "Forgot password?",
              onPressed: onForgotPassword,
            ),
          ),
        ],
      ),
    );
  }
}
