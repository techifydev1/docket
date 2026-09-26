import 'package:docket/features/onboarding/widgets/step_indicator.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final int currentScreen;
  final VoidCallback? onBack;
  const TopBar({super.key, required this.currentScreen, this.onBack});

  static const List<String> _stepLabels = [
    'GETTING STARTED',
    'YOUR PROFILE',
    'VERIFY EMAIL',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 24),
      child: Column(
        children: [
          Row(
            spacing: 8,
            children: List.generate(
              3,
              (index) => Expanded(
                child: StepIndicator(currentOrPassed: currentScreen >= index),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              _StepInfo(
                currentStep: currentScreen,
                stepLabel: _stepLabels[currentScreen],
              ),
              if (onBack != null)
                IconButton(
                  onPressed: onBack,
                  tooltip: 'Go back',
                  visualDensity: .compact,
                  icon: Icon(
                    Icons.arrow_back,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                )
              else
                Text(
                  "Setup",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: .w700,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomDot extends StatelessWidget {
  const _CustomDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: .circle,
      ),
    );
  }
}

class _StepInfo extends StatelessWidget {
  final int currentStep;
  final String stepLabel;
  const _StepInfo({required this.currentStep, required this.stepLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: .circular(20),
      ),
      child: Padding(
        padding: const .symmetric(vertical: 4, horizontal: 8),
        child: Row(
          crossAxisAlignment: .center,
          children: [
            const _CustomDot(),
            const SizedBox(width: 2),
            Text(
              "STEP ${currentStep + 1} OF 3 \u2022 $stepLabel",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: .w700,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
