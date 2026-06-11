import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Visual style for [OnboardingActionButton].
enum OnboardingActionVariant { filled, outlined }

/// Standard primary/back button used in the onboarding flow's footer.
///
/// Use [OnboardingActionVariant.filled] (default) for the primary action
/// (Next / Start) and [OnboardingActionVariant.outlined] for the secondary
/// Back action. Pass an optional [icon] (typically `Icons.chevron_right`)
/// to render next to the label.
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
      height: 52,
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
      backgroundColor: AppColors.primary,
      disabledBackgroundColor: AppColors.primaryLight,
      disabledForegroundColor: Colors.white,
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
