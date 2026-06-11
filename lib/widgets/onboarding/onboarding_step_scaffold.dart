import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      resizeToAvoidBottomInset: true, // Allows layout to adapt when keyboard opens
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. The main upper content section
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 52, 18, 0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                   Text(
                    'Hey there!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.chivo(
                      color: AppColors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Let's get your fitness journey started!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.chivo(
                      color: AppColors.ink,
                      fontSize: 16,                 // Size: 16px
                      fontWeight: FontWeight.w100,  // Weight: 100 (Thin)
                      height: 1.0,                  // Line height: 100%
                      letterSpacing: 0,             // Letter spacing: 0%
                    ),
                  ),
                  const SizedBox(height: 42),
                  Text(
                    question,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.chivo(
                      color: AppColors.ink,
                      fontSize: 14,
                      fontWeight: FontWeight.w100,
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Center(child: field),
                ]),
              ),
            ),

            // 2. The sticky footer section (Replaces Spacer)
            SliverFillRemaining(
              hasScrollBody: false, // Prevents duplicate scrolling behavior
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
                child: Align(
                  alignment: Alignment.bottomCenter, // Pushes footer down
                  child: footer,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}