import 'package:flutter/material.dart';

import 'continue_section.dart';
import 'family_name_input.dart';
import 'headline_and_value_prop.dart';
import 'privacy_card.dart';
import 'trust_section.dart';

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
