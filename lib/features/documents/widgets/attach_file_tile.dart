import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/features/documents/add_document_provider.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/icon_tile.dart';
import 'package:docket/shared/toast.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class AttachFileTile extends StatelessWidget {
  const AttachFileTile({super.key});

  static const _maxUploadBytes = 10 * 1024 * 1024;

  Future<void> _attach(BuildContext context) async {
    try {
      PlatformFile? file = await FilePicker.pickFile(type: FileType.any);
      if (file == null) return;
      final length = file.lengthSync() ?? await file.length() ?? 0;
      if (length > _maxUploadBytes) {
        if (!context.mounted) return;
        Toast.show(
          context,
          "Files must be 10 MB or smaller",
          variant: ToastVariant.error,
        );
        return;
      }
      if (!context.mounted) return;
      context.read<AddDocumentProvider>().updateFileInfo(
        await file.readAsBytes(),
        file.extension ?? "unknown",
        length.toString(),
        file.name,
      );
    } catch (e) {
      debugPrint("An error occured while picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    final document = context.watch<AddDocumentProvider>();
    final isAttached = document.hasFile;
    return DocketCard(
      child: Column(
        children: [
          Row(
            children: [
              const IconTile(
                icon: Icons.upload_file_rounded,
                size: 48,
                iconSize: 24,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      isAttached ? document.fileName! : "No file attached",
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: textTheme.labelLarge,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isAttached
                          ? "${document.dataType!.toUpperCase()} · ${document.sizeLabel}"
                          : "Pick a file from your device to get started",
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                await _attach(context);
              },
              child: Text(isAttached ? "Change file" : "Choose file"),
            ),
          ),
        ],
      ),
    );
  }
}
