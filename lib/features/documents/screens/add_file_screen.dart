import 'package:docket/features/documents/widgets/attach_file_tile.dart';
import 'package:docket/features/documents/widgets/category_selector.dart';
import 'package:docket/features/documents/document_category.dart';
import 'package:docket/features/documents/document_item.dart';
import 'package:docket/features/documents/widgets/owner_selector.dart';
import 'package:docket/features/documents/widgets/tags_field.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/form_card.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/pill_chip.dart';
import 'package:docket/shared/text_field.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';

class AddFileScreen extends StatefulWidget {
  const AddFileScreen({super.key});

  @override
  State<AddFileScreen> createState() => _AddFileScreenState();
}

class _AddFileScreenState extends State<AddFileScreen> {
  final TextEditingController _titleController = TextEditingController();
  DocumentCategory? _category;
  String? _owner;
  List<String> _tags = [];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _titleController.text.trim().isNotEmpty &&
      _category != null &&
      _owner != null;

  void _addToVault() {
    final title = _titleController.text.trim();
    final category = _category!;
    Navigator.of(context).pop(
      DocumentItem(
        icon: category.icon,
        title: title,
        subtitle: "Added just now",
        category: category,
        owner: _owner!,
        fileName: "$title.pdf",
        addedOn: "26 September 2026",
        modifiedOn: "26 September 2026",
        fingerprint: "Pending upload",
        fileType: "Pending",
        fileSize: "Pending",
        pageCount: 0,
        tags: _tags,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
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
                icon: Icons.upload_file,
                title: "Add a document",
                subtitle:
                    "Record a new file in your family vault. Only invited members will ever be able to open it.",
              ),
              const SizedBox(height: 24),
              const AttachFileTile(),
              const SizedBox(height: 16),
              FormCard(
                title: "Document details",
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    DocketTextField(
                      label: "Document name",
                      placeholder: "e.g., Birth Certificate",
                      controller: _titleController,
                      onChanged: () => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Category",
                      style: textTheme.labelMedium?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    CategorySelector(
                      selected: _category,
                      onChanged: (value) => setState(() => _category = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FormCard(
                title: "Owner",
                trailing: const PillChip(
                  icon: Icons.lock_outline,
                  label: "Permanent",
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    OwnerSelector(
                      selectedName: _owner,
                      onChanged: (member) =>
                          setState(() => _owner = member.name),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 12,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "Pick carefully, the owner of a document can never be changed once it is added.",
                            style: textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FormCard(
                title: "Tags",
                child: TagsField(
                  tags: _tags,
                  onChanged: (value) => setState(() => _tags = value),
                ),
              ),
              const SizedBox(height: 16),
              const TrustCard(
                icon: Icons.lock_outline,
                title: "Encrypted before it syncs",
                description:
                    "New records are sealed on your device with zero-knowledge encryption before anything is uploaded.",
                cardRadius: 8,
                iconBgColor: null,
                iconColor: null,
              ),
              const SizedBox(height: 16),
              CtaSection(
                onPressed: _isValid ? _addToVault : null,
                label: "Add to vault",
                isEntry: false,
                helperText:
                    "You can change the category or file later from the document's details.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
