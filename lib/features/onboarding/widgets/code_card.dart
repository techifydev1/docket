import 'package:flutter/material.dart';

import 'package:docket/features/onboarding/widgets/code_input.dart';

class CodeCard extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const CodeCard({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
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
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                "Verification Code",
                style: textTheme.labelMedium?.copyWith(color: colors.onSurface),
              ),
              Text(
                "Expires in 15:00",
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CodeInput(onChanged: onChanged),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: .center,
            children: [
              Text(
                "Didn't get the code? ",
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: .zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: .shrinkWrap,
                ),
                child: Text(
                  "Resend code",
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: .w700,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
