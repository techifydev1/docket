import 'package:docket/features/auth/auth_service.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/user/user_provider.dart';
import 'package:docket/features/user/user_response.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/toast.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:docket/features/onboarding/widgets/code_card.dart';

class ThirdScreen extends StatefulWidget {
  final VoidCallback? onComplete;
  const ThirdScreen({super.key, this.onComplete});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  String _code = '';
  bool _isVerifying = false;
  bool _isSending = false;
  int _codeResets = 0;

  Future<void> _resend() async {
    setState(() => _isSending = true);
    String? error;
    String? message;
    try {
      message = await AuthService.sendVerificationEmail();
    } on ApiError catch (e) {
      error = e.errorMessage;
    }
    if (!mounted) return;
    setState(() {
      _isSending = false;
      _code = '';
      _codeResets++;
    });
    if (error != null) {
      Toast.show(context, error, variant: ToastVariant.error);
      return;
    }
    Toast.show(context, message!, variant: ToastVariant.success);
  }

  Future<void> _verify() async {
    setState(() => _isVerifying = true);
    String? error;
    String? message;
    try {
      message = await AuthService.verifyEmail(_code);
    } on ApiError catch (e) {
      error = e.errorMessage;
    }
    if (!mounted) return;
    if (error == null) {
      final userProvider = context.read<UserProvider>();
      final user = userProvider.userResponse;
      if (user != null) {
        userProvider.updateUser(
          UserResponse(
            fullName: user.fullName,
            id: user.id,
            email: user.email,
            phone: user.phone,
            profilePic: user.profilePic,
            createdAt: user.createdAt,
            emailVerified: true,
          ),
        );
      }
    }
    setState(() => _isVerifying = false);
    if (error != null) {
      Toast.show(context, error, variant: ToastVariant.error);
      return;
    }
    Toast.show(context, message!, variant: ToastVariant.success);
    await _refreshUser();
    if (!mounted) return;
    widget.onComplete?.call();
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _refreshUser() async {
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      await FirebaseAuth.instance.currentUser?.getIdToken(true);
    } on FirebaseAuthException catch (e) {
      debugPrint("Failed to refresh user after verification: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isValid = _code.length == 6;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          const Header(
            icon: Icons.mail_outline,
            title: "Verify your email",
            subtitle:
                "We sent a 6-digit code to your email. Enter it below to confirm you own this address and enable secure account recovery.",
          ),
          const SizedBox(height: 24),
          CodeCard(
            onChanged: (pin) => setState(() => _code = pin),
            onResend: _resend,
            isSending: _isSending,
            resetKey: _codeResets,
          ),
          const SizedBox(height: 16),
          TrustCard(
            icon: Icons.lock_outline,
            title: "Secure Email Verification",
            description:
                "Your code expires in 15 minutes and is single-use. It's never shared with anyone else.",
            cardRadius: 8,
            iconBgColor: colors.secondaryContainer,
            iconColor: colors.onSecondaryContainer,
            iconShape: .circle,
          ),
          const SizedBox(height: 16),
          CtaSection(
            onPressed: isValid && !_isVerifying ? _verify : null,
            isLoading: _isVerifying,
            label: "Verify Email",
            isEntry: false,
            helperText:
                "Your email is kept private and only used for essential vault notifications.",
          ),
          const SizedBox(height: 24),
          Center(
            child: TextButton.icon(
              onPressed: _isVerifying ? null : _logout,
              icon: const Icon(Icons.logout, size: 16),
              label: const Text("Log out"),
              style: TextButton.styleFrom(
                foregroundColor: colors.error,
                padding: const .symmetric(horizontal: 12, vertical: 8),
                minimumSize: const Size(0, 0),
                tapTargetSize: .shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                textStyle: textTheme.labelMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
