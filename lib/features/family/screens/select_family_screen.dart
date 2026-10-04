import 'package:docket/features/family/widgets/family_card.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/family/family_response.dart';
import 'package:docket/features/home/screens/home_screen.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/section_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectFamilyScreen extends StatelessWidget {
  const SelectFamilyScreen({super.key});

  void _continue(BuildContext context, FamilyResponse? selected) {
    if (selected == null) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final provider = context.watch<FamilyProvider>();
    final families = provider.families;
    final selected = provider.selectedFamily;
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
                icon: Icons.groups,
                title: "Choose a family",
                subtitle:
                    "Select the family vault you want to open. You can switch later from settings.",
              ),
              const SizedBox(height: 24),
              if (families.isEmpty)
                const _EmptyFamilies()
              else ...[
                const SectionHeader(title: "Family Vaults"),
                const SizedBox(height: 12),
                for (final family in families)
                  Padding(
                    padding: const .only(bottom: 12),
                    child: FamilyCard(
                      family: family,
                      isSelected: family.id == selected?.id,
                      onTap: () => provider.updateFamily(family),
                    ),
                  ),
              ],
              const SizedBox(height: 16),
              CtaSection(
                onPressed: selected == null
                    ? null
                    : () => _continue(context, selected),
                label: "Continue",
                isEntry: true,
                helperText: selected == null
                    ? "Pick a family vault to continue"
                    : "You'll only see the documents you're allowed to view.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyFamilies extends StatelessWidget {
  const _EmptyFamilies();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: .circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              shape: .circle,
            ),
            child: Icon(
              Icons.group_off_outlined,
              size: 24,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "No family vaults yet",
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: .w600,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "You're not a member of any family vault. Create one to start storing documents.",
            textAlign: .center,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
