import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../onboarding_model.dart';
import 'onboarding_name_view.dart';

class OnboardingBodyMetricsView extends StatelessWidget {
  const OnboardingBodyMetricsView({
    super.key,
    required this.model,
    required this.onBack,
    required this.onNext,
  });

  final OnboardingViewModel model;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScaffold(
      question: "Let's get your basic stats!",
      field: Column(
        children: [
          OnboardingTextField(
            controller: model.heightController,
            hintText: 'Enter your height(in cm)',
            errorText: model.heightError,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              _decimalFormatter(),
              LengthLimitingTextInputFormatter(5),
            ],
          ),
          const SizedBox(height: 30),
          OnboardingTextField(
            controller: model.weightController,
            hintText: 'Enter your weight (in kg)',
            errorText: model.weightError,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              _decimalFormatter(),
              LengthLimitingTextInputFormatter(5),
            ],
          ),
        ],
      ),
      footer: Row(
        children: [
          Expanded(
            child: OnboardingActionButton(
              label: 'Back',
              variant: OnboardingActionVariant.outlined,
              onPressed: onBack,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: OnboardingActionButton(
              label: 'Next',
              onPressed: model.isSaving ? null : onNext,
            ),
          ),
        ],
      ),
    );
  }

  TextInputFormatter _decimalFormatter() {
    final pattern = RegExp(r'^\d*\.?\d{0,1}$');
    return TextInputFormatter.withFunction((oldValue, newValue) {
      if (pattern.hasMatch(newValue.text)) return newValue;
      return oldValue;
    });
  }
}
