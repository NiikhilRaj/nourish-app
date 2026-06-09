import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../onboarding_model.dart';
import 'onboarding_name_view.dart';

class OnboardingAgeView extends StatelessWidget {
  const OnboardingAgeView({
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
      question: 'How old are you??',
      field: OnboardingTextField(
        controller: model.ageController,
        hintText: 'Enter your age',
        errorText: model.ageError,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(3),
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
}
