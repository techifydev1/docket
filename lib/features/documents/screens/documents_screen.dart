import 'package:docket/features/documents/screens/add_file_screen.dart';
import 'package:docket/features/documents/add_document_provider.dart';
import 'package:docket/features/documents/document_category.dart';
import 'package:docket/features/documents/documents_provider.dart';
import 'package:docket/features/documents/screens/document_details_screen.dart';
import 'package:docket/features/documents/widgets/document_filter_chips.dart';
import 'package:docket/features/documents/document_item.dart';
import 'package:docket/features/documents/widgets/documents_header.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/shared/bottom_nav.dart';
import 'package:docket/shared/document_card.dart';
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
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }

  Widget _body(DocumentsProvider provider, List<DocumentItem> documents) {
    if (provider.isLoading && provider.documents.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.error != null && provider.documents.isEmpty) {
      return _DocumentsMessage(
        icon: Icons.cloud_off_outlined,
        title: "Couldn't load your documents",
        message: provider.error!,
        onRetry: _load,
      );
    }
    if (documents.isEmpty) {
      return const _DocumentsMessage(
        icon: Icons.folder_open_outlined,
        title: "No documents yet",
        message:
            "Add your first file and it will show up here, sealed with your family key.",
      );
    }
    return ListView.separated(
      padding: const .fromLTRB(16, 0, 16, 16),
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

class _DocumentsMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final VoidCallback? onRetry;
  const _DocumentsMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const .all(24),
        child: Column(
          mainAxisSize: .min,
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: .center,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHigh,
                shape: .circle,
              ),
              child: Icon(icon, size: 24, color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: .center,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: .w600,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              textAlign: .center,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                  side: BorderSide(color: colors.outlineVariant),
                  minimumSize: const Size(0, 40),
                  shape: RoundedRectangleBorder(borderRadius: .circular(8)),
                  textStyle: textTheme.labelMedium,
                ),
                child: const Text("Try again"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
