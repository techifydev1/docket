import 'package:docket/features/auth/auth_service.dart';
import 'package:docket/features/auth/models/register_request.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/onboarding/onboarding_controller.dart';
import 'package:docket/features/user/user_provider.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';

import 'package:docket/features/onboarding/widgets/profile_card.dart';
import 'package:provider/provider.dart';

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
            onPressed: _isValid
                ? () async {
                    OnboardingController cont = context
                        .read<OnboardingController>();
                    UserProvider userProvider = context.read<UserProvider>();
                    FamilyProvider familyProvider = context
                        .read<FamilyProvider>();
                    cont.updateStep2(
                      name: _nameController.value.text,
                      email: _emailController.value.text,
                      phone: _phoneController.value.text,
                      password: _passwordController.value.text,
                    );
                    debugPrint(
                      "Read stuffs from the context: ${cont.requestData.fullName}, ${cont.requestData.email}, ${cont.requestData.password}, ${cont.requestData.phone}",
                    );
                    final req = RegisterRequest();
                    req.fullName = cont.requestData.fullName;
                    req.vaultName = cont.requestData.vaultName;
                    req.isBiometricsEnabled =
                        cont.requestData.isBiometricsEnabled;
                    req.email = cont.requestData.email;
                    req.password = cont.requestData.password;
                    req.phone = cont.requestData.phone;
                    final res = await AuthService.register(req);
                    userProvider.updateUser(res.user);
                    familyProvider.updateFamilies(res.families);
                    widget.pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
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
