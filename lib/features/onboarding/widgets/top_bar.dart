import 'package:docket/core/theme/vault_theme.dart';
import 'package:docket/features/onboarding/widgets/step_indicator.dart';
import 'package:docket/shared/docket_back_button.dart';
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
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              _StepInfo(
                currentStep: currentScreen,
                stepLabel: _stepLabels[currentScreen],
              ),
              if (onBack != null)
                DocketBackButton(onPressed: onBack)
              else
                Text("SETUP", style: VaultTheme.overline),
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
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: VaultTheme.primary,
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
      padding: const .symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: VaultTheme.surfaceContainer,
        borderRadius: .circular(999),
      ),
      child: Row(
        children: [
          const _CustomDot(),
          const SizedBox(width: 8),
          Text(
            "STEP ${currentStep + 1} OF 3 \u2022 $stepLabel",
            style: VaultTheme.overline,
          ),
        ],
      ),
    );
  }
}
