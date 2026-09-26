import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';

import 'code_card.dart';

class ThirdScreen extends StatefulWidget {
  final VoidCallback onComplete;
  const ThirdScreen({super.key, required this.onComplete});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isValid = _code.length == 6;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Header(
            icon: Icons.mail_outline,
            title: "Verify your email",
            subtitle:
                "We sent a 6-digit code to your email. Enter it below to confirm you own this address and enable secure account recovery.",
          ),
          const SizedBox(height: 24),
          CodeCard(onChanged: (pin) => setState(() => _code = pin)),
          const SizedBox(height: 16),
          TrustCard(
            icon: Icons.lock_outline,
            title: "Secure Email Verification",
            description:
                "Your code expires in 10 minutes and is verified with zero-knowledge encryption. It is never stored on our servers.",
            cardRadius: 8,
            iconBgColor: colors.secondaryContainer,
            iconColor: colors.onSecondaryContainer,
            iconShape: BoxShape.circle,
          ),
          const SizedBox(height: 16),
          CtaSection(
            onPressed: isValid ? widget.onComplete : null,
            label: "Verify Email",
            isEntry: false,
            helperText:
                "Your email is kept private and only used for essential vault notifications.",
          ),
        ],
      ),
    );
  }
}
