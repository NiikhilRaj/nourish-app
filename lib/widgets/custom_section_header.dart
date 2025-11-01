import 'package:flutter/material.dart';

/// A custom header widget that can be used as an AppBar.
///
/// This widget implements [PreferredSizeWidget] to work seamlessly with
/// Scaffold's appBar property. It provides a flexible header with optional
/// back button, title, action text, and trailing widget.
///
/// Example usage:
/// ```dart
/// CustomSectionHeader(
///   height: 100,
///   autoImplyLeading: true,
///   title: "Home",
///   actionText: "Next",
///   onActionTap: () => print("Action tapped"),
///   trailingWidget: CircleAvatar(backgroundColor: Colors.blue),
/// )
/// ```
class CustomSectionHeader extends StatelessWidget
    implements PreferredSizeWidget {
  /// The height of the header.
  ///
  /// This value is used by [preferredSize] to define the header's height
  /// when used as an AppBar.
  final double height;

  /// Optional widget to display on the trailing (right) end of the header.
  ///
  /// Commonly used for profile avatars, icons, or other action widgets.
  final Widget? trailingWidget;

  /// The main title text to display in the header.
  ///
  /// This text is displayed with a large, bold font (size 32, weight 900).
  final String title;

  /// Optional action text to display before the trailing widget.
  ///
  /// When provided along with [onActionTap], creates a tappable text element.
  /// The text appears in grey with medium weight (600).
  final String? actionText;

  /// Callback function invoked when the action text is tapped.
  ///
  /// This callback is only used when [actionText] is also provided.
  /// Both [actionText] and [onActionTap] must be non-null for the
  /// action text to be displayed.
  final Function()? onActionTap;

  /// Whether to automatically show a back button on the leading (left) side.
  ///
  /// When `true`, displays an iOS-style back button that calls
  /// `Navigator.of(context).pop()` when pressed.
  final bool autoImplyLeading;

  /// Creates a [CustomSectionHeader] widget.
  ///
  /// The [height], [autoImplyLeading], and [title] parameters are required.
  /// The [trailingWidget], [actionText], and [onActionTap] parameters are optional.

  const CustomSectionHeader({
    super.key,
    required this.height,
    required this.autoImplyLeading,
    required this.title,
    this.trailingWidget,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // SafeArea ensures content doesn't overlap with system UI elements
      // such as notches, status bars, or navigation bars
      child: Padding(
        // Add padding only on the right side for consistent spacing
        padding: EdgeInsets.only(right: 15),
        child: Row(
          children: [
            // Conditionally display back button if autoImplyLeading is true
            if (autoImplyLeading)
              IconButton(
                icon: Icon(Icons.arrow_back_ios_new_rounded),
                // Navigate back to the previous screen when pressed
                onPressed: () => Navigator.of(context).pop(),
              ),

            // Small horizontal spacing after the back button
            SizedBox(width: 8),

            // Display the main title with large, bold text
            Text(
              title,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
            ),

            // Spacer pushes all subsequent widgets to the right side
            Spacer(),

            // Conditionally display action text if both actionText and onActionTap are provided
            if (actionText != null && onActionTap != null) ...[
              // Spread operator (...) allows multiple widgets in the conditional
              GestureDetector(
                // Call the provided callback when the action text is tapped
                onTap: onActionTap,
                child: Text(
                  actionText!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ),
              // Spacing between action text and trailing widget
              SizedBox(width: 16),
            ],

            // Conditionally display trailing widget if provided
            if (trailingWidget != null) trailingWidget!,
          ],
        ),
      ),
    );
  }

  /// Required override for [PreferredSizeWidget].
  ///
  /// Returns the preferred size for this widget when used as an AppBar.
  /// The width is unconstrained (double.infinity) and the height is
  /// determined by the [height] parameter.
  @override
  Size get preferredSize => Size.fromHeight(height);
}
