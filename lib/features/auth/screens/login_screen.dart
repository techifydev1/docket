import 'package:docket/features/home/home_screen.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';

import 'login_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.isNotEmpty;

  void _login() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: 'Go back',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Header(
                icon: Icons.lock_outline,
                title: "Welcome back",
                subtitle:
                    "Sign in to unlock your family vault and access your encrypted documents.",
              ),
              const SizedBox(height: 24),
              LoginCard(
                emailController: _emailController,
                passwordController: _passwordController,
                onChanged: () => setState(() {}),
              ),
              const SizedBox(height: 16),
              const TrustCard(
                icon: Icons.verified_user,
                title: "End-to-End Encrypted",
                description:
                    "Your credentials are shielded with zero-knowledge encryption. We never see your password.",
                cardRadius: 8,
              ),
              const SizedBox(height: 16),
              CtaSection(
                onPressed: _isValid ? _login : null,
                label: "Log In",
                isEntry: true,
                footer: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have a vault? ",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Create one",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
