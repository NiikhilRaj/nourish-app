import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Shared layout for every onboarding step screen.
///
/// Renders the fixed header ("Hey there! / Let's get your fitness journey
/// started!"), the per-step [question], the step-specific [field] in the
/// middle, and pushes the [footer] (typically Back / Next buttons) to the
/// bottom of the viewport.
class OnboardingStepScaffold extends StatelessWidget {
  const OnboardingStepScaffold({
    super.key,
    required this.question,
    required this.field,
    required this.footer,
  });

  final String question;
  final Widget field;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 52, 18, 28),
          child: Column(
            children: [
              const Text(
                'Hey there!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "Let's get your fitness journey started!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 42),
              Text(
                question,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.charcoal,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 22),

              field,

              const Spacer(),

              footer,
            ],
          ),
        ),
      ),
    );
  }
}
