import 'dart:typed_data';

import 'package:docket/features/documents/document_item.dart';
import 'package:docket/features/documents/documents_provider.dart';
import 'package:docket/features/documents/screens/document_viewer_screen.dart';
import 'package:docket/features/family/family_provider.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/shared/confirm_dialog.dart';
import 'package:docket/shared/info_row.dart';
import 'package:docket/shared/pill_chip.dart';
import 'package:docket/shared/toast.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:provider/provider.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final DocumentItem document;
  const DocumentDetailsScreen({super.key, required this.document});

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  static const _imageTypes = {"png", "jpg", "jpeg", "gif", "webp"};

  Uint8List? _documentBytes;
  Uint8List? _previewBytes;
  bool _isGeneratingPreview = false;
  bool _isSharing = false;

  DocumentItem get _document => widget.document;
  bool get _isImage => _imageTypes.contains(_document.fileType.toLowerCase());
  bool get _isPdf => _document.fileType.toLowerCase() == "pdf";
  bool get _canPreview => _isImage || _isPdf;

  @override
  void initState() {
    super.initState();
    _generatePreview();
  }

  Future<void> _generatePreview() async {
    if (!_canPreview || !mounted) return;
    setState(() => _isGeneratingPreview = true);
    try {
      final bytes = await context
          .read<DocumentsProvider>()
          .service
          .getDecryptedDocument(context, _document.record);
      if (bytes == null || !mounted) return;
      final preview = _isPdf ? await _renderPdfFirstPage(bytes) : bytes;
      if (!mounted) return;
      setState(() {
        _documentBytes = bytes;
        _previewBytes = preview;
      });
    } on ApiError catch (e) {
      if (!mounted) return;
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
    } catch (_) {
      if (!mounted) return;
      Toast.show(
        context,
        "Could not render a preview for this file",
        variant: ToastVariant.error,
      );
    } finally {
      if (mounted) setState(() => _isGeneratingPreview = false);
    }
  }

  Future<Uint8List?> _renderPdfFirstPage(Uint8List bytes) async {
    final document = await PdfDocument.openData(bytes);
    try {
      final page = await document.getPage(1);
      try {
        final image = await page.render(
          width: page.width * 2,
          height: page.height * 2,
          format: PdfPageImageFormat.png,
          backgroundColor: '#FFFFFF',
        );
        return image?.bytes;
      } finally {
        await page.close();
      }
    } finally {
      await document.close();
    }
  }

  void _view() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            DocumentViewerScreen(document: _document, bytes: _documentBytes),
      ),
    );
  }

  Future<void> _share() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);
    try {
      await context.read<DocumentsProvider>().service.shareDecrypted(
        context,
        _document.record,
      );
    } on ApiError catch (e) {
      if (!mounted) return;
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  Future<void> _delete() async {
    final navigator = Navigator.of(context);
    final provider = context.read<DocumentsProvider>();
    final family = context.read<FamilyProvider>().selectedFamily;
    if (family == null) return;
    final docId = _document.record.id;
    var deleted = false;
    final confirmed = await ConfirmDialog.show(
      context,
      title: "Delete document?",
      message:
          "This permanently removes \"${_document.title}\" for everyone in the vault. This can't be undone.",
      confirmLabel: "Delete",
      icon: Icons.delete_outline,
      isDestructive: true,
      onConfirm: () async {
        try {
          await provider.service.deleteDocument(family.id, docId);
          deleted = true;
        } on ApiError catch (e) {
          if (!mounted) return;
          Toast.show(context, e.errorMessage, variant: ToastVariant.error);
        }
      },
    );
    if (!mounted) return;
    if (confirmed && deleted) {
      provider.remove(docId);
      Toast.show(context, "Document deleted", variant: ToastVariant.success);
      navigator.pop();
    }
  }

  Widget _preview(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bytes = _previewBytes;
    if (bytes != null) {
      return ClipRRect(
        borderRadius: .circular(12),
        child: Container(
          height: 220,
          width: double.infinity,
          color: colors.surfaceContainerLow,
          alignment: .center,
          child: Image.memory(bytes, fit: BoxFit.contain),
        ),
      );
    }
    return _PreviewPlaceholder(
      icon: _document.icon,
      isLoading: _isGeneratingPreview,
    );
  }

  Widget _actions(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: _view,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              ),
              child: Text("View", style: textTheme.labelLarge),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _isSharing ? null : _share,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              ),
              icon: _isSharing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.ios_share, size: 18),
              label: const Text("Share"),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const .fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    tooltip: 'Go back',
                    visualDensity: .compact,
                    icon: Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _document.title,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _delete,
                    tooltip: 'Delete',
                    visualDensity: .compact,
                    icon: Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: colors.error,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const .fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: .stretch,
                  children: [
                    _preview(context),
                    const SizedBox(height: 12),
                    _actions(context),
                    const SizedBox(height: 16),
                    Container(
                      padding: const .all(16),
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerLowest,
                        borderRadius: .circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: colors.onSurface.withValues(alpha: 0.05),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "Document details",
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: .w700,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          InfoRow(
                            label: "Category",
                            value: _document.category.label,
                          ),
                          InfoRow(
                            label: "Owner",
                            value: _document.owner,
                            trailing: const PillChip(
                              icon: Icons.lock_outline,
                              label: "Locked",
                            ),
                          ),
                          InfoRow(
                            label: "File name",
                            value: _document.fileName,
                          ),
                          InfoRow(
                            label: "File type",
                            value: _document.fileType,
                          ),
                          InfoRow(
                            label: "File size",
                            value: _document.fileSize,
                          ),
                          InfoRow(
                            label: "Pages",
                            value: "${_document.pageCount}",
                          ),
                          InfoRow(
                            label: "Date added",
                            value: _document.addedOn,
                          ),
                          InfoRow(
                            label: "Last modified",
                            value: _document.modifiedOn,
                          ),
                          InfoRow(label: "Added by", value: _document.addedBy),
                          InfoRow(
                            label: "Visible to",
                            value: _document.visibility,
                          ),
                          InfoRow(
                            label: "Fingerprint",
                            value: _document.fingerprint,
                          ),
                        ],
                      ),
                    ),
                    if (_document.tags.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const .all(16),
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow,
                          borderRadius: .circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              "Tags",
                              style: textTheme.labelLarge?.copyWith(
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final tag in _document.tags)
                                  PillChip(
                                    icon: Icons.sell_outlined,
                                    label: tag,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    const TrustCard(
                      icon: Icons.verified_user,
                      title: "Encrypted at rest",
                      description:
                          "This file is sealed with zero-knowledge encryption. Only you and the members you listed under Visible to can ever open it.",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewPlaceholder extends StatelessWidget {
  final IconData icon;
  final bool isLoading;
  const _PreviewPlaceholder({required this.icon, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      height: 168,
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: .circular(12),
      ),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: .center,
                children: [
                  Icon(icon, size: 44, color: Theme.of(context).primaryColor),
                  const SizedBox(height: 12),
                  Text(
                    "Preview not available yet",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Tap View to open this file",
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
