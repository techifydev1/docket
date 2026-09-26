import 'package:docket/features/documents/document_item.dart';
import 'package:docket/shared/info_row.dart';
import 'package:docket/shared/pill_chip.dart';
import 'package:docket/shared/trust_card.dart';
import 'package:flutter/material.dart';

class DocumentDetailsScreen extends StatelessWidget {
  final DocumentItem document;
  const DocumentDetailsScreen({super.key, required this.document});

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
                      document.title,
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
                    _PreviewPlaceholder(icon: document.icon),
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
                            value: document.category.label,
                          ),
                          InfoRow(
                            label: "Owner",
                            value: document.owner,
                            trailing: const PillChip(
                              icon: Icons.lock_outline,
                              label: "Locked",
                            ),
                          ),
                          InfoRow(label: "File name", value: document.fileName),
                          InfoRow(label: "File type", value: document.fileType),
                          InfoRow(label: "File size", value: document.fileSize),
                          InfoRow(
                            label: "Pages",
                            value: "${document.pageCount}",
                          ),
                          InfoRow(label: "Date added", value: document.addedOn),
                          InfoRow(
                            label: "Last modified",
                            value: document.modifiedOn,
                          ),
                          InfoRow(label: "Added by", value: document.addedBy),
                          InfoRow(
                            label: "Visible to",
                            value: document.visibility,
                          ),
                          InfoRow(
                            label: "Fingerprint",
                            value: document.fingerprint,
                          ),
                        ],
                      ),
                    ),
                    if (document.tags.isNotEmpty) ...[
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
                                for (final tag in document.tags)
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
  const _PreviewPlaceholder({required this.icon});

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
      child: Column(
        mainAxisAlignment: .center,
        children: [
          Icon(icon, size: 44, color: Theme.of(context).primaryColor),
          const SizedBox(height: 12),
          Text(
            "Preview not available yet",
            style: textTheme.bodyMedium?.copyWith(color: colors.onSurface),
          ),
          const SizedBox(height: 2),
          Text(
            "File viewing arrives in a later update",
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
