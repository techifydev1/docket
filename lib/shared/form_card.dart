import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/shared/docket_card.dart';
import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Widget child;
  const FormCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return DocketCard(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(title, style: VaultTheme.textTheme.titleSmall),
              ?trailing,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
