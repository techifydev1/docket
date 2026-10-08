import 'package:docket/features/documents/add_document_provider.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class AttachFileTile extends StatelessWidget {
  const AttachFileTile({super.key});

  Future<void> _attach(BuildContext context) async {
    try {
      PlatformFile? file = await FilePicker.pickFile(type: FileType.any);
      if (file == null) return;
      if (!context.mounted) return;
      context.read<AddDocumentProvider>().updateFileInfo(
        await file.readAsBytes(),
        file.extension ?? "unknown",
        (file.lengthSync() ?? await file.length() ?? 0).toString(),
        file.name,
      );
    } catch (e) {
      debugPrint("An error occured while picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final document = context.watch<AddDocumentProvider>();
    final isAttached = document.hasFile;
    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: .circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.surfaceContainerHigh,
                  borderRadius: .circular(8),
                ),
                child: Icon(
                  Icons.upload_file,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      isAttached ? document.fileName! : "No file attached",
                      style: textTheme.labelLarge?.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isAttached
                          ? "${document.dataType!.toUpperCase()} · ${document.sizeLabel}"
                          : "Pick a file from your device to get started",
                      style: textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () async {
                await _attach(context);
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              ),
              child: Text(
                isAttached ? "Change file" : "Choose file",
                style: textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
