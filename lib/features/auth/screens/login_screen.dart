import 'package:docket/features/auth/auth_service.dart';
import 'package:docket/features/auth/models/login_request.dart';
import 'package:docket/features/family/screens/select_family_screen.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/onboarding/screens/main_screen.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/toast.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';

import 'package:docket/features/auth/widgets/login_card.dart';

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

  bool _isLoggingIn = false;

  Future<void> _login() async {
    if (!_isValid || _isLoggingIn) return;
    setState(() => _isLoggingIn = true);
    String? error;
    try {
      await AuthService.login(
        LoginRequest(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    } on ApiError catch (e) {
      error = e.errorMessage;
    }
    if (!mounted) return;
    setState(() => _isLoggingIn = false);
    if (error != null) {
      Toast.show(context, error, variant: ToastVariant.error);
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SelectFamilyScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const .all(16),
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Align(
                alignment: .centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: 'Go back',
                  visualDensity: .compact,
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
                onPressed: _isValid && !_isLoggingIn ? _login : null,
                isLoading: _isLoggingIn,
                label: "Log In",
                isEntry: true,
                footer: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Text(
                      "Don't have a vault? ",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: .zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: .shrinkWrap,
                      ),
                      child: Text(
                        "Create one",
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: .w700,
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
