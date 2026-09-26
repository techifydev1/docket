import 'package:docket/features/documents/screens/add_file_screen.dart';
import 'package:docket/features/home/screens/invite_member_screen.dart';
import 'package:docket/features/home/widgets/family_members.dart';
import 'package:docket/features/home/widgets/home_header.dart';
import 'package:docket/features/home/widgets/quick_actions.dart';
import 'package:docket/features/home/widgets/vault_card.dart';
import 'package:docket/shared/bottom_nav.dart';
import 'package:docket/shared/document_card.dart';
import 'package:docket/shared/section_header.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:docket/shared/vault_member.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _upload(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddFileScreen()));
  }

  Future<void> _invite(BuildContext context) async {
    final member = await Navigator.of(context).push<VaultMember>(
      MaterialPageRoute(builder: (_) => const InviteMemberScreen()),
    );
    if (member == null) return;
    vaultMembers.add(member);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            const Padding(
              padding: .fromLTRB(16, 16, 16, 16),
              child: HomeHeader(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: .fromLTRB(16, 24, 16, 16),
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    const VaultCard(),
                    const SizedBox(height: 16),
                    QuickActions(
                      onUpload: () => _upload(context),
                      onInvite: () => _invite(context),
                    ),
                    const SizedBox(height: 24),
                    const SectionHeader(
                      title: "Recent Documents",
                      action: "View all",
                    ),
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
                    FamilyMembers(onInvite: () => _invite(context)),
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
          ],
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
