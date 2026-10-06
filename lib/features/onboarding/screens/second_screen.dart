import 'dart:convert';

import 'package:docket/features/auth/auth_service.dart';
import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/onboarding/onboarding_controller.dart';
import 'package:docket/features/user/user_provider.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/toast.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';

import 'package:docket/features/onboarding/widgets/profile_card.dart';
import 'package:provider/provider.dart';
import 'package:sodium/sodium.dart';

class SecondScreen extends StatefulWidget {
  final PageController pageController;
  const SecondScreen({super.key, required this.pageController});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegistering = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          const Header(
            title: "Set up your profile",
            subtitle:
                "Add your details so family records, medical emergencies, and vital notifications can be assigned to you as the primary organizer.",
            titleSubtitleGap: 4,
          ),
          const SizedBox(height: 16),
          ProfileCard(
            nameController: _nameController,
            emailController: _emailController,
            phoneController: _phoneController,
            passwordController: _passwordController,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 16),
          const TrustCard(
            icon: Icons.verified_user,
            title: "Encrypted Personal Vault",
            description:
                "Your personal documents and contact details are shielded with zero-knowledge encryption.",
          ),
          const SizedBox(height: 16),
          CtaSection(
            isLoading: _isRegistering,
            onPressed: _isValid
                ? () async {
                    setState(() => _isRegistering = true);
                    final crypto = context.read<CryptoService>();
                    SecureKey? familyKey;
                    try {
                      OnboardingController cont = context
                          .read<OnboardingController>();
                      UserProvider userProvider = context.read<UserProvider>();
                      FamilyProvider familyProvider = context
                          .read<FamilyProvider>();
                      final publicKey = await crypto.createUserKeys();
                      familyKey = crypto.generateFamilyKey();
                      cont.updateStep2(
                        name: _nameController.value.text,
                        email: _emailController.value.text,
                        phone: _phoneController.value.text,
                        password: _passwordController.value.text,
                        publicKey: publicKey,
                        wrappedFamilyKey: crypto.wrapFamilyKey(
                          familyKey,
                          base64Decode(publicKey),
                        ),
                      );
                      final res = await AuthService.register(cont.requestData);
                      if (res.families.isNotEmpty) {
                        await crypto.saveFamilyKeyLocally(
                          res.families.first.id,
                          familyKey,
                        );
                      }
                      userProvider.updateUser(res.user);
                      familyProvider.updateFamilies(res.families);
                      widget.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } on ApiError catch (e) {
                      if (!context.mounted) return;
                      Toast.show(
                        context,
                        e.errorMessage,
                        variant: ToastVariant.error,
                      );
                    } finally {
                      familyKey?.dispose();
                      if (mounted) setState(() => _isRegistering = false);
                    }
                  }
                : null,
            label: "Complete Setup & Enter Vault",
            isEntry: false,
            helperText:
                "You can invite other family members anytime from your vault settings.",
          ),
        ],
      ),
    );
  }
}
