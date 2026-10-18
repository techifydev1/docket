import 'package:flutter/material.dart';

class DocketBackButton extends StatelessWidget {
  const DocketBackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 40,
      height: 40,
      child: Material(
        color: colors.surfaceContainer,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed ?? () => Navigator.of(context).maybePop(),
          child: Icon(
            Icons.arrow_back_rounded,
            size: 20,
            color: colors.onSurface,
          ),
        ),
      ),
    );
  }
}
