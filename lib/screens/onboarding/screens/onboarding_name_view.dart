import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/app_colors.dart';

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

class OnboardingTextField extends StatelessWidget {
  const OnboardingTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.errorText,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.ink,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        hintStyle: const TextStyle(
          color: AppColors.coolGray,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: _border(AppColors.coolGray.withOpacity(0.55)),
        focusedBorder: _border(AppColors.primary),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: color, width: 0.8),
    );
  }
}

enum OnboardingActionVariant { filled, outlined }

class OnboardingActionButton extends StatelessWidget {
  const OnboardingActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = OnboardingActionVariant.filled,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final OnboardingActionVariant variant;

  @override
  Widget build(BuildContext context) {
    final isOutlined = variant == OnboardingActionVariant.outlined;

    return SizedBox(
      height: 48,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: _outlinedStyle,
              child: _content(AppColors.black),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: _filledStyle,
              child: _content(Colors.white),
            ),
    );
  }

  Widget _content(Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0,
          ),
        ),
        if (icon != null) ...[
          const SizedBox(width: 8),
          Icon(icon, color: color, size: 18),
        ],
      ],
    );
  }

  ButtonStyle get _filledStyle {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryLight,
      disabledBackgroundColor: AppColors.primaryLight.withOpacity(0.55),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  ButtonStyle get _outlinedStyle {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.black,
      side: const BorderSide(color: AppColors.primaryLight, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
