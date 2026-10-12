import 'package:docket/features/documents/screens/add_file_screen.dart';
import 'package:docket/features/documents/add_document_provider.dart';
import 'package:docket/features/documents/document_item.dart';
import 'package:docket/features/documents/documents_provider.dart';
import 'package:docket/features/documents/screens/document_details_screen.dart';
import 'package:docket/features/documents/screens/documents_screen.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/home/screens/invite_member_screen.dart';
import 'package:docket/features/home/widgets/family_members.dart';
import 'package:docket/features/home/widgets/home_header.dart';
import 'package:docket/features/home/widgets/quick_actions.dart';
import 'package:docket/features/home/widgets/vault_card.dart';
import 'package:docket/features/invitation/screens/invitations_screen.dart';
import 'package:docket/shared/bottom_nav.dart';
import 'package:docket/shared/document_card.dart';
import 'package:docket/shared/section_header.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadDocuments());
  }

  Future<void> _loadDocuments() async {
    if (!mounted) return;
    final family = context.read<FamilyProvider>().selectedFamily;
    if (family == null) return;
    final provider = context.read<DocumentsProvider>();
    if (provider.isLoading || provider.documents.isNotEmpty) return;
    await provider.load(familyId: family.id, members: family.familyMembers);
  }

  Future<void> _upload(BuildContext context) async {
    context.read<AddDocumentProvider>().reset();
    final created = await Navigator.of(context).push<DocumentItem>(
      MaterialPageRoute(builder: (_) => const AddFileScreen()),
    );
    if (created == null || !context.mounted) return;
    context.read<DocumentsProvider>().add(created);
  }

  void _invite(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const InviteMemberScreen()));
  }

  void _openInvitations(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const InvitationsScreen()));
  }

  void _openDocuments(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DocumentsScreen()));
  }

  void _openDocument(BuildContext context, DocumentItem document) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DocumentDetailsScreen(document: document),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DocumentsProvider>();
    final documents = provider.documents;
    final recent = documents.take(3).toList();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const .fromLTRB(16, 16, 16, 16),
              child: HomeHeader(onInvitations: () => _openInvitations(context)),
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
                    SectionHeader(
                      title: "Recent Documents",
                      action: "View all",
                      onAction: () => _openDocuments(context),
                    ),
                    const SizedBox(height: 12),
                    if (provider.isLoading && documents.isEmpty)
                      const _LoadingDocuments()
                    else if (recent.isEmpty)
                      const _EmptyDocuments()
                    else
                      for (final document in recent) ...[
                        DocumentCard(
                          icon: document.icon,
                          title: document.title,
                          subtitle: document.subtitle,
                          onTap: () => _openDocument(context, document),
                        ),
                        const SizedBox(height: 12),
                      ],
                    const SizedBox(height: 12),
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

class _LoadingDocuments extends StatelessWidget {
  const _LoadingDocuments();

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
      child: Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Loading your documents…",
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyDocuments extends StatelessWidget {
  const _EmptyDocuments();

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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: .center,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: .circular(8),
            ),
            child: Icon(
              Icons.folder_open_outlined,
              size: 20,
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "No documents yet. Add your first file and it'll show up here.",
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
