import 'package:flutter/material.dart';

import 'package:docket/features/onboarding/widgets/continue_section.dart';
import 'package:docket/features/onboarding/widgets/family_name_input.dart';
import 'package:docket/features/onboarding/widgets/headline_and_value_prop.dart';
import 'package:docket/features/onboarding/widgets/privacy_card.dart';
import 'package:docket/features/onboarding/widgets/trust_section.dart';

class FirstScreen extends StatefulWidget {
  final PageController pageController;
  const FirstScreen({super.key, required this.pageController});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasName = _nameController.text.trim().isNotEmpty;
    return SingleChildScrollView(
      child: Column(
        children: [
          const TrustSection(),
          const SizedBox(height: 24),
          const HeadlineAndValueProp(),
          const SizedBox(height: 24),
          FamilyNameInput(
            controller: _nameController,
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 16),
          const PrivacyCard(),
          const SizedBox(height: 32),
          ContinueSection(
            pageController: widget.pageController,
            enabled: hasName,
          ),
        ],
      ),
    );
  }
}
