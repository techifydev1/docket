import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:docket/shared/link_button.dart';
import 'package:flutter/material.dart';

import 'package:docket/features/onboarding/widgets/code_input.dart';

class CodeCard extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onResend;
  final bool isSending;
  final int resetKey;
  const CodeCard({
    super.key,
    required this.onChanged,
    required this.onResend,
    this.isSending = false,
    this.resetKey = 0,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = VaultTheme.textTheme;
    return DocketCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text("Verification Code", style: textTheme.labelLarge),
              Text("Expires in 15:00", style: textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 12),
          CodeInput(key: ValueKey(resetKey), onChanged: onChanged),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: .center,
            children: [
              Text("Didn't get the code?", style: textTheme.bodySmall),
              const SizedBox(width: 6),
              if (isSending)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                LinkButton(label: "Resend code", onPressed: onResend),
            ],
          ),
        ],
      ),
    );
  }
}
