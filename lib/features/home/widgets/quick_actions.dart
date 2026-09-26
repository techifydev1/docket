import 'package:flutter/material.dart';

class QuickActions extends StatelessWidget {
  final VoidCallback onUpload;
  const QuickActions({super.key, required this.onUpload});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: onUpload,
              style: FilledButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              ),
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  const Icon(Icons.upload_file, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Upload",
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.onSurface,
                backgroundColor: colors.surfaceContainerLowest,
                side: BorderSide(color: colors.outlineVariant),
                shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              ),
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  const Icon(Icons.person_add_alt_1_outlined, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    "Invite",
                    style: textTheme.labelLarge?.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
