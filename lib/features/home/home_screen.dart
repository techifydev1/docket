import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';

import 'document_card.dart';
import 'family_members.dart';
import 'quick_actions.dart';
import 'section_header.dart';
import 'vault_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Header(),
              const SizedBox(height: 24),
              const VaultCard(),
              const SizedBox(height: 16),
              const QuickActions(),
              const SizedBox(height: 24),
              const SectionHeader(title: "Recent Documents", action: "View all"),
              const SizedBox(height: 12),
              const DocumentCard(
                icon: Icons.article_outlined,
                title: "Birth Certificate",
                subtitle: "Added 2 days ago",
              ),
              const SizedBox(height: 12),
              const DocumentCard(
                icon: Icons.home_work_outlined,
                title: "Property Deed",
                subtitle: "Added 1 week ago",
              ),
              const SizedBox(height: 12),
              const DocumentCard(
                icon: Icons.health_and_safety_outlined,
                title: "Health Record",
                subtitle: "Added 2 weeks ago",
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: "Family Members"),
              const SizedBox(height: 12),
              const FamilyMembers(),
              const SizedBox(height: 24),
              const TrustCard(
                icon: Icons.verified_user,
                title: "Vault Secured",
                description:
                    "Your documents are protected with zero-knowledge encryption. Only you and invited members hold the keys.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome back",
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Eleanor Vance",
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHigh,
            shape: BoxShape.circle,
            border: Border.all(
              color: colors.primaryContainer.withValues(alpha: 0.2),
              width: 2,
            ),
          ),
          child: Text(
            "EV",
            style: textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
