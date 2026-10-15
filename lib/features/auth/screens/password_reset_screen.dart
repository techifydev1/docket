import 'package:docket/features/auth/auth_service.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/onboarding/widgets/code_card.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/form_card.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/text_field.dart';
import 'package:docket/shared/toast.dart';
import 'package:flutter/material.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSending = false;
  bool _isResetting = false;
  bool _codeSent = false;
  String _code = '';
  int _codeResets = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String get _email => _emailController.text.trim();

  bool get _isValidEmail => _email.contains('@') && _email.contains('.');

  bool get _isValidPassword => _passwordController.text.length >= 6;

  Future<void> _sendCode() async {
    if (!_isValidEmail || _isSending) return;
    setState(() => _isSending = true);
    try {
      await AuthService.requestPasswordReset(_email);
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
      return;
    }
    if (!mounted) return;
    setState(() {
      _isSending = false;
      _codeSent = true;
      _code = '';
      _codeResets++;
    });
    Toast.show(
      context,
      "We sent a reset code to your email",
      variant: ToastVariant.success,
    );
  }

  Future<void> _reset() async {
    if (_code.length != 6 || !_isValidPassword || _isResetting) return;
    setState(() => _isResetting = true);
    try {
      await AuthService.confirmPasswordReset(
        email: _email,
        otp: _code,
        password: _passwordController.text,
      );
    } on ApiError catch (e) {
      if (!mounted) return;
      setState(() => _isResetting = false);
      Toast.show(context, e.errorMessage, variant: .error);
      return;
    }
    if (!mounted) return;
    setState(() => _isResetting = false);
    Toast.show(
      context,
      "Password reset successful, please log in",
      variant: .success,
    );
    Navigator.of(context).pop(_email);
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const .all(16),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 32,
              ),
              child: Column(
                mainAxisAlignment: .center,
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
                  Header(
                    icon: _codeSent ? Icons.mail_outline : Icons.lock_reset,
                    title: _codeSent
                        ? "Verify your email"
                        : "Reset your password",
                    subtitle: _codeSent
                        ? "Enter the 6-digit code we sent to $_email and choose a new password."
                        : "Enter the email linked to your vault and we'll send you a 6-digit reset code.",
                  ),
                  const SizedBox(height: 24),
                  if (!_codeSent) ...[
                    FormCard(
                      title: "Account email",
                      child: DocketTextField(
                        label: "Email address",
                        placeholder: "you@example.com",
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        onChanged: () => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CtaSection(
                      onPressed: _isValidEmail && !_isSending
                          ? _sendCode
                          : null,
                      isLoading: _isSending,
                      label: "Send reset code",
                      isEntry: true,
                      helperText:
                          "We'll email a one-time code to confirm it's really you.",
                    ),
                  ] else ...[
                    CodeCard(
                      onChanged: (pin) => setState(() => _code = pin),
                      onResend: _sendCode,
                      isSending: _isSending,
                      resetKey: _codeResets,
                    ),
                    const SizedBox(height: 16),
                    FormCard(
                      title: "New password",
                      child: DocketTextField(
                        label: "Password",
                        placeholder: "Enter a new password",
                        isPassword: true,
                        controller: _passwordController,
                        onChanged: () => setState(() {}),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CtaSection(
                      onPressed:
                          _code.length == 6 && _isValidPassword && !_isResetting
                          ? _reset
                          : null,
                      isLoading: _isResetting,
                      label: "Reset password",
                      isEntry: true,
                      helperText:
                          "Use at least 6 characters for your new password.",
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _isResetting
                          ? null
                          : () => setState(() => _codeSent = false),
                      child: const Text("Use a different email"),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
