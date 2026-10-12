import 'dart:typed_data';

import 'package:docket/features/documents/document_item.dart';
import 'package:docket/features/documents/documents_provider.dart';
import 'package:docket/features/http/api_response.dart';
import 'package:docket/shared/info_row.dart';
import 'package:docket/shared/pill_chip.dart';
import 'package:docket/shared/toast.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final DocumentItem document;
  const DocumentDetailsScreen({super.key, required this.document});

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  static const _imageTypes = {"png", "jpg", "jpeg", "gif", "webp"};

  Uint8List? _imageBytes;
  bool _isViewing = false;
  bool _isDownloading = false;

  DocumentItem get _document => widget.document;
  bool get _isImage => _imageTypes.contains(_document.fileType.toLowerCase());
  bool get _isBusy => _isViewing || _isDownloading;

  Future<void> _view() async {
    if (_isBusy) return;
    if (!_isImage) {
      await _download();
      return;
    }
    setState(() => _isViewing = true);
    try {
      final bytes = await context
          .read<DocumentsProvider>()
          .service
          .getDecryptedDocument(context, _document.record);
      if (!mounted) return;
      if (bytes == null) {
        Toast.show(
          context,
          "This file could not be opened",
          variant: ToastVariant.error,
        );
        return;
      }
      setState(() => _imageBytes = bytes);
    } on ApiError catch (e) {
      if (!mounted) return;
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
    } finally {
      if (mounted) setState(() => _isViewing = false);
    }
  }

  Future<void> _download() async {
    if (_isBusy) return;
    setState(() => _isDownloading = true);
    try {
      await context.read<DocumentsProvider>().service.shareDecrypted(
        context,
        _document.record,
      );
    } on ApiError catch (e) {
      if (!mounted) return;
      Toast.show(context, e.errorMessage, variant: ToastVariant.error);
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  Widget _preview(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final bytes = _imageBytes;
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
    return _PreviewPlaceholder(icon: _document.icon, isLoading: _isViewing);
  }

  Widget _actions(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: _isBusy ? null : _view,
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              ),
              child: _isViewing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text("View", style: textTheme.labelLarge),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _isBusy ? null : _download,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              ),
              icon: _isDownloading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download_outlined, size: 18),
              label: const Text("Download"),
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
