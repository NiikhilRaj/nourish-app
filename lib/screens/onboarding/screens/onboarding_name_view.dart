import 'package:flutter/material.dart';

import '../../../widgets/onboarding/onboarding_action_button.dart';
import '../../../widgets/onboarding/onboarding_step_scaffold.dart';
import '../../../widgets/onboarding/onboarding_text_field.dart';

class OnboardingNameView extends StatelessWidget {
  const OnboardingNameView({
    super.key,
    required this.controller,
    required this.errorText,
    required this.isSaving,
    required this.onNext,
  });

  final TextEditingController controller;
  final String? errorText;
  final bool isSaving;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return OnboardingStepScaffold(
      question: 'What do we call you?',
      field: OnboardingTextField(
        controller: controller,
        hintText: 'Enter your name',
        errorText: errorText,
        textCapitalization: TextCapitalization.words,
      ),
      footer: SizedBox(
        width: double.infinity,
        child: OnboardingActionButton(
          label: 'Next',
          icon: Icons.chevron_right,
          onPressed: isSaving ? null : onNext,
        ),
      ),
    );
  }
}
