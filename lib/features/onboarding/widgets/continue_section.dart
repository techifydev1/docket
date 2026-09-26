import 'package:docket/features/auth/screens/login_screen.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:flutter/material.dart';

class ContinueSection extends StatelessWidget {
  final PageController pageController;
  final bool enabled;
  const ContinueSection({
    super.key,
    required this.pageController,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CtaSection(
          onPressed: enabled
              ? () {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              : null,
          label: "Create Family Vault",
          isEntry: true,
          helperText: "You can always rename your vault later in Settings.",
          footer: TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            style: TextButton.styleFrom(
              padding: .zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: .shrinkWrap,
            ),
            child: Text(
              "Already have a vault? Log in",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: .w700,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
