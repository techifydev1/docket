import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final bool currentOrPassed;
  const StepIndicator({super.key, required this.currentOrPassed});

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.all(4.0),
      height: 10,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: currentOrPassed
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.surfaceContainer,
      ),
    );
  }
}
