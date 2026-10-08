import 'package:docket/features/documents/add_document_provider.dart';
import 'package:docket/features/documents/widgets/attach_file_tile.dart';
import 'package:docket/features/documents/document_category.dart';
import 'package:docket/features/documents/document_item.dart';
import 'package:docket/features/documents/document_service.dart';
import 'package:docket/features/documents/widgets/owner_selector.dart';
import 'package:docket/features/documents/widgets/tags_field.dart';
import 'package:docket/features/crypto/crypto_service.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/features/user/user_provider.dart';
import 'package:docket/shared/cta_section.dart';
import 'package:docket/shared/chip_selector.dart';
import 'package:docket/shared/form_card.dart';
import 'package:docket/shared/header.dart';
import 'package:docket/shared/pill_chip.dart';
import 'package:docket/shared/text_field.dart';
import 'package:docket/shared/toast.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const _months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

class AddFileScreen extends StatefulWidget {
  const AddFileScreen({super.key});

  @override
  State<AddFileScreen> createState() => _AddFileScreenState();
}

class _AddFileScreenState extends State<AddFileScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  bool _isValid(AddDocumentProvider document) =>
      _titleController.text.trim().isNotEmpty &&
      document.category != null &&
      document.hasFile;

  Future<void> _addToVault() async {
    final document = context.read<AddDocumentProvider>();
    final family = context.read<FamilyProvider>().selectedFamily!;
    final user = context.read<UserProvider>().userResponse!;
    final category = document.category!;
    final ownerId = document.owner ?? user.id;
    final owner = family.familyMembers.firstWhere(
      (member) => member.userId == ownerId,
    );
    setState(() => _isUploading = true);
    try {
      await DocumentService(context.read<CryptoService>()).uploadDocument(
        familyId: family.id,
        keyVersion: family.keyVersion,
        ownerId: ownerId,
        title: _titleController.text.trim(),
        category: category.label,
        tags: document.tags,
        data: document.data!,
        dataType: document.dataType!,
        size: document.size!,
        fileName: document.fileName!,
      );
      if (!mounted) return;
      final now = DateTime.now();
      final today = "${now.day} ${_months[now.month - 1]} ${now.year}";
      Navigator.of(context).pop(
        DocumentItem(
          icon: category.icon,
          title: _titleController.text.trim(),
          subtitle: "Added just now",
          category: category,
          owner: owner.name,
          fileName: document.fileName!,
          addedOn: today,
          modifiedOn: today,
          fingerprint: "Sealed",
          fileType: document.dataType!.toUpperCase(),
          fileSize: document.sizeLabel,
          pageCount: 0,
          tags: document.tags,
        ),
      );
    } on ApiError catch (e) {
      if (!mounted) return;
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
    } catch (e) {
      debugPrint(e.toString());
      if (!mounted) return;
      Toast.show(
        context,
        "Something went wrong, please try again",
        variant: ToastVariant.error,
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final document = context.watch<AddDocumentProvider>();
    final family = context.watch<FamilyProvider>().selectedFamily!;
    final user = context.watch<UserProvider>().userResponse!;
    final members = family.familyMembers;
    final me = members.firstWhere((member) => member.userId == user.id);
    final canUploadForOthers = me.role == "OWNER" || me.role == "ADMIN";
    final selectedOwnerId = document.owner ?? user.id;
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
                    ChipSelector<DocumentCategory>(
                      values: documentCategories,
                      selected: document.category,
                      labelOf: (category) => category.label,
                      onChanged: (value) => context
                          .read<AddDocumentProvider>()
                          .updateCategory(value),
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
                      members: members,
                      currentUserId: user.id,
                      selectedId: selectedOwnerId,
                      canUploadForOthers: canUploadForOthers,
                      onChanged: (member) => context
                          .read<AddDocumentProvider>()
                          .updateOwner(member.userId),
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
                    if (!canUploadForOthers) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 12,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "You're just a member here, so you can't upload documents for someone else.",
                              style: textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FormCard(
                title: "Tags",
                child: TagsField(
                  tags: document.tags,
                  onChanged: (value) =>
                      context.read<AddDocumentProvider>().updateTags(value),
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
                onPressed: _isValid(document) && !_isUploading
                    ? _addToVault
                    : null,
                label: "Add to vault",
                isEntry: false,
                isLoading: _isUploading,
                helperText:
                    "The file and its details are sealed with your family key before anything leaves this device.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
