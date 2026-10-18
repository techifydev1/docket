import 'package:docket/features/documents/screens/add_file_screen.dart';
import 'package:docket/features/documents/add_document_provider.dart';
import 'package:docket/features/documents/document_category.dart';
import 'package:docket/features/documents/documents_provider.dart';
import 'package:docket/features/documents/screens/document_details_screen.dart';
import 'package:docket/features/documents/widgets/document_filter_chips.dart';
import 'package:docket/features/documents/document_item.dart';
import 'package:docket/features/documents/widgets/documents_header.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/document_card.dart';
import 'package:docket/shared/status_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  DocumentCategory _category = DocumentCategory.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    if (!mounted) return;
    final family = context.read<FamilyProvider>().selectedFamily;
    if (family == null) return;
    await context.read<DocumentsProvider>().load(
      familyId: family.id,
      members: family.familyMembers,
      wrappedKey: family.wrappedKey,
      keyVersion: family.keyVersion,
    );
  }

  List<DocumentItem> _visibleDocuments(DocumentsProvider provider) =>
      _category == DocumentCategory.all
      ? provider.documents
      : provider.documents
            .where((document) => document.category == _category)
            .toList();

  void _openDetails(DocumentItem document) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DocumentDetailsScreen(document: document),
      ),
    );
  }

  Future<void> _addDocument() async {
    context.read<AddDocumentProvider>().reset();
    final created = await Navigator.of(context).push<DocumentItem>(
      MaterialPageRoute(builder: (_) => const AddFileScreen()),
    );
    if (created == null || !mounted) return;
    context.read<DocumentsProvider>().add(created);
    setState(() => _category = DocumentCategory.all);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DocumentsProvider>();
    final documents = _visibleDocuments(provider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const .fromLTRB(16, 16, 16, 0),
              child: DocumentsHeader(
                documentCount: provider.documents.length,
                onAdd: _addDocument,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const .symmetric(horizontal: 16),
              child: DocumentFilterChips(
                selected: _category,
                onChanged: (value) => setState(() => _category = value),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _body(provider, documents)),
          ],
        ),
      ),
    );
  }

  Widget _body(DocumentsProvider provider, List<DocumentItem> documents) {
    if (provider.isLoading && provider.documents.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null && provider.documents.isEmpty) {
      return StatusMessage(
        icon: Icons.cloud_off_outlined,
        title: "Couldn't load your documents",
        message: provider.error!,
        onRetry: _load,
      );
    }
    if (documents.isEmpty) {
      return const StatusMessage(
        icon: Icons.folder_open_outlined,
        title: "No documents yet",
        message:
            "Add your first file and it will show up here, sealed with your family key.",
      );
    }
    return ListView.separated(
      padding: const .fromLTRB(16, 0, 16, VaultTheme.navClearance),
      itemCount: documents.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final document = documents[index];
        return DocumentCard(
          icon: document.icon,
          title: document.title,
          subtitle: document.subtitle,
          onTap: () => _openDetails(document),
        );
      },
    );
  }
}
